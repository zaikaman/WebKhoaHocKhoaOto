"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/components/ui/use-toast"
import { 
  getCurrentUser,
  supabase
} from "@/lib/supabase"

interface Assignment {
  id: string
  title: string
  description: string | null
  type: 'multiple_choice' | 'essay'
  due_date: string
  total_points: number
  file_url: string | null
  created_at: string
  updated_at: string
  class: {
    id: string
    name: string
    subject: {
      name: string
      code: string
    }
  }
}

interface AssignmentSubmission {
  id: string
  student_id: string
  content: string | null
  file_url: string | null
  answers?: Record<string, string>
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
  student: {
    full_name: string
    student_id: string
  }
}

export default function TeacherAssignmentDetailPage() {
  const router = useRouter()
  const params = useParams()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submissions, setSubmissions] = useState<AssignmentSubmission[]>([])

  useEffect(() => {
    loadAssignmentData()
  }, [params.id])

  async function loadAssignmentData() {
    try {
      setIsLoading(true)
      
      // Kiểm tra quyền truy cập
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      // Lấy thông tin assignment
      const { data: assignmentData, error: assignmentError } = await supabase
        .from('assignments')
        .select(`
          *,
          class:classes(
            id,
            name,
            subject:subjects(
              name,
              code
            )
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      // Lấy danh sách bài nộp
      const { data: submissionsData, error: submissionsError } = await supabase
        .from('assignment_submissions')
        .select(`
          *,
          student:profiles(
            full_name,
            student_id
          )
        `)
        .eq('assignment_id', params.id)

      if (submissionsError) throw submissionsError
      setSubmissions(submissionsData || [])

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu assignment:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài tập"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const getStatusBadge = () => {
    if (!assignment) return null
    
    const now = new Date()
    const dueDate = new Date(assignment.due_date)
    
    if (now > dueDate) {
      return <Badge className="bg-red-100 text-red-700">Đã hết hạn</Badge>
    } else {
      return <Badge className="bg-green-100 text-green-700">Đang mở</Badge>
    }
  }

  const getTypeBadge = (type: string) => {
    switch (type) {
      case 'multiple_choice':
        return <Badge className="bg-blue-100 text-blue-700">Trắc nghiệm</Badge>
      case 'essay':
        return <Badge className="bg-purple-100 text-purple-700">Tự luận</Badge>
      default:
        return <Badge variant="secondary">{type}</Badge>
    }
  }

  const getSubmissionStats = () => {
    const total = submissions.length
    const graded = submissions.filter(s => s.graded_at).length
    const avgScore = submissions.length > 0 
      ? submissions.reduce((sum, s) => sum + (s.score || 0), 0) / submissions.length
      : 0

    return { total, graded, avgScore }
  }

  if (isLoading) {
    return (
      <div className="container mx-auto p-6">
        <div className="animate-pulse space-y-6">
          <div className="h-8 bg-gray-200 rounded w-1/3"></div>
          <div className="h-40 bg-gray-200 rounded"></div>
          <div className="h-32 bg-gray-200 rounded"></div>
        </div>
      </div>
    )
  }

  if (!assignment) {
    return (
      <div className="container mx-auto p-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Không tìm thấy bài tập</h1>
          <Button onClick={() => router.back()}>Quay lại</Button>
        </div>
      </div>
    )
  }

  const stats = getSubmissionStats()

  return (
    <div className="container mx-auto p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Button variant="ghost" onClick={() => router.back()} className="mb-4">
            ← Quay lại
          </Button>
          <h1 className="text-3xl font-bold">{assignment.title}</h1>
          <p className="text-muted-foreground mt-1">
            {assignment.class.subject.name} - {assignment.class.name}
          </p>
        </div>
        <div className="space-x-2">
          <Button 
            variant="outline"
            onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}/submissions`)}
          >
            Xem bài nộp ({stats.total})
          </Button>
          <Button 
            onClick={() => router.push(`/dashboard/teacher/assignments`)}
          >
            Chỉnh sửa
          </Button>
        </div>
      </div>

      {/* Thông tin cơ bản */}
      <Card>
        <CardHeader>
          <CardTitle>Thông tin bài tập</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Trạng thái</p>
              <div className="mt-1">{getStatusBadge()}</div>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Loại</p>
              <div className="mt-1">{getTypeBadge(assignment.type)}</div>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Tổng điểm</p>
              <p className="font-medium">{assignment.total_points} điểm</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Hạn nộp</p>
              <p className="font-medium">
                {new Date(assignment.due_date).toLocaleString('vi-VN')}
              </p>
            </div>
          </div>

          {assignment.description && (
            <div>
              <p className="text-sm text-muted-foreground">Mô tả</p>
              <p className="mt-1 p-3 bg-gray-50 rounded-lg">{assignment.description}</p>
            </div>
          )}

          {assignment.file_url && (
            <div>
              <p className="text-sm text-muted-foreground">File đính kèm</p>
              <Button variant="outline" className="mt-1" asChild>
                <a href={assignment.file_url} target="_blank" rel="noopener noreferrer">
                  📎 Tải xuống file
                </a>
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Thống kê */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">{stats.total}</p>
              <p className="text-sm text-muted-foreground">Tổng bài nộp</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">{stats.graded}</p>
              <p className="text-sm text-muted-foreground">Đã chấm điểm</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">{stats.total - stats.graded}</p>
              <p className="text-sm text-muted-foreground">Chờ chấm điểm</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">
                {stats.avgScore.toFixed(1)}
              </p>
              <p className="text-sm text-muted-foreground">Điểm trung bình</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Danh sách bài nộp gần đây */}
      <Card>
        <CardHeader>
          <CardTitle>Bài nộp gần đây</CardTitle>
        </CardHeader>
        <CardContent>
          {submissions.length === 0 ? (
            <div className="text-center py-8">
              <p className="text-muted-foreground">Chưa có bài nộp nào</p>
            </div>
          ) : (
            <div className="space-y-4">
              {submissions.slice(0, 5).map((submission) => (
                <div key={submission.id} className="border rounded-lg p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h4 className="font-medium">
                        {submission.student.full_name} ({submission.student.student_id})
                      </h4>
                      <p className="text-sm text-muted-foreground">
                        Nộp lúc: {submission.submitted_at 
                          ? new Date(submission.submitted_at).toLocaleString('vi-VN')
                          : 'Chưa nộp'
                        }
                      </p>
                    </div>
                    <div className="text-right">
                      {submission.score !== null ? (
                        <div>
                          <p className="font-bold text-lg">
                            {submission.score}/{assignment.total_points}
                          </p>
                          <p className="text-sm text-muted-foreground">
                            {submission.graded_at 
                              ? `Chấm lúc: ${new Date(submission.graded_at).toLocaleDateString('vi-VN')}`
                              : 'Đã chấm'
                            }
                          </p>
                        </div>
                      ) : (
                        <Badge variant="outline">Chờ chấm điểm</Badge>
                      )}
                    </div>
                  </div>
                </div>
              ))}
              {submissions.length > 5 && (
                <div className="text-center">
                  <Button 
                    variant="outline"
                    onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}/submissions`)}
                  >
                    Xem tất cả ({submissions.length} bài nộp)
                  </Button>
                </div>
              )}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  )
} 