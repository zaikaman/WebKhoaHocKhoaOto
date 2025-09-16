"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { getCurrentUser, supabase } from "@/lib/supabase"

interface Assignment {
  id: string
  title: string
  description: string | null
  due_date: string
  total_points: number
  class_id: string
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

interface AssignmentQuestion {
  id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | null
  correct_answer: string | null
}

interface AssignmentSubmission {
  id: string
  answers: Record<string, string>
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
}

export default function AssignmentTakingPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showConfirmDialog, setShowConfirmDialog] = useState(false)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [questions, setQuestions] = useState<AssignmentQuestion[]>([])
  const [submission, setSubmission] = useState<AssignmentSubmission | null>(null)
  const [answers, setAnswers] = useState<Record<string, string>>({})

  useEffect(() => {
    loadAssignment()
  }, [])

  async function loadAssignment() {
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

      const { data: assignmentData, error: assignmentError } = await supabase
        .from('assignments')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      const now = new Date()
      const dueDate = new Date(new Date(assignmentData.due_date).getTime() - 7 * 60 * 60 * 1000)

      if (now > dueDate) {
        toast({
          variant: "destructive",
          title: "Đã quá hạn",
          description: "Bài tập này đã hết hạn nộp bài."
        })
      }

      const { data: submissionData, error: submissionError } = await supabase
        .from('assignment_submissions')
        .select('*')
        .eq('assignment_id', params.id)
        .eq('student_id', currentUser.profile.id)
        .single()

      if (submissionError && submissionError.code !== 'PGRST116') {
        throw submissionError
      }

      if (submissionData) {
        toast({ title: "Thông báo", description: "Bạn đã nộp bài tập này." });
        router.push(`/dashboard/student/courses/${assignmentData.class_id}`)
        return
      }

      const { data: questionsData, error: questionsError } = await supabase
        .from('assignment_questions')
        .select('*')
        .eq('assignment_id', params.id)
        .order('created_at', { ascending: true })

      if (questionsError) {
        throw questionsError
      }

      setQuestions(questionsData || [])

    } catch (error) {
      console.error('Lỗi khi tải bài tập:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài tập"
      })
      router.push('/dashboard/student/courses')
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

      const unansweredQuestions = questions.filter(q => !answers[q.id])
      if (unansweredQuestions.length > 0) {
        toast({
          variant: "destructive",
          title: "Chưa hoàn thành",
          description: `Bạn chưa trả lời ${unansweredQuestions.length} câu hỏi`
        })
        setShowConfirmDialog(false)
        return
      }

      if (Object.keys(answers).length === 0) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Bạn chưa trả lời câu hỏi nào"
        })
        return
      }

      const hasEssayQuestion = questions.some(q => q.type === 'essay')
      
      let score = null
      if (!hasEssayQuestion) {
        score = questions.reduce((total, question) => {
          const isCorrect = answers[question.id] === question.correct_answer
          return total + (isCorrect ? question.points : 0)
        }, 0)
      }

      const { data: submissionData, error: createError } = await supabase
        .from('assignment_submissions')
        .insert([{
          assignment_id: params.id,
          student_id: currentUser.profile.id,
          answers,
          score,
          submitted_at: new Date().toISOString(),
          graded_at: !hasEssayQuestion ? new Date().toISOString() : null
        }])
        .select()
        .single()

      if (createError) {
        throw createError
      }

      toast({
        title: "Thành công",
        description: !hasEssayQuestion 
          ? `Đã nộp và chấm bài. Điểm của bạn: ${score}/${assignment?.total_points}`
          : "Đã nộp bài tập thành công."
      })

      router.push(`/dashboard/student/courses/${assignment?.class_id}`)

    } catch (error) {
      console.error('Lỗi khi nộp bài:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể nộp bài tập"
      })
    } finally {
      setIsSubmitting(false)
      setShowConfirmDialog(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[200px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!assignment) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy bài tập</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push('/dashboard/student/courses')}
          >
            Quay lại
          </Button>
        </div>
      </div>
    )
  }

  if (!questions.length) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Bài tập chưa có câu hỏi</h2>
          <p className="mt-2 text-muted-foreground">Vui lòng liên hệ giảng viên để biết thêm chi tiết.</p>
          <Button 
            className="mt-4" 
            onClick={() => router.push(`/dashboard/student/courses/${assignment.class_id}`)}
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
        <div className="container max-w-screen-2xl py-2 sm:py-4">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
            <div className="w-full sm:w-auto">
              <h2 className="text-xl sm:text-2xl font-bold tracking-tight">Bài tập: {assignment.title}</h2>
              <p className="text-muted-foreground">
                {assignment.class.subject.name} - {assignment.class.name}
              </p>
            </div>
            <div className="flex flex-col sm:flex-row items-center gap-2 sm:gap-4 w-full sm:w-auto">
                <div className="text-base sm:text-lg font-semibold">
                    Hạn nộp: {new Date(new Date(assignment.due_date).getTime() - 7 * 60 * 60 * 1000).toLocaleString('vi-VN')}
                </div>
              <Button
                className="w-full sm:w-auto"
                disabled={isSubmitting}
                onClick={() => setShowConfirmDialog(true)}
              >
                Nộp bài
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="container max-w-screen-2xl pb-8 px-2 sm:px-0">
        <div className="grid gap-4 sm:gap-6">
          {questions.map((question, index) => (
            <Card key={question.id} className="w-full">
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
                  <Label htmlFor={`question-${question.id}`}>Câu hỏi</Label>
                  <div className="text-sm">{question.content}</div>
                </div>

                {question.type === 'multiple_choice' ? (
                  <div className="space-y-3 w-full">
                    {(() => {
                      try {
                        const options: string[] = typeof question.options === 'string' 
                          ? JSON.parse(question.options) 
                          : question.options || [];
                        return options.map((option: string, optionIndex: number) => (
                          <div key={optionIndex} className="flex items-center space-x-3">
                            <input
                              type="radio"
                              id={`${question.id}-${optionIndex}`}
                              name={`question-${question.id}`}
                              value={option}
                              checked={answers[question.id] === option}
                              onChange={(e) => setAnswers(prev => ({
                                ...prev,
                                [question.id]: e.target.value
                              }))}
                              className="h-4 w-4 border-gray-300 text-primary focus:ring-2 focus:ring-primary"
                            />
                            <label 
                              htmlFor={`${question.id}-${optionIndex}`}
                              className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                            >
                              {option}
                            </label>
                          </div>
                        ));
                      } catch (error) {
                        console.error('Lỗi khi parse options:', error);
                        return <div className="text-red-500">Lỗi hiển thị câu hỏi</div>;
                      }
                    })()}
                  </div>
                ) : (
                  <div className="space-y-4 w-full">
                    <Textarea
                      value={answers[question.id] || ''}
                      onChange={(e) => setAnswers(prev => ({
                        ...prev,
                        [question.id]: e.target.value
                      }))}
                      placeholder="Nhập câu trả lời của bạn vào đây..."
                      className="min-h-[200px] text-base w-full"
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
          <div className="flex flex-col sm:flex-row justify-end gap-2 sm:gap-4">
            <Button
              variant="outline"
              onClick={() => setShowConfirmDialog(false)}
              disabled={isSubmitting}
              className="w-full sm:w-auto"
            >
              Hủy
            </Button>
            <Button
              onClick={handleSubmit}
              disabled={isSubmitting}
              className="w-full sm:w-auto"
            >
              {isSubmitting ? 'Đang xử lý...' : 'Nộp bài'}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
