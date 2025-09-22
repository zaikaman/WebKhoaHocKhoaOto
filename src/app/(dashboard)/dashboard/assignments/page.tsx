"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import { RefreshCw } from "lucide-react"

interface AssignmentSubmission {
  id: string;
  assignment_id: string;
  student_id: string;
  score: number | null;
  submitted_at: string | null;
  graded_at: string | null;
}

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
  submissions: AssignmentSubmission[]
}

export default function AssignmentsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [filteredAssignments, setFilteredAssignments] = useState<Assignment[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})

  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(assignments.map(a => a.class.subject.name))]
    const classes = [...new Set(assignments.map(a => a.class.name))]
    
    return [
      { key: 'subject', label: 'Môn học', type: 'select', options: subjects.map(s => ({ value: s, label: s })) },
      { key: 'class', label: 'Lớp học', type: 'select', options: classes.map(c => ({ value: c, label: c })) },
      { key: 'status', label: 'Trạng thái', type: 'select', options: [
          { value: 'can_submit', label: 'Chưa làm' },
          { value: 'due_soon', label: 'Sắp hết hạn' },
          { value: 'submitted', label: 'Đã nộp' },
          { value: 'overdue', label: 'Quá hạn' }
      ]},
    ]
  }, [assignments])

  useEffect(() => {
    loadAssignments()
  }, [])

  useEffect(() => {
    let filtered = assignments

    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(assignment => 
        assignment.title.toLowerCase().includes(query) ||
        (assignment.description && assignment.description.toLowerCase().includes(query)) ||
        assignment.class.name.toLowerCase().includes(query) ||
        assignment.class.subject.name.toLowerCase().includes(query)
      )
    }

    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "") return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(a => a.class.subject.name === value)
          break
        case 'class':
          filtered = filtered.filter(a => a.class.name === value)
          break
        case 'status':
          filtered = filtered.filter(a => {
            const status = getSubmissionStatus(a).key
            return status === value
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
      
      if (!currentUser || currentUser.profile.role !== 'student') {
        router.push('/login')
        return
      }

      const classes = await getStudentClasses(currentUser.profile.id)
      if (classes.length === 0) {
        setAssignments([]);
        setFilteredAssignments([]);
        setIsLoading(false);
        return;
      }
      
      const { data: assignmentsData, error } = await supabase
        .from('assignments')
        .select(`*, class:classes(name, subject:subjects(name))`)
        .in('class_id', classes.map(c => c.id))
        .order('due_date', { ascending: false })

      if (error) throw error

      const { data: submissionsData, error: submissionsError } = await supabase
        .from('assignment_submissions')
        .select('id, assignment_id, student_id, score, submitted_at, graded_at')
        .eq('student_id', currentUser.profile.id)
        .in('assignment_id', assignmentsData.map(a => a.id))

      if (submissionsError) throw submissionsError

      const assignmentsWithSubmissions = assignmentsData.map(assignment => ({
        ...assignment,
        submissions: submissionsData?.filter(s => s.assignment_id === assignment.id) || []
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
    const now = new Date();
    const dueDate = new Date(new Date(assignment.due_date).getTime() - 7 * 60 * 60 * 1000);
    const diffTime = dueDate.getTime() - now.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    const isDueSoon = diffDays <= 3 && diffDays >= 0;

    const highestScore = assignment.submissions.length > 0
        ? Math.max(...assignment.submissions.map(s => s.score || 0))
        : null;

    if (now > dueDate) {
      return {
        key: 'overdue',
        label: highestScore !== null ? `Quá hạn - Điểm: ${highestScore}/${assignment.total_points}` : 'Quá hạn',
        color: 'bg-red-100 text-red-800',
        action: 'view'
      };
    }

    if (assignment.submissions.length > 0) {
      const gradedCount = assignment.submissions.filter(s => s.graded_at).length;
      const allGraded = gradedCount === assignment.submissions.length;
      return {
        key: 'submitted',
        label: allGraded ? `Đã nộp - Điểm cao nhất: ${highestScore}/${assignment.total_points}` : `Chờ chấm (${assignment.submissions.length} lần)`,
        color: 'bg-green-100 text-green-800',
        action: 'retake'
      };
    }
    
    if (isDueSoon) {
      return {
        key: 'due_soon',
        label: `Sắp hết hạn (${diffDays} ngày)`,
        color: 'bg-yellow-100 text-yellow-800',
        action: 'take'
      };
    }

    return {
      key: 'can_submit',
      label: 'Chưa nộp',
      color: 'bg-blue-100 text-blue-800',
      action: 'take'
    };
  }

  if (isLoading) {
    return (
      <div className="space-y-8">
        <div className="flex items-center justify-between"><div className="h-8 w-32 bg-muted rounded animate-pulse" /></div>
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
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight w-full sm:w-auto sm:text-left">Bài tập</h2>
        <div className="flex gap-2 items-center">
            <div className="text-sm text-muted-foreground w-full sm:w-auto sm:text-right">
              Hiển thị {filteredAssignments.length} / {assignments.length} bài tập
            </div>
            <Button variant="outline" onClick={loadAssignments} disabled={isLoading}>
                <RefreshCw className={`w-4 h-4 mr-2 ${isLoading ? 'animate-spin' : ''}`} />
                Làm mới
            </Button>
        </div>
      </div>

      <SearchFilter
        searchPlaceholder="Tìm kiếm bài tập..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="rounded-lg border overflow-x-auto">
        <table className="min-w-[700px] w-full">
          <thead>
            <tr className="border-b">
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Tên bài tập</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Môn học</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Hạn nộp</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Điểm</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Trạng thái</th>
              <th className="text-left py-2 px-2 sm:py-3 sm:px-4"></th>
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
                const isDueSoon = status.key === 'due_soon';

                return (
                  <tr key={assignment.id} className={`border-b last:border-0 ${isDueSoon ? 'bg-yellow-50' : ''}`}>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      <div className="font-medium">{assignment.title}</div>
                      <div className="text-sm text-muted-foreground">{assignment.class.name}</div>
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">{assignment.class.subject.name}</td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      {new Date(assignment.due_date).toLocaleString('vi-VN', {
                        year: 'numeric', month: '2-digit', day: '2-digit',
                        hour: '2-digit', minute: '2-digit', timeZone: 'Asia/Ho_Chi_Minh'
                      })}
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">{assignment.total_points}</td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                      <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs text-center font-medium ${status.color}`}>
                        {status.label}
                      </span>
                    </td>
                    <td className="py-2 px-2 sm:py-3 sm:px-4">
                       <Button
                          size="sm"
                          variant={status.action === 'view' ? 'outline' : 'default'}
                          onClick={() => router.push(`/dashboard/student/assignments/${assignment.id}`)}
                        >
                          {status.action === 'take' ? 'Làm bài' : (status.action === 'retake' ? 'Làm lại' : 'Xem chi tiết')}
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