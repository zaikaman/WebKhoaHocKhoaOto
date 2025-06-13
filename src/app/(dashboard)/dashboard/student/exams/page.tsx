"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"

interface Exam {
  id: string
  title: string
  description: string | null
  type: 'quiz' | 'midterm' | 'final'
  duration: number
  total_points: number
  start_time: string
  end_time: string
  status: 'upcoming' | 'in-progress' | 'completed'
  class: {
    name: string
    subject: {
      name: string
    }
  }
  submission?: {
    id: string
    score: number | null
    submitted_at: string | null
    graded_at: string | null
  }
}

export default function ExamsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exams, setExams] = useState<Exam[]>([])
  const [filteredExams, setFilteredExams] = useState<Exam[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})

  // Tạo filter options từ dữ liệu exams
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(exams.map(e => e.class.subject.name))]
    const classes = [...new Set(exams.map(e => e.class.name))]
    
    return [
      {
        key: 'subject',
        label: 'Môn học',
        type: 'select',
        options: subjects.map(subject => ({ value: subject, label: subject }))
      },
      {
        key: 'class',
        label: 'Lớp học',
        type: 'select',
        options: classes.map(className => ({ value: className, label: className }))
      },
      {
        key: 'type',
        label: 'Loại bài thi',
        type: 'select',
        options: [
          { value: 'quiz', label: 'Kiểm tra nhanh' },
          { value: 'midterm', label: 'Giữa kỳ' },
          { value: 'final', label: 'Cuối kỳ' }
        ]
      },
      {
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'upcoming', label: 'Sắp diễn ra' },
          { value: 'in-progress', label: 'Đang diễn ra' },
          { value: 'submitted', label: 'Đã nộp bài' },
          { value: 'graded', label: 'Đã chấm' },
          { value: 'completed', label: 'Đã kết thúc' }
        ]
      },
      {
        key: 'examTime',
        label: 'Thời gian thi',
        type: 'daterange'
      },
      {
        key: 'duration',
        label: 'Thời lượng',
        type: 'select',
        options: [
          { value: '0-30', label: '0-30 phút' },
          { value: '30-60', label: '30-60 phút' },
          { value: '60-90', label: '60-90 phút' },
          { value: '90+', label: 'Trên 90 phút' }
        ]
      }
    ]
  }, [exams])

  useEffect(() => {
    loadExams()
  }, [])

  // Lọc exams dựa trên search query và filters
  useEffect(() => {
    let filtered = exams

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(exam => 
        exam.title.toLowerCase().includes(query) ||
        exam.description?.toLowerCase().includes(query) ||
        exam.class.name.toLowerCase().includes(query) ||
        exam.class.subject.name.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(e => e.class.subject.name === value)
          break
        case 'class':
          filtered = filtered.filter(e => e.class.name === value)
          break
        case 'type':
          filtered = filtered.filter(e => e.type === value)
          break
        case 'status':
          filtered = filtered.filter(e => {
            const status = getExamStatus(e)
            switch (value) {
              case 'upcoming':
                return status.label === 'Sắp diễn ra'
              case 'in-progress':
                return status.label === 'Đang diễn ra'
              case 'submitted':
                return status.label === 'Đã nộp bài'
              case 'graded':
                return status.label.includes('Đã chấm')
              case 'completed':
                return status.label === 'Đã kết thúc'
              default:
                return true
            }
          })
          break
        case 'examTime':
          if (Array.isArray(value) && (value[0] || value[1])) {
            const [startDate, endDate] = value
            filtered = filtered.filter(e => {
              const examDate = new Date(e.start_time)
              const start = startDate ? new Date(startDate) : null
              const end = endDate ? new Date(endDate) : null
              
              if (start && end) {
                return examDate >= start && examDate <= end
              } else if (start) {
                return examDate >= start
              } else if (end) {
                return examDate <= end
              }
              return true
            })
          }
          break
        case 'duration':
          filtered = filtered.filter(e => {
            const duration = e.duration
            switch (value) {
              case '0-30':
                return duration >= 0 && duration <= 30
              case '30-60':
                return duration > 30 && duration <= 60
              case '60-90':
                return duration > 60 && duration <= 90
              case '90+':
                return duration > 90
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredExams(filtered)
  }, [exams, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

  async function loadExams() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      if (currentUser.profile.role !== 'student') {
        router.push('/dashboard')
        return
      }

      // Lấy danh sách lớp học của sinh viên
      const classes = await getStudentClasses(currentUser.profile.id)
      
      // Lấy danh sách bài kiểm tra từ các lớp học và submissions
      const { data: examsData, error } = await supabase
        .from('exams')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .in('class_id', classes.map(c => c.id))
        .order('start_time', { ascending: false })

      if (error) throw error

      // Lấy submissions của sinh viên
      const { data: submissionsData, error: submissionsError } = await supabase
        .from('exam_submissions')
        .select('*')
        .eq('student_id', currentUser.profile.id)
        .in('exam_id', examsData.map(e => e.id))

      if (submissionsError) throw submissionsError

      // Kết hợp thông tin bài thi và submission
      const examsWithSubmissions = examsData.map(exam => ({
        ...exam,
        submission: submissionsData?.find(s => s.exam_id === exam.id) || null
      }))

      setExams(examsWithSubmissions)
      setFilteredExams(examsWithSubmissions)

    } catch (error) {
      console.error('Lỗi khi tải danh sách bài kiểm tra:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách bài kiểm tra"
      })
    } finally {
      setIsLoading(false)
    }
  }

  function getExamStatus(exam: Exam) {
    const now = new Date()
    const startTime = new Date(new Date(exam.start_time).getTime() - 7 * 60 * 60 * 1000)
    const endTime = new Date(new Date(exam.end_time).getTime() - 7 * 60 * 60 * 1000)

    // Nếu đã có bài nộp
    if (exam.submission?.submitted_at) {
      if (exam.submission.score !== null) {
        return {
          label: `Đã chấm: ${exam.submission.score}/${exam.total_points}`,
          color: 'bg-green-100 text-green-800',
          canTakeExam: false,
          canViewResult: true
        }
      }
      return {
        label: 'Đã nộp bài',
        color: 'bg-blue-100 text-blue-800',
        canTakeExam: false,
        canViewResult: true
      }
    }

    // Nếu chưa có bài nộp
    if (now < startTime) {
      return {
        label: 'Sắp diễn ra',
        color: 'bg-yellow-100 text-yellow-800',
        canTakeExam: false,
        canViewResult: false
      }
    }

    if (now >= startTime && now <= endTime) {
      return {
        label: 'Đang diễn ra',
        color: 'bg-red-100 text-red-800',
        canTakeExam: true,
        canViewResult: false
      }
    }

    return {
      label: 'Đã kết thúc',
      color: 'bg-gray-100 text-gray-800',
      canTakeExam: false,
      canViewResult: false
    }
  }

  function getExamType(type: string) {
    switch (type) {
      case 'quiz':
        return 'Kiểm tra nhanh'
      case 'midterm':
        return 'Giữa kỳ'
      case 'final':
        return 'Cuối kỳ'
      default:
        return type
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Bài kiểm tra</h2>
        <div className="text-sm text-muted-foreground">
          Hiển thị {filteredExams.length} / {exams.length} bài kiểm tra
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài kiểm tra theo tên, mô tả, lớp học..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="rounded-lg border">
        <table className="w-full">
          <thead>
            <tr className="border-b">
              <th className="text-left py-3 px-4">Tên bài kiểm tra</th>
              <th className="text-left py-3 px-4">Môn học</th>
              <th className="text-left py-3 px-4">Loại</th>
              <th className="text-left py-3 px-4">Thời gian</th>
              <th className="text-left py-3 px-4">Thời lượng</th>
              <th className="text-left py-3 px-4">Trạng thái</th>
              <th className="text-left py-3 px-4"></th>
            </tr>
          </thead>
          <tbody>
            {filteredExams.length === 0 ? (
              <tr>
                <td colSpan={7} className="py-8 text-center text-muted-foreground">
                  {exams.length === 0 ? "Chưa có bài kiểm tra nào" : "Không tìm thấy bài kiểm tra phù hợp"}
                </td>
              </tr>
            ) : (
              filteredExams.map((exam) => {
                const status = getExamStatus(exam)
                return (
                  <tr key={exam.id} className="border-b last:border-0">
                    <td className="py-3 px-4">
                      <div className="font-medium">{exam.title}</div>
                      <div className="text-sm text-muted-foreground">{exam.class.name}</div>
                    </td>
                    <td className="py-3 px-4">{exam.class.subject.name}</td>
                    <td className="py-3 px-4">{getExamType(exam.type)}</td>
                    <td className="py-3 px-4">
                      {new Date(exam.start_time).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                        timeZone: 'UTC'
                      })}
                    </td>
                    <td className="py-3 px-4">{exam.duration} phút</td>
                    <td className="py-3 px-4">
                      <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${status.color}`}>
                        {status.label}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      {status.canTakeExam ? (
                        <Button
                          size="sm"
                          onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                        >
                          Vào thi
                        </Button>
                      ) : status.canViewResult ? (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => router.push(`/dashboard/student/exams/${exam.id}/result`)}
                        >
                          Xem kết quả
                        </Button>
                      ) : (
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                        >
                          Xem chi tiết
                        </Button>
                      )}
                    </td>
                  </tr>
                )
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
} 