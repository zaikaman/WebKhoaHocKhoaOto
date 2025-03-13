"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"

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

  useEffect(() => {
    loadAssignments()
  }, [])

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
      
      // Lấy danh sách bài tập từ các lớp học
      const { data: assignmentsData, error } = await supabase
        .from('assignments')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          ),
          submission:assignment_submissions(
            id,
            score,
            submitted_at,
            graded_at
          )
        `)
        .in('class_id', classes.map(c => c.id))
        .order('due_date', { ascending: false })

      if (error) throw error
      setAssignments(assignmentsData)

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
    if (!assignment.submission) {
      return {
        label: 'Chưa nộp',
        color: 'bg-yellow-100 text-yellow-800'
      }
    }

    if (assignment.submission.graded_at) {
      return {
        label: `Đã chấm: ${assignment.submission.score}/${assignment.total_points}`,
        color: 'bg-green-100 text-green-800'
      }
    }

    return {
      label: 'Đã nộp',
      color: 'bg-blue-100 text-blue-800'
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
        <h2 className="text-3xl font-bold tracking-tight">Bài tập</h2>
      </div>

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
            {assignments.map((assignment) => {
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
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => router.push(`/dashboard/assignments/${assignment.id}`)}
                    >
                      {assignment.submission ? 'Xem chi tiết' : 'Nộp bài'}
                    </Button>
                  </td>
                </tr>
              )
            })}

            {assignments.length === 0 && (
              <tr>
                <td colSpan={6} className="py-8 text-center text-muted-foreground">
                  Không có bài tập nào
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
} 