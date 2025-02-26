"use client"

import { useState } from "react"
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
import { createExam, createExamQuestion } from "@/lib/supabase"

type ExamQuestion = {
  id: string
  exam_id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | null
  correct_answer: string | null
  created_at: string
  updated_at: string
}

export default function CreateExamPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [examTitle, setExamTitle] = useState("")
  const [examDescription, setExamDescription] = useState("")
  const [examDuration, setExamDuration] = useState(60)
  const [examType, setExamType] = useState<'multiple_choice' | 'essay'>('multiple_choice')
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [isQuestionDialogOpen, setIsQuestionDialogOpen] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState<ExamQuestion | null>(null)

  const handleAddQuestion = () => {
    setCurrentQuestion(null)
    setIsQuestionDialogOpen(true)
  }

  const handleQuestionSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    const formData = new FormData(event.currentTarget)

    const newQuestion: ExamQuestion = {
      id: currentQuestion?.id || Date.now().toString(),
      exam_id: '',
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
        (examType === 'essay' ? formData.get('correctAnswer') as string : null),
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }

    try {
      if (currentQuestion) {
        setQuestions(questions.map(q => q.id === currentQuestion.id ? newQuestion : q))
      } else {
        setQuestions([...questions, newQuestion])
      }
    } catch (error) {
      console.error('Error saving question:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể lưu câu hỏi"
      })
    } finally {
      setIsQuestionDialogOpen(false)
    }
  }

  const handleCreateExam = async () => {
    const errors: string[] = [];
    const savedQuestions: ExamQuestion[] = [];

    // Lưu từng câu hỏi và theo dõi lỗi
    for (const question of questions) {
      try {
        const savedQuestion = await createExamQuestion(question);
        savedQuestions.push(savedQuestion);
      } catch (error) {
        console.error(`Lỗi khi lưu câu hỏi ${question.content}:`, error);
        errors.push(`Câu hỏi "${question.content.slice(0, 50)}...": ${(error as Error).message}`);
      }
    }

    if (errors.length > 0) {
      // Có lỗi xảy ra
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
      });
    } else {
      // Tất cả câu hỏi đều được lưu thành công
      toast({
        variant: "success", 
        title: "Thành công",
        description: "Tạo bài kiểm tra thành công"
      });
      router.back();
    }
  }

  return (
    <div className="space-y-6 p-6 bg-gray-50 rounded-lg shadow-md">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài kiểm tra mới</h2>
        <p className="text-muted-foreground">Tạo bài kiểm tra cho lớp học của bạn</p>
      </div>
      
      {/* <div className="space-y-2">
        <label className="text-sm font-medium">Tiêu đề</label>
        <input
          name="title"
          className="w-full px-3 py-2 border rounded-md"
          value={examTitle}
          onChange={(e) => setExamTitle(e.target.value)}
          placeholder="Nhập tiêu đề bài kiểm tra"
          required
        />
      </div>

      <div className="space-y-2">
        <label className="text-sm font-medium">Mô tả</label>
        <textarea
          name="description"
          className="w-full px-3 py-2 border rounded-md"
          value={examDescription}
          onChange={(e) => setExamDescription(e.target.value)}
          placeholder="Nhập mô tả bài kiểm tra"
        />
      </div> */}

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
        </div>
      </Tabs>

      <Dialog open={isQuestionDialogOpen} onOpenChange={setIsQuestionDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{currentQuestion ? "Chỉnh sửa câu hỏi" : "Thêm câu hỏi mới"}</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleQuestionSubmit} className="space-y-4">
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

      <div className="flex justify-end space-x-4">
        <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
        <Button disabled={questions.length === 0} onClick={handleCreateExam}>Tạo bài kiểm tra</Button>
      </div>
    </div>
  )
}