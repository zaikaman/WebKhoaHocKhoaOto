"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"

interface Assignment {
  id: string
  title: string
  description: string | null
  due_date: string
  total_points: number
  file_url: string | null
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

export default function AssignmentsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [filteredAssignments, setFilteredAssignments] = useState<Assignment[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})

  // Tạo filter options từ dữ liệu assignments
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(assignments.map(a => a.class.subject.name))]
    const classes = [...new Set(assignments.map(a => a.class.name))]
    
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
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'submitted', label: 'Đã nộp' },
          { value: 'graded', label: 'Đã chấm' },
          { value: 'pending', label: 'Chưa nộp' },
          { value: 'overdue', label: 'Quá hạn' }
        ]
      },
      {
        key: 'dueDate',
        label: 'Hạn nộp',
        type: 'daterange'
      },
      {
        key: 'points',
        label: 'Điểm tối đa',
        type: 'select',
        options: [
          { value: '0-5', label: '0-5 điểm' },
          { value: '5-10', label: '5-10 điểm' },
          { value: '10+', label: 'Trên 10 điểm' }
        ]
      }
    ]
  }, [assignments])

  useEffect(() => {
    loadAssignments()
  }, [])

  // Lọc assignments dựa trên search query và filters
  useEffect(() => {
    let filtered = assignments

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(assignment => 
        assignment.title.toLowerCase().includes(query) ||
        assignment.description?.toLowerCase().includes(query) ||
        assignment.class.name.toLowerCase().includes(query) ||
        assignment.class.subject.name.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(a => a.class.subject.name === value)
          break
        case 'class':
          filtered = filtered.filter(a => a.class.name === value)
          break
        case 'status':
          filtered = filtered.filter(a => {
            const status = getSubmissionStatus(a)
            switch (value) {
              case 'submitted':
                return a.submission?.submitted_at && !a.submission?.graded_at
              case 'graded':
                return a.submission?.graded_at
              case 'pending':
                return !a.submission?.submitted_at && new Date() <= new Date(a.due_date)
              case 'overdue':
                return !a.submission?.submitted_at && new Date() > new Date(a.due_date)
              default:
                return true
            }
          })
          break
        case 'dueDate':
          if (Array.isArray(value) && (value[0] || value[1])) {
            const [startDate, endDate] = value
            filtered = filtered.filter(a => {
              const dueDate = new Date(a.due_date)
              const start = startDate ? new Date(startDate) : null
              const end = endDate ? new Date(endDate) : null
              
              if (start && end) {
                return dueDate >= start && dueDate <= end
              } else if (start) {
                return dueDate >= start
              } else if (end) {
                return dueDate <= end
              }
              return true
            })
          }
          break
        case 'points':
          filtered = filtered.filter(a => {
            const points = a.total_points
            switch (value) {
              case '0-5':
                return points >= 0 && points <= 5
              case '5-10':
                return points > 5 && points <= 10
              case '10+':
                return points > 10
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredAssignments(filtered)
  }, [assignments, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

  async function loadAssignments() {
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
      
      // Lấy danh sách bài tập từ các lớp học và submissions
      const { data: assignmentsData, error } = await supabase
        .from('assignments')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .in('class_id', classes.map(c => c.id))
        .order('due_date', { ascending: false })

      if (error) throw error

      // Lấy submissions của sinh viên
      const { data: submissionsData, error: submissionsError } = await supabase
        .from('assignment_submissions')
        .select('*')
        .eq('student_id', currentUser.profile.id)
        .in('assignment_id', assignmentsData.map(a => a.id))

      if (submissionsError) throw submissionsError

      // Kết hợp thông tin bài tập và submission
      const assignmentsWithSubmissions = assignmentsData.map(assignment => ({
        ...assignment,
        submission: submissionsData?.find(s => s.assignment_id === assignment.id) || null
      }))

      setAssignments(assignmentsWithSubmissions)
      setFilteredAssignments(assignmentsWithSubmissions)

    } catch (error) {
      console.error('Lỗi khi tải danh sách bài tập:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách bài tập"
      })
    } finally {
      setIsLoading(false)
    }
  }

  function getSubmissionStatus(assignment: Assignment) {
    const now = new Date()
    const dueDate = new Date(assignment.due_date)

    // Nếu đã có bài nộp
    if (assignment.submission?.submitted_at) {
      if (assignment.submission.graded_at) {
        return {
          label: `Đã chấm: ${assignment.submission.score}/${assignment.total_points}`,
          color: 'bg-green-100 text-green-800',
          canSubmit: false,
          canViewResult: true
        }
      }
      return {
        label: 'Đã nộp - Chờ chấm',
        color: 'bg-blue-100 text-blue-800',
        canSubmit: false,
        canViewResult: true
      }
    }

    // Nếu chưa có bài nộp
    if (now > dueDate) {
      return {
        label: 'Quá hạn',
        color: 'bg-red-100 text-red-800',
        canSubmit: false,
        canViewResult: false
      }
    }

    return {
      label: 'Chưa nộp',
      color: 'bg-yellow-100 text-yellow-800',
      canSubmit: true,
      canViewResult: false
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[200px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Bài tập</h2>
        <div className="text-sm text-muted-foreground">
          Hiển thị {filteredAssignments.length} / {assignments.length} bài tập
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài tập..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="rounded-lg border">
        <table className="w-full">
          <thead>
            <tr className="border-b">
              <th className="text-left py-3 px-4">Tên bài tập</th>
              <th className="text-left py-3 px-4">Môn học</th>
              <th className="text-left py-3 px-4">Hạn nộp</th>
              <th className="text-left py-3 px-4">Điểm</th>
              <th className="text-left py-3 px-4">Trạng thái</th>
              <th className="text-left py-3 px-4"></th>
            </tr>
          </thead>
          <tbody>
            {filteredAssignments.length === 0 ? (
              <tr>
                <td colSpan={6} className="py-8 text-center text-muted-foreground">
                  {assignments.length === 0 ? "Chưa có bài tập nào" : "Không tìm thấy bài tập phù hợp"}
                </td>
              </tr>
            ) : (
              filteredAssignments.map((assignment) => {
                const status = getSubmissionStatus(assignment)
                return (
                  <tr key={assignment.id} className="border-b last:border-0">
                    <td className="py-3 px-4">
                      <div className="font-medium">{assignment.title}</div>
                      <div className="text-sm text-muted-foreground">{assignment.class.name}</div>
                    </td>
                    <td className="py-3 px-4">{assignment.class.subject.name}</td>
                    <td className="py-3 px-4">
                      {new Date(assignment.due_date).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </td>
                    <td className="py-3 px-4">{assignment.total_points}</td>
                    <td className="py-3 px-4">
                      <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${status.color}`}>
                        {status.label}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      {status.canViewResult ? (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => router.push(`/dashboard/assignments/${assignment.id}/result`)}
                        >
                          Xem kết quả
                        </Button>
                      ) : status.canSubmit ? (
                        <Button
                          variant="default"
                          size="sm"
                          onClick={() => router.push(`/dashboard/assignments/${assignment.id}`)}
                        >
                          Nộp bài
                        </Button>
                      ) : (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => router.push(`/dashboard/assignments/${assignment.id}`)}
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