"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { createExam, createExamQuestion, getExamDetails, getExamQuestions, ExamQuestion } from "@/lib/supabase"


export default function ExamQuestionPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [examId, setExamId] = useState<string | null>(null)
  const [examTitle, setExamTitle] = useState("")
  const [examDescription, setExamDescription] = useState("")
  const [examDuration, setExamDuration] = useState(60)
  const [examType, setExamType] = useState<'multiple_choice' | 'essay'>('multiple_choice')
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [isQuestionDialogOpen, setIsQuestionDialogOpen] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState<ExamQuestion | null>(null)

  useEffect(() => {
    const query = new URLSearchParams(window.location.search)
    const id = query.get('examId')
    if (id) {
      setExamId(id)
      loadExamDetails(id)
    }
  }, [])

  const loadExamDetails = async (id: string) => {
    try {
      const examDetails = await getExamDetails(id)
      const examQuestions = await getExamQuestions(id)
      setQuestions(examQuestions)
    } catch (error) {
      console.error('Lỗi khi tải thông tin bài kiểm tra:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài kiểm tra"
      })
    }
  }

  const handleAddQuestion = () => {
    setCurrentQuestion(null)
    setIsQuestionDialogOpen(true)
  }

  const handleQuestionSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    const formData = new FormData(event.currentTarget)
    
    console.log('Form Data:', {
      content: formData.get('content'),
      type: formData.get('type'),
      points: formData.get('points'),
      option1: formData.get('option1'),
      option2: formData.get('option2'),
      option3: formData.get('option3'),
      option4: formData.get('option4'),
      correctOption: formData.get('correctOption'),
      correctAnswer: formData.get('correctAnswer')
    })

    const newQuestion = {
      exam_id: examId || '',
      type: examType,
      content: formData.get('content') as string,
      points: Number(formData.get('points')),
      options: examType === 'multiple_choice' ? [
        formData.get('option1') as string,
        formData.get('option2') as string,
        formData.get('option3') as string,
        formData.get('option4') as string
      ] : null,
      correct_answer: examType === 'multiple_choice' ? 
        (formData.get(`option${Number(formData.get('correctOption'))}`) as string) :
        (formData.get('correctAnswer') as string)
    }

    console.log('Dữ liệu câu hỏi mới:', newQuestion)

    try {
      if (currentQuestion) {
        const updatedQuestion: ExamQuestion = {
          ...currentQuestion,
          ...newQuestion,
          id: currentQuestion.id,
          created_at: currentQuestion.created_at,
          updated_at: new Date().toISOString()
        }
        console.log('Đang cập nhật câu hỏi:', updatedQuestion)
        setQuestions(questions.map(q => q.id === currentQuestion.id ? updatedQuestion : q))
      } else {
        console.log('Đang gọi createExamQuestion với dữ liệu:', newQuestion)
        try {
          const savedQuestion = await createExamQuestion(newQuestion)
          console.log('Kết quả trả về từ createExamQuestion:', savedQuestion)
          setQuestions([...questions, savedQuestion])
        } catch (createError) {
          console.error('Lỗi từ createExamQuestion:', {
            error: createError,
            message: createError instanceof Error ? createError.message : 'Unknown error',
            stack: createError instanceof Error ? createError.stack : undefined
          })
          throw createError
        }
      }
      toast({
        variant: "success",
        title: "Thành công",
        description: "Câu hỏi đã được lưu thành công"
      })
    } catch (error) {
      console.error('Chi tiết lỗi khi lưu câu hỏi:', {
        error,
        errorMessage: error instanceof Error ? error.message : 'Unknown error',
        errorStack: error instanceof Error ? error.stack : undefined,
        questionData: newQuestion
      })
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error instanceof Error 
          ? `Không thể lưu câu hỏi: ${error.message}`
          : "Không thể lưu câu hỏi"
      })
    } finally {
      setIsQuestionDialogOpen(false)
    }
  }

  const handleCreateExam = async () => {
    const errors: string[] = []
    const savedQuestions: ExamQuestion[] = []

    for (const question of questions) {
      try {
        const savedQuestion = await createExamQuestion(question)
        savedQuestions.push(savedQuestion)
      } catch (error) {
        console.error(`Lỗi khi lưu câu hỏi ${question.content}:`, error)
        errors.push(`Câu hỏi "${question.content.slice(0, 50)}...": ${(error as Error).message}`)
      }
    }

    if (errors.length > 0) {
      toast({
        variant: "destructive",
        title: "Lỗi khi lưu một số câu hỏi",
        description: (
          <div className="mt-2">
            {errors.map((error, index) => (
              <p key={index} className="text-sm">{error}</p>
            ))}
          </div>
        )
      })
    } else {
      toast({
        variant: "success", 
        title: "Thành công",
        description: "Tạo bài kiểm tra thành công"
      })
      router.back()
    }
  }

  return (
    <div className="space-y-6 p-6 bg-gray-50 rounded-lg shadow-md">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài kiểm tra mới</h2>
        <p className="text-muted-foreground">Mã đề: {examId}</p>
      </div>
      
      <Tabs value={examType} onValueChange={(value) => setExamType(value as 'multiple_choice' | 'essay')}>
        <TabsList>
          <TabsTrigger value="multiple_choice">Trắc nghiệm</TabsTrigger>
          <TabsTrigger value="essay">Tự luận</TabsTrigger>
        </TabsList>

        <div className="mt-4">
          <Button onClick={handleAddQuestion}>Thêm câu hỏi</Button>
        </div>

        <div className="mt-4 space-y-4">
          {questions.map((question, index) => (
            <div key={question.id} className="rounded-lg border p-4 bg-white shadow-sm relative">
              <div className="absolute top-2 right-2 flex space-x-2">
                <Button 
                  onClick={() => { setCurrentQuestion(question); setIsQuestionDialogOpen(true); }} 
                >
                  Chỉnh sửa
                </Button>
                <Button 
                  onClick={() => setQuestions(questions.filter(q => q.id !== question.id))}
                  variant="outline"
                >
                  &times;
                </Button>
              </div>
              <div className="flex-1">
                <h3 className="font-medium">Câu {index + 1}: {question.content}</h3>
                <div className="mt-2 text-sm text-muted-foreground">Điểm: {question.points}</div>
                {question.type === 'multiple_choice' && question.options && (
                  <div className="mt-2">
                    <h4 className="font-medium">Các đáp án:</h4>
                    <ul className="list-disc pl-5">
                      {question.options.map((option: string, idx: number) => (
                        <li key={idx}>{option}</li>
                      ))}
                    </ul>
                  </div>
                )}
                {question.type === 'essay' && question.correct_answer && (
                  <div className="mt-2">
                    <h4 className="font-medium">Đáp án đúng:</h4>
                    <p>{question.correct_answer}</p>
                  </div>
                )}
                {question.type === 'multiple_choice' && question.correct_answer && (
                  <div className="mt-2">
                    <h4 className="font-medium">Đáp án đúng:</h4>
                    <p>{question.correct_answer}</p>
                  </div>
                )}
              </div>
            </div>
          ))}

          <Dialog open={isQuestionDialogOpen} onOpenChange={setIsQuestionDialogOpen}>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{currentQuestion ? "Cập nhật câu hỏi" : "Thêm câu hỏi"}</DialogTitle>
              </DialogHeader>
              <form onSubmit={handleQuestionSubmit} className="space-y-4">
                <input type="hidden" name="type" value={examType} />
                <div className="space-y-2">
                  <Label htmlFor="content">Nội dung câu hỏi</Label>
                  <Textarea id="content" name="content" defaultValue={currentQuestion?.content} required />
                </div>
                {examType === 'multiple_choice' && (
                  <div className="space-y-4">
                    {[1, 2, 3, 4].map((num) => (
                      <div key={num} className="space-y-2">
                        <label className="text-sm font-medium">Đáp án {num}</label>
                        <input
                          name={`option${num}`}
                          className="w-full px-3 py-2 border rounded-md"
                          defaultValue={currentQuestion?.options?.[num - 1]}
                          required
                        />
                      </div>
                    ))}
                    <div className="space-y-2">
                      <Label htmlFor="correctOption">Đáp án đúng</Label>
                      <select
                        id="correctOption"
                        name="correctOption"
                        className="w-full px-3 py-2 border rounded-md"
                        defaultValue={currentQuestion?.options?.indexOf(currentQuestion.correct_answer || '') || 0}
                        required
                      >
                        <option value="0">Đáp án 1</option>
                        <option value="1">Đáp án 2</option>
                        <option value="2">Đáp án 3</option>
                        <option value="3">Đáp án 4</option>
                      </select>
                    </div>
                  </div>
                )}
                {examType === 'essay' && (
                  <div className="space-y-2">
                    <Label htmlFor="correctAnswer">Đáp án đúng</Label>
                    <Textarea
                      id="correctAnswer"
                      name="correctAnswer"
                      defaultValue={currentQuestion?.correct_answer || ''}
                      placeholder="Nhập đáp án đúng cho câu hỏi tự luận"
                    />
                  </div>
                )}
                <div className="space-y-2">
                  <Label htmlFor="points">Điểm</Label>
                  <Input id="points" name="points" type="number" min="0" step="0.5" defaultValue={currentQuestion?.points || 1} required />
                </div>
                <DialogFooter>
                  <Button type="button" variant="outline" onClick={() => setIsQuestionDialogOpen(false)}>Hủy</Button>
                  <Button type="submit">{currentQuestion ? "Cập nhật" : "Thêm"}</Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        </div>
      </Tabs>

      <div className="flex justify-end space-x-4">
        <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
        <Button disabled={questions.length === 0} onClick={handleCreateExam}>Hoàn tất</Button>
      </div>
    </div>
  )
}
