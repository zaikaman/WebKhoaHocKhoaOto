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
import { v4 as uuidv4 } from 'uuid'
import { Input } from "@/components/ui/input"

interface Exam {
  id: string
  title: string
  description: string | null
  type: 'quiz' | 'midterm' | 'final' | 'essay'
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
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [isUploading, setIsUploading] = useState(false)
  const [uploadedFileUrl, setUploadedFileUrl] = useState<string | null>(null)

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
      const startTime = new Date(new Date(examData.start_time).getTime() - 7 * 60 * 60 * 1000)
      const endTime = new Date(new Date(examData.end_time).getTime() - 7 * 60 * 60 * 1000)

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
      console.log('Exam ID:', params.id)
      const { data: questionsData, error: questionsError } = await supabase
        .from('exam_questions')
        .select(`
          id,
          content,
          type,
          points,
          options,
          correct_answer,
          created_at
        `)
        .eq('exam_id', params.id)
        .order('created_at', { ascending: true })

      if (questionsError) {
        console.error('Lỗi khi lấy câu hỏi:', questionsError)
        throw questionsError
      }

      // Kiểm tra và xử lý dữ liệu câu hỏi
      if (!questionsData || questionsData.length === 0) {
        console.log('Không có câu hỏi cho bài kiểm tra này')
      } else {
        console.log('Số lượng câu hỏi:', questionsData.length)
      }

      setQuestions(questionsData || [])

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

  async function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (file) {
      if (file.size > 5 * 1024 * 1024) { // 5MB limit
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Kích thước file không được vượt quá 5MB"
        })
        return
      }
      setSelectedFile(file)
    }
  }

  async function uploadFile() {
    if (!selectedFile) return null

    try {
      setIsUploading(true)
      const fileExt = selectedFile.name.split('.').pop()
      const fileName = `${uuidv4()}.${fileExt}`
      const filePath = `exam-submissions/${fileName}`

      const { error: uploadError } = await supabase.storage
        .from('files')
        .upload(filePath, selectedFile)

      if (uploadError) throw uploadError

      const { data: { publicUrl } } = supabase.storage
        .from('files')
        .getPublicUrl(filePath)

      setUploadedFileUrl(publicUrl)
      return publicUrl
    } catch (error) {
      console.error('Lỗi khi upload file:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể upload file"
      })
      return null
    } finally {
      setIsUploading(false)
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

      let fileUrl = null
      if (exam?.type === 'essay' && selectedFile) {
        fileUrl = await uploadFile()
      }

      // Kiểm tra xem đã trả lời hết câu hỏi chưa
      const unansweredQuestions = questions.filter(q => !answers[q.id])
      
      if (unansweredQuestions.length > 0 && exam?.type !== 'essay') {
        toast({
          variant: "destructive",
          title: "Chưa hoàn thành",
          description: `Bạn chưa trả lời ${unansweredQuestions.length} câu hỏi`
        })
        setShowConfirmDialog(false)
        return
      }

      // Tạo bài làm mới
      const { data: submissionData, error: createError } = await supabase
        .from('exam_submissions')
        .insert([{
          exam_id: params.id,
          student_id: currentUser.profile.id,
          answers,
          file_url: fileUrl,
          submitted_at: new Date().toISOString()
        }])
        .select()
        .single()

      if (createError) throw createError

      toast({
        title: "Thành công",
        description: "Đã nộp bài kiểm tra"
      })

      router.push('/dashboard/student/exams')

    } catch (error) {
      console.error('Submit Error Details:', error)
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

  if (!exam) {
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

  if (!questions.length) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Bài kiểm tra chưa có câu hỏi</h2>
          <p className="mt-2 text-muted-foreground">Vui lòng liên hệ giảng viên để biết thêm chi tiết.</p>
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
        <div className="container max-w-screen-2xl py-4">
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

      <div className="container max-w-screen-2xl pb-8">
        <div className="grid gap-6">
          {exam?.type === 'essay' ? (
            <Card>
              <CardHeader>
                <CardTitle>Bài làm tự luận</CardTitle>
                <CardDescription>Nhập nội dung bài làm hoặc đính kèm file</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="content">Nội dung bài làm</Label>
                  <Textarea
                    id="content"
                    value={answers['content'] || ''}
                    onChange={(e) => setAnswers(prev => ({
                      ...prev,
                      content: e.target.value
                    }))}
                    placeholder="Nhập nội dung bài làm của bạn..."
                    className="min-h-[200px]"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="file">File đính kèm (không bắt buộc)</Label>
                  <Input
                    id="file"
                    type="file"
                    onChange={handleFileChange}
                    accept=".pdf,.doc,.docx,.txt"
                    disabled={isUploading}
                  />
                  <p className="text-sm text-muted-foreground">
                    Định dạng hỗ trợ: PDF, DOC, DOCX, TXT. Kích thước tối đa: 5MB
                  </p>
                  {selectedFile && (
                    <div className="text-sm text-muted-foreground">
                      File đã chọn: {selectedFile.name}
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          ) : (
            questions.map((question, index) => (
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
                      <div className="flex items-start gap-2 text-sm text-muted-foreground">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="16"
                          height="16"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          className="mt-0.5"
                        >
                          <circle cx="12" cy="12" r="10" />
                          <path d="M12 16v-4" />
                          <path d="M12 8h.01" />
                        </svg>
                        <div>
                          <p>Bạn có thể sử dụng Markdown để định dạng văn bản</p>
                          <p>Ví dụ: **in đậm**, *in nghiêng*, - danh sách</p>
                        </div>
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            ))
          )}
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