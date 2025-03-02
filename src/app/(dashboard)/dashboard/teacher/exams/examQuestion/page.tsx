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
import { createExam, updateExamQuestion, deleteExamQuestion, getExamDetails, getExamQuestions, ExamQuestion, createExamQuestion } from "@/lib/supabase"

export default function ExamQuestionPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [examId, setExamId] = useState<string | null>(null)
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [isQuestionDialogOpen, setIsQuestionDialogOpen] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState<ExamQuestion | null>(null)
  const [examType, setExamType] = useState<'multiple_choice' | 'essay'>('multiple_choice')

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
    setExamType('multiple_choice')
    setIsQuestionDialogOpen(true)
  }

  const handleQuestionSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    const formData = new FormData(event.currentTarget)

    const newQuestion: Omit<ExamQuestion, 'id'> = {
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
        (formData.get('correctAnswer') as string),
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }

    try {
      if (currentQuestion) {
        const updatedQuestion: ExamQuestion = {
          ...currentQuestion,
          ...newQuestion,
          updated_at: new Date().toISOString()
        }

        const { data, error } = await updateExamQuestion(updatedQuestion)
        if (error) throw error

        setQuestions(questions.map(q => q.id === currentQuestion.id ? data : q))
      } else {
        const { data, error } = await createExamQuestion(newQuestion)
        if (error) throw error
        setQuestions([...questions, data])
      }
      toast({
        variant: "success",
        title: "Thành công",
        description: "Câu hỏi đã được lưu thành công"
      })
    } catch (error) {
      console.error('Chi tiết lỗi khi lưu câu hỏi:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể lưu câu hỏi"
      })
    } finally {
      setIsQuestionDialogOpen(false)
    }
  }

  const handleDeleteQuestion = async (questionId: string) => {
    try {
      const { error } = await deleteExamQuestion(questionId)
      if (error) throw error
      setQuestions(questions.filter(q => q.id !== questionId))
      toast({
        variant: "success",
        title: "Thành công",
        description: "Câu hỏi đã được xóa thành công"
      })
    } catch (error) {
      console.error('Lỗi khi xóa câu hỏi:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa câu hỏi"
      })
    }
  }

  return (
    <div className="space-y-6 p-6 bg-gray-50 rounded-lg shadow-md">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo câu hỏi cho bài kiểm tra</h2>
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
                  onClick={() => { 
                    setCurrentQuestion(question); 
                    setExamType(question.type);
                    setIsQuestionDialogOpen(true); 
                  }} 
                >
                  Chỉnh sửa
                </Button>
                <Button 
                  onClick={() => handleDeleteQuestion(question.id)}
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
                    <h4 className="font-medium">Đáp án đúng:</h4>
                    <p>{question.correct_answer}</p>
                  </div>
                )}
                {question.type === 'essay' && question.correct_answer && (
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
                <div className="space-y-2">
                  <Label htmlFor="content">Nội dung câu hỏi</Label>
                  <Textarea id="content" name="content" defaultValue={currentQuestion?.content || ''} required />
                </div>
                {examType === 'multiple_choice' && (
                  <div className="space-y-4">
                    {[1, 2, 3, 4].map((num) => (
                      <div key={num} className="space-y-2">
                        <label className="text-sm font-medium">Đáp án {num}</label>
                        <input
                          name={`option${num}`}
                          className="w-full px-3 py-2 border rounded-md"
                          defaultValue={currentQuestion?.options?.[num - 1] || ''}
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
        <Button onClick={() => router.push('/dashboard/teacher/exams/list')}>Hoàn tất</Button>
      </div>
    </div>
  )
}
