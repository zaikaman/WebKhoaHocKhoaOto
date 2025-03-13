"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { getCurrentUser, supabase } from "@/lib/supabase"

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
}

interface ExamQuestion {
  id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | null
  correct_answer: string | null
}

interface ExamSubmission {
  id: string
  answers: Record<string, string>
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
}

export default function ExamDetailPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showConfirmDialog, setShowConfirmDialog] = useState(false)
  const [exam, setExam] = useState<Exam | null>(null)
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [submission, setSubmission] = useState<ExamSubmission | null>(null)
  const [answers, setAnswers] = useState<Record<string, string>>({})
  const [timeLeft, setTimeLeft] = useState<number | null>(null)

  useEffect(() => {
    loadExam()
  }, [])

  useEffect(() => {
    if (!exam || !timeLeft) return

    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (!prev) return null
        if (prev <= 0) {
          clearInterval(timer)
          handleSubmit()
          return 0
        }
        return prev - 1
      })
    }, 1000)

    return () => clearInterval(timer)
  }, [exam, timeLeft])

  async function loadExam() {
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

      // Lấy thông tin bài kiểm tra
      const { data: examData, error: examError } = await supabase
        .from('exams')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .eq('id', params.id)
        .single()

      if (examError) throw examError
      setExam(examData)

      // Kiểm tra thời gian làm bài
      const now = new Date()
      const startTime = new Date(examData.start_time)
      const endTime = new Date(examData.end_time)

      if (now < startTime) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Bài kiểm tra chưa bắt đầu"
        })
        router.push('/dashboard/student/exams')
        return
      }

      if (now > endTime) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Bài kiểm tra đã kết thúc"
        })
        router.push('/dashboard/student/exams')
        return
      }

      // Lấy bài làm của sinh viên nếu có
      const { data: submissionData, error: submissionError } = await supabase
        .from('exam_submissions')
        .select('*')
        .eq('exam_id', params.id)
        .eq('student_id', currentUser.profile.id)
        .single()

      if (submissionError && submissionError.code !== 'PGRST116') {
        throw submissionError
      }

      if (submissionData) {
        setSubmission(submissionData)
        setAnswers(submissionData.answers || {})
        router.push('/dashboard/student/exams')
        return
      }

      // Lấy danh sách câu hỏi
      const { data: questionsData, error: questionsError } = await supabase
        .from('exam_questions')
        .select('*')
        .eq('exam_id', params.id)
        .order('created_at', { ascending: true })

      if (questionsError) throw questionsError
      setQuestions(questionsData)

      // Tính thời gian còn lại
      const timeLeft = Math.floor((endTime.getTime() - now.getTime()) / 1000)
      setTimeLeft(Math.min(timeLeft, examData.duration * 60))

    } catch (error) {
      console.error('Lỗi khi tải thông tin bài kiểm tra:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài kiểm tra"
      })
      router.push('/dashboard/student/exams')
    } finally {
      setIsLoading(false)
    }
  }

  async function handleSubmit() {
    try {
      setIsSubmitting(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      // Tạo bài làm mới
      const { error: createError } = await supabase
        .from('exam_submissions')
        .insert([{
          exam_id: params.id,
          student_id: currentUser.profile.id,
          answers,
          submitted_at: new Date().toISOString()
        }])

      if (createError) throw createError

      toast({
        title: "Thành công",
        description: "Đã nộp bài kiểm tra"
      })

      router.push('/dashboard/student/exams')

    } catch (error) {
      console.error('Lỗi khi nộp bài:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể nộp bài kiểm tra"
      })
    } finally {
      setIsSubmitting(false)
      setShowConfirmDialog(false)
    }
  }

  function formatTime(seconds: number) {
    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = seconds % 60
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!exam || !questions.length) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy bài kiểm tra</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push('/dashboard/student/exams')}
          >
            Quay lại
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="sticky top-0 z-50 bg-background border-b">
        <div className="container py-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-bold tracking-tight">{exam.title}</h2>
              <p className="text-muted-foreground">
                {exam.class.subject.name} - {exam.class.name}
              </p>
            </div>
            <div className="flex items-center gap-4">
              {timeLeft !== null && (
                <div className="text-lg font-semibold">
                  Thời gian còn lại: {formatTime(timeLeft)}
                </div>
              )}
              <Button
                disabled={isSubmitting}
                onClick={() => setShowConfirmDialog(true)}
              >
                Nộp bài
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="container pb-8">
        <div className="grid gap-6">
          {questions.map((question, index) => (
            <Card key={question.id}>
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle>Câu {index + 1}</CardTitle>
                    <CardDescription>Điểm: {question.points}</CardDescription>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label>Câu hỏi</Label>
                  <div className="text-sm">{question.content}</div>
                </div>

                {question.type === 'multiple_choice' && question.options ? (
                  <RadioGroup
                    value={answers[question.id] || ''}
                    onValueChange={(value) => setAnswers(prev => ({
                      ...prev,
                      [question.id]: value
                    }))}
                  >
                    {question.options.map((option, optionIndex) => (
                      <div key={optionIndex} className="flex items-center space-x-2">
                        <RadioGroupItem value={option} id={`${question.id}-${optionIndex}`} />
                        <Label htmlFor={`${question.id}-${optionIndex}`}>{option}</Label>
                      </div>
                    ))}
                  </RadioGroup>
                ) : (
                  <div className="space-y-2">
                    <Label htmlFor={question.id}>Câu trả lời</Label>
                    <Textarea
                      id={question.id}
                      value={answers[question.id] || ''}
                      onChange={(e) => setAnswers(prev => ({
                        ...prev,
                        [question.id]: e.target.value
                      }))}
                      rows={5}
                    />
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <Dialog open={showConfirmDialog} onOpenChange={setShowConfirmDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận nộp bài</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn nộp bài? Sau khi nộp bài, bạn sẽ không thể chỉnh sửa.
            </DialogDescription>
          </DialogHeader>
          <div className="flex justify-end gap-4">
            <Button
              variant="outline"
              onClick={() => setShowConfirmDialog(false)}
              disabled={isSubmitting}
            >
              Hủy
            </Button>
            <Button
              onClick={handleSubmit}
              disabled={isSubmitting}
            >
              {isSubmitting ? 'Đang xử lý...' : 'Nộp bài'}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
} 