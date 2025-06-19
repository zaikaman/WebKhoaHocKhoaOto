"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/components/ui/use-toast"
import { 
  getExamDetails,
  getExamQuestions,
  getExamSubmissions,
  getCurrentUser
} from "@/lib/supabase"

export default function ExamDetailPage() {
  const router = useRouter()
  const params = useParams()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exam, setExam] = useState<any>(null)
  const [questions, setQuestions] = useState<any[]>([])
  const [submissions, setSubmissions] = useState<any[]>([])

  useEffect(() => {
    loadExamData()
  }, [params.id])

  async function loadExamData() {
    try {
      setIsLoading(true)
      
      // Kiểm tra quyền truy cập
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      // Lấy thông tin exam
      const examData = await getExamDetails(params.id as string)
      setExam(examData)

      // Lấy câu hỏi
      const questionsData = await getExamQuestions(params.id as string)
      setQuestions(questionsData)

      // Lấy bài nộp
      const submissionsData = await getExamSubmissions(params.id as string)
      setSubmissions(submissionsData)

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu exam:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài kiểm tra"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'completed':
        return <Badge className="bg-green-100 text-green-700">Hoàn thành</Badge>
      case 'in-progress':
        return <Badge className="bg-blue-100 text-blue-700">Đang diễn ra</Badge>
      case 'upcoming':
        return <Badge className="bg-orange-100 text-orange-700">Sắp diễn ra</Badge>
      default:
        return <Badge variant="secondary">{status}</Badge>
    }
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

  if (!exam) {
    return (
      <div className="container mx-auto p-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Không tìm thấy bài kiểm tra</h1>
          <Button onClick={() => router.back()}>Quay lại</Button>
        </div>
      </div>
    )
  }

  return (
    <div className="container mx-auto p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Button variant="ghost" onClick={() => router.back()} className="mb-4">
            ← Quay lại
          </Button>
          <h1 className="text-3xl font-bold">{exam.title}</h1>
          <p className="text-muted-foreground mt-1">Chi tiết bài kiểm tra</p>
        </div>
        <div className="space-x-2">
          <Button 
            variant="outline"
            onClick={() => router.push(`/dashboard/teacher/exams/${exam.id}/submissions`)}
          >
            Xem bài nộp
          </Button>
          <Button 
            onClick={() => router.push(`/dashboard/teacher/exams/examQuestion?examId=${exam.id}`)}
          >
            Quản lý câu hỏi
          </Button>
        </div>
      </div>

      {/* Thông tin cơ bản */}
      <Card>
        <CardHeader>
          <CardTitle>Thông tin bài kiểm tra</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Trạng thái</p>
              <div className="mt-1">{getStatusBadge(exam.status)}</div>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Loại</p>
              <p className="font-medium capitalize">{exam.type}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Thời gian</p>
              <p className="font-medium">{exam.duration} phút</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Tổng điểm</p>
              <p className="font-medium">{exam.total_points} điểm</p>
            </div>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Thời gian bắt đầu</p>
              <p className="font-medium">
                {new Date(exam.start_time).toLocaleString('vi-VN')}
              </p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Thời gian kết thúc</p>
              <p className="font-medium">
                {new Date(exam.end_time).toLocaleString('vi-VN')}
              </p>
            </div>
          </div>

          {exam.description && (
            <div>
              <p className="text-sm text-muted-foreground">Mô tả</p>
              <p className="mt-1">{exam.description}</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Thống kê */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">{questions.length}</p>
              <p className="text-sm text-muted-foreground">Câu hỏi</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">{submissions.length}</p>
              <p className="text-sm text-muted-foreground">Bài nộp</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-6">
            <div className="text-center">
              <p className="text-2xl font-bold">
                {submissions.length > 0 
                  ? (submissions.reduce((sum, s) => sum + (s.score || 0), 0) / submissions.length).toFixed(1)
                  : "0.0"
                }
              </p>
              <p className="text-sm text-muted-foreground">Điểm trung bình</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Danh sách câu hỏi */}
      <Card>
        <CardHeader>
          <CardTitle>Câu hỏi ({questions.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {questions.length === 0 ? (
            <div className="text-center py-8">
              <p className="text-muted-foreground">Chưa có câu hỏi nào</p>
              <Button 
                className="mt-4"
                onClick={() => router.push(`/dashboard/teacher/exams/examQuestion?examId=${exam.id}`)}
              >
                Thêm câu hỏi
              </Button>
            </div>
          ) : (
            <div className="space-y-4">
              {questions.map((question, index) => (
                <div key={question.id} className="border rounded-lg p-4">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <h4 className="font-medium">
                        Câu {index + 1}: {question.content}
                      </h4>
                      <div className="mt-2 flex items-center gap-4 text-sm text-muted-foreground">
                        <span>Loại: {question.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}</span>
                        <span>Điểm: {question.points}</span>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  )
} 