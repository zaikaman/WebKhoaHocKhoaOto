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
import { Input } from "@/components/ui/input"

interface Assignment {
  id: string
  title: string
  description: string | null
  type: 'multiple_choice' | 'essay'
  due_date: string
  total_points: number
  file_url: string | null
  class: {
    name: string
    subject: {
      name: string
    }
  }
  questions?: Array<{
    id: string
    content: string
    points: number
    options: string[]
    correct_answer: string
  }>
}

interface AssignmentSubmission {
  id: string
  content: string | null
  file_url: string | null
  answers?: Record<string, string>
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
  score: number | null
}

export default function AssignmentDetailPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showConfirmDialog, setShowConfirmDialog] = useState(false)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submission, setSubmission] = useState<AssignmentSubmission | null>(null)
  const [content, setContent] = useState('')
  const [file, setFile] = useState<File | null>(null)
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

      // Lấy thông tin bài tập
      const { data: assignmentData, error: assignmentError } = await supabase
        .from('assignments')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          ),
          questions:assignment_questions(
            id,
            content,
            points,
            options,
            correct_answer
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      // Kiểm tra hạn nộp
      const now = new Date()
      const dueDate = new Date(assignmentData.due_date)

      if (now > dueDate) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Đã quá hạn nộp bài"
        })
        router.push('/dashboard/assignments')
        return
      }

      // Lấy bài làm của sinh viên nếu có
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
        setSubmission(submissionData)
        if (submissionData.answers) {
          setAnswers(submissionData.answers)
        }
        router.push('/dashboard/assignments')
        return
      }

    } catch (error) {
      console.error('Lỗi khi tải thông tin bài tập:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài tập"
      })
      router.push('/dashboard/assignments')
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

      if (assignment?.type === 'multiple_choice') {
        // Kiểm tra xem đã trả lời hết câu hỏi chưa
        const unansweredQuestions = assignment.questions?.filter(q => !answers[q.id]) || []
        if (unansweredQuestions.length > 0) {
          toast({
            variant: "destructive",
            title: "Chưa hoàn thành",
            description: `Bạn chưa trả lời ${unansweredQuestions.length} câu hỏi`
          })
          return
        }

        // Tính điểm cho bài trắc nghiệm
        const score = assignment.questions?.reduce((total, question) => {
          const isCorrect = answers[question.id] === question.correct_answer
          return total + (isCorrect ? question.points : 0)
        }, 0) || 0

        // Nộp bài trắc nghiệm
        const { error: submitError } = await supabase
          .from('assignment_submissions')
          .insert([{
            assignment_id: params.id,
            student_id: currentUser.profile.id,
            answers,
            score,
            submitted_at: new Date().toISOString(),
            graded_at: new Date().toISOString()
          }])

        if (submitError) throw submitError

        toast({
          title: "Thành công",
          description: `Đã nộp bài kiểm tra. Điểm của bạn: ${score}/${assignment.total_points}`
        })

      } else {
        // Kiểm tra nội dung bài nộp cho bài tự luận
        if (!content && !file) {
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: "Vui lòng nhập nội dung hoặc đính kèm file"
          })
          return
        }

        let fileUrl = null
        if (file) {
          // Upload file nếu có
          const fileExt = file.name.split('.').pop()
          const fileName = `${Date.now()}.${fileExt}`
          const filePath = `assignments/${params.id}/${currentUser.profile.id}/${fileName}`

          const { error: uploadError } = await supabase.storage
            .from('submissions')
            .upload(filePath, file)

          if (uploadError) throw uploadError

          const { data: { publicUrl } } = supabase.storage
            .from('submissions')
            .getPublicUrl(filePath)

          fileUrl = publicUrl
        }

        // Nộp bài tự luận
        const { error: submitError } = await supabase
          .from('assignment_submissions')
          .insert([{
            assignment_id: params.id,
            student_id: currentUser.profile.id,
            content: content || null,
            file_url: fileUrl,
            submitted_at: new Date().toISOString()
          }])

        if (submitError) throw submitError

        toast({
          title: "Thành công",
          description: "Đã nộp bài tập"
        })
      }

      router.push('/dashboard/assignments')

    } catch (error) {
      console.error('Submit Error:', error)
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
            onClick={() => router.push('/dashboard/assignments')}
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
        <div className="container py-2 sm:py-4 px-2 sm:px-0">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
            <div className="w-full sm:w-auto">
              <h2 className="text-xl sm:text-2xl font-bold tracking-tight">{assignment.title}</h2>
              <p className="text-muted-foreground">
                {assignment.class.subject.name} - {assignment.class.name}
              </p>
            </div>
            <div className="flex flex-col sm:flex-row items-center gap-2 sm:gap-4 w-full sm:w-auto">
              <div className="text-sm text-muted-foreground w-full sm:w-auto sm:text-right">
                Hạn nộp: {new Date(assignment.due_date).toLocaleString('vi-VN')}
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

      <div className="container pb-8 px-2 sm:px-0">
        {assignment.description && (
          <Card className="mb-8">
            <CardHeader>
              <CardTitle>Mô tả bài tập</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="prose max-w-none">
                {assignment.description}
              </div>
            </CardContent>
          </Card>
        )}

        <Card>
          <CardHeader>
            <CardTitle>Nội dung bài làm</CardTitle>
            <CardDescription>
              {assignment.type === 'multiple_choice' 
                ? 'Vui lòng chọn đáp án đúng cho mỗi câu hỏi'
                : 'Bạn có thể nhập nội dung trực tiếp hoặc đính kèm file'}
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {assignment.type === 'multiple_choice' ? (
              <div className="space-y-6">
                {assignment.questions?.map((question, index) => (
                  <div key={question.id} className="space-y-4">
                    <div className="font-medium">Câu {index + 1}: {question.content}</div>
                    <div className="space-y-3">
                      {(() => {
                        try {
                          const options = typeof question.options === 'string' 
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
                  </div>
                ))}
              </div>
            ) : (
              <div className="space-y-6">
                <div className="grid gap-6 grid-cols-1 md:grid-cols-2">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-lg">Nội dung bài làm</CardTitle>
                      <CardDescription>
                        Nhập trực tiếp nội dung bài làm của bạn
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <Textarea
                          id="content"
                          value={content}
                          onChange={(e) => setContent(e.target.value)}
                          placeholder="Nhập nội dung bài làm của bạn vào đây..."
                          className="min-h-[300px] resize-none w-full"
                        />
                        <p className="text-sm text-muted-foreground">
                          Bạn có thể định dạng văn bản bằng cách sử dụng Markdown
                        </p>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle className="text-lg">File đính kèm</CardTitle>
                      <CardDescription>
                        Tải lên file bài làm của bạn
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div className="space-y-2">
                          <label className="text-sm font-medium">Upload file bài làm</label>
                          <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors">
                            <div className="flex flex-col items-center justify-center space-y-4">
                              <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                              </svg>
                              <div className="text-center">
                                <p className="text-base font-medium text-blue-600">Chọn file để tải lên</p>
                                <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                                <p className="text-xs text-muted-foreground mt-2">
                                  Định dạng hỗ trợ: PDF, DOC, DOCX, TXT
                                </p>
                              </div>
                              <input
                                type="file"
                                name="file"
                                accept=".pdf,.doc,.docx,.txt"
                                onChange={e => setFile(e.target.files?.[0] || null)}
                                className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                              />
                            </div>
                          </div>
                        </div>
                        
                        {file && (
                          <div className="rounded-lg border p-4">
                            <div className="flex items-center gap-4">
                              <div className="flex-1 truncate">
                                <p className="text-sm font-medium">{file.name}</p>
                                <p className="text-sm text-muted-foreground">
                                  {(file.size / 1024 / 1024).toFixed(2)} MB
                                </p>
                              </div>
                              <Button
                                variant="outline"
                                size="sm"
                                onClick={() => setFile(null)}
                              >
                                Xóa
                              </Button>
                            </div>
                          </div>
                        )}

                        {/* <div className="rounded-lg border border-dashed p-4">
                          <div className="flex flex-col items-center gap-2 text-center">
                            <svg
                              xmlns="http://www.w3.org/2000/svg"
                              width="24"
                              height="24"
                              viewBox="0 0 24 24"
                              fill="none"
                              stroke="currentColor"
                              strokeWidth="2"
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              className="text-muted-foreground"
                            >
                              <path d="M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242" />
                              <path d="M12 12v9" />
                              <path d="m8 17 4-4 4 4" />
                            </svg>
                            <div className="text-sm text-muted-foreground">
                              <p>Hỗ trợ các định dạng: PDF, DOC, DOCX, TXT</p>
                              <p>Kích thước tối đa: 10MB</p>
                            </div>
                          </div>
                        </div> */}
                      </div>
                    </CardContent>
                  </Card>
                </div>

                <div className="rounded-lg border p-4 bg-muted/50">
                  <div className="flex items-start gap-4">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="text-blue-500 mt-1"
                    >
                      <circle cx="12" cy="12" r="10" />
                      <path d="M12 16v-4" />
                      <path d="M12 8h.01" />
                    </svg>
                    <div className="flex-1">
                      <h4 className="text-sm font-medium">Lưu ý khi nộp bài</h4>
                      <ul className="mt-2 text-sm text-muted-foreground list-disc list-inside space-y-1">
                        <li>Bạn có thể nộp cả nội dung trực tiếp và file đính kèm</li>
                        <li>Đảm bảo nội dung bài làm của bạn rõ ràng và dễ đọc</li>
                        <li>Kiểm tra kỹ nội dung trước khi nộp bài</li>
                        <li>Sau khi nộp bài, bạn sẽ không thể chỉnh sửa</li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
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