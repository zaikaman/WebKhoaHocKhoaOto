"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, supabase } from "@/lib/supabase"

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

  useEffect(() => {
    loadExams()
  }, [])

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
      
      // Lấy danh sách bài kiểm tra từ các lớp học
      const { data: examsData, error } = await supabase
        .from('exams')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          ),
          submission:exam_submissions(
            id,
            score,
            submitted_at,
            graded_at
          )
        `)
        .in('class_id', classes.map(c => c.id))
        .order('start_time', { ascending: false })

      if (error) throw error
      setExams(examsData)

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
    const startTime = new Date(exam.start_time)
    const endTime = new Date(exam.end_time)

    if (exam.submission?.submitted_at) {
      if (exam.submission.graded_at) {
        return {
          label: `Đã chấm: ${exam.submission.score}/${exam.total_points}`,
          color: 'bg-green-100 text-green-800',
          canTakeExam: false
        }
      }
      return {
        label: 'Đã nộp bài',
        color: 'bg-blue-100 text-blue-800',
        canTakeExam: false
      }
    }

    if (now < startTime) {
      return {
        label: 'Sắp diễn ra',
        color: 'bg-yellow-100 text-yellow-800',
        canTakeExam: false
      }
    }

    if (now >= startTime && now <= endTime) {
      return {
        label: 'Đang diễn ra',
        color: 'bg-red-100 text-red-800',
        canTakeExam: true
      }
    }

    return {
      label: 'Đã kết thúc',
      color: 'bg-gray-100 text-gray-800',
      canTakeExam: false
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
      </div>

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
            {exams.map((exam) => {
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
                      minute: '2-digit'
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
                    ) : exam.submission ? (
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                      >
                        Xem chi tiết
                      </Button>
                    ) : null}
                  </td>
                </tr>
              )
            })}

            {exams.length === 0 && (
              <tr>
                <td colSpan={7} className="py-8 text-center text-muted-foreground">
                  Không có bài kiểm tra nào
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
} 