"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import { RefreshCw } from "lucide-react"

interface ExamSubmission {
  id: string;
  exam_id: string;
  student_id: string;
  score: number | null;
  submitted_at: string | null;
  status: 'in-progress' | 'completed';
}

interface Exam {
  id: string
  title: string
  description: string | null
  type: 'quiz' | 'midterm' | 'final'
  duration: number
  total_points: number
  start_time: string
  end_time: string
  max_attempts: number
  class: {
    name: string
    subject: {
      name: string
    }
  }
  submissions: ExamSubmission[]
}

export default function ExamsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exams, setExams] = useState<Exam[]>([])
  const [filteredExams, setFilteredExams] = useState<Exam[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})

  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(exams.map(e => e.class.subject.name))]
    const classes = [...new Set(exams.map(e => e.class.name))]
    
    return [
      { key: 'subject', label: 'Môn học', type: 'select', options: subjects.map(s => ({ value: s, label: s })) },
      { key: 'class', label: 'Lớp học', type: 'select', options: classes.map(c => ({ value: c, label: c })) },
      { key: 'type', label: 'Loại bài thi', type: 'select', options: [
          { value: 'quiz', label: 'Kiểm tra nhanh' },
          { value: 'midterm', label: 'Giữa kỳ' },
          { value: 'final', label: 'Cuối kỳ' }
      ]},
      { key: 'status', label: 'Trạng thái', type: 'select', options: [
          { value: 'can_take', label: 'Có thể làm' },
          { value: 'completed', label: 'Hết lượt' },
          { value: 'upcoming', label: 'Sắp diễn ra' },
          { value: 'ended', label: 'Đã kết thúc' }
      ]},
    ]
  }, [exams])

  useEffect(() => {
    loadExams()
  }, [])

  useEffect(() => {
    let filtered = exams

    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(exam => 
        exam.title.toLowerCase().includes(query) ||
        exam.class.name.toLowerCase().includes(query) ||
        exam.class.subject.name.toLowerCase().includes(query)
      )
    }

    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "") return

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
            const status = getExamStatus(e).key
            return status === value
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
      
      if (!currentUser || currentUser.profile.role !== 'student') {
        router.push('/login')
        return
      }

      const classes = await getStudentClasses(currentUser.profile.id)
      if (classes.length === 0) {
        setExams([]);
        setFilteredExams([]);
        setIsLoading(false);
        return;
      }
      
      const { data: examsData, error } = await supabase
        .from('exams')
        .select(`*, class:classes(name, subject:subjects(name))`)
        .in('class_id', classes.map(c => c.id))
        .order('start_time', { ascending: false })

      if (error) throw error

      const { data: submissionsData, error: submissionsError } = await supabase
        .from('exam_submissions')
        .select('id, exam_id, student_id, score, submitted_at, status')
        .eq('student_id', currentUser.profile.id)
        .in('exam_id', examsData.map(e => e.id))

      if (submissionsError) throw submissionsError

      const examsWithSubmissions = examsData.map(exam => ({
        ...exam,
        submissions: submissionsData?.filter(s => s.exam_id === exam.id) || []
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
    const now = new Date();
    const startTime = new Date(new Date(exam.start_time).getTime() - 7 * 60 * 60 * 1000);
    const endTime = new Date(new Date(exam.end_time).getTime() - 7 * 60 * 60 * 1000);

    const completedSubmissions = exam.submissions.filter(s => s.status === 'completed');
    const maxAttempts = exam.max_attempts || 1;
    const attemptsLeft = maxAttempts - completedSubmissions.length;
    const highestScore = completedSubmissions.length > 0 
        ? Math.max(...completedSubmissions.map(s => s.score || 0))
        : null;

    if (now > endTime) {
      return {
        key: 'ended',
        label: highestScore !== null ? `Đã kết thúc - Điểm: ${highestScore}/${exam.total_points}` : 'Đã kết thúc',
        color: 'bg-gray-100 text-gray-800',
        action: 'view'
      };
    }

    if (attemptsLeft <= 0) {
      return {
        key: 'completed',
        label: `Hết lượt - Điểm: ${highestScore}/${exam.total_points}`,
        color: 'bg-blue-100 text-blue-800',
        action: 'view'
      };
    }
    
    if (now < startTime) {
      return {
        key: 'upcoming',
        label: 'Sắp diễn ra',
        color: 'bg-yellow-100 text-yellow-800',
        action: 'view'
      };
    }

    return {
      key: 'can_take',
      label: `Đang diễn ra - Còn ${attemptsLeft} lượt`,
      color: 'bg-red-100 text-red-800',
      action: 'take'
    };
  }

  function getExamType(type: string) {
    switch (type) {
      case 'quiz': return 'Kiểm tra nhanh'
      case 'midterm': return 'Giữa kỳ'
      case 'final': return 'Cuối kỳ'
      default: return type
    }
  }

  if (isLoading) {
    return (
      <div className="space-y-8">
        <div className="flex items-center justify-between">
          <div className="h-8 w-32 bg-muted rounded animate-pulse" />
          <div className="h-4 w-48 bg-muted rounded animate-pulse" />
        </div>
        <div className="space-y-4">
          <div className="flex gap-2"><div className="relative flex-1"><div className="h-10 w-full bg-muted rounded animate-pulse" /></div><div className="h-10 w-24 bg-muted rounded animate-pulse" /></div>
          <div className="flex flex-wrap gap-2"><div className="h-6 w-24 bg-muted rounded animate-pulse" /><div className="h-6 w-32 bg-muted rounded animate-pulse" /><div className="h-6 w-28 bg-muted rounded animate-pulse" /></div>
        </div>
        <div className="rounded-lg border"><div className="p-4"><table className="w-full">
          <thead><tr className="border-b"><th className="text-left py-3 px-4"><div className="h-4 w-32 bg-muted rounded animate-pulse" /></th><th className="text-left py-3 px-4"><div className="h-4 w-24 bg-muted rounded animate-pulse" /></th><th className="text-left py-3 px-4"><div className="h-4 w-28 bg-muted rounded animate-pulse" /></th><th className="text-left py-3 px-4"><div className="h-4 w-20 bg-muted rounded animate-pulse" /></th><th className="text-left py-3 px-4"><div className="h-4 w-24 bg-muted rounded animate-pulse" /></th><th className="text-left py-3 px-4"><div className="h-4 w-20 bg-muted rounded animate-pulse" /></th></tr></thead>
          <tbody>{[...Array(5)].map((_, index) => (<tr key={index} className="border-b last:border-0"><td className="py-3 px-4"><div className="space-y-2"><div className="h-5 w-48 bg-muted rounded animate-pulse" /><div className="h-4 w-32 bg-muted rounded animate-pulse" /></div></td><td className="py-3 px-4"><div className="h-4 w-36 bg-muted rounded animate-pulse" /></td><td className="py-3 px-4"><div className="h-4 w-40 bg-muted rounded animate-pulse" /></td><td className="py-3 px-4"><div className="h-4 w-16 bg-muted rounded animate-pulse" /></td><td className="py-3 px-4"><div className="h-6 w-24 bg-muted rounded-full animate-pulse" /></td><td className="py-3 px-4"><div className="h-8 w-20 bg-muted rounded animate-pulse" /></td></tr>))}</tbody>
        </table></div></div>
      </div>
    )
  }
  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight w-full sm:w-auto sm:text-left">Bài kiểm tra</h2>
        <div className="flex gap-2 items-center">
            <div className="text-sm text-muted-foreground w-full sm:w-auto sm:text-right">
              Hiển thị {filteredExams.length} / {exams.length} bài kiểm tra
            </div>
            <Button variant="outline" onClick={loadExams} disabled={isLoading}>
                <RefreshCw className={`w-4 h-4 mr-2 ${isLoading ? 'animate-spin' : ''}`} />
                Làm mới
            </Button>
        </div>
      </div>

      <SearchFilter
        searchPlaceholder="Tìm kiếm bài kiểm tra..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="rounded-lg border overflow-x-auto">
        <table className="min-w-[700px] w-full">
          <thead>
            <tr className="border-b">
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Tên bài kiểm tra</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Môn học</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Loại</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời gian</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời lượng</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Trạng thái</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4"></th>
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
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      <div className="font-medium">{exam.title}</div>
                      <div className="text-sm text-muted-foreground">{exam.class.name}</div>
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.class.subject.name}</td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">{getExamType(exam.type)}</td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      {new Date(exam.start_time).toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit',
                        hour: '2-digit', minute: '2-digit', timeZone: 'Asia/Ho_Chi_Minh'
                      })}
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.duration} phút</td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4 text-center">
                      <span className={`inline-flex items-center justify-center rounded-full px-2.5 py-0.5 text-xs font-medium ${status.color}`}>
                        {status.label}
                      </span>
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      <Button
                        size="sm"
                        variant={status.action === 'take' ? 'default' : 'outline'}
                        onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                      >
                        {status.action === 'take' ? 'Vào thi' : 'Xem chi tiết'}
                      </Button>
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
