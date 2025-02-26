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
import { createExam } from "@/lib/supabase"

type Question = {
  id: string
  type: 'multiple_choice' | 'essay'
  content: string
  options?: string[]
  correctOption?: number
  points: number
}

export default function CreateExamPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [examTitle, setExamTitle] = useState("")
  const [examDescription, setExamDescription] = useState("")
  const [examDuration, setExamDuration] = useState(60)
  const [examType, setExamType] = useState<'multiple_choice' | 'essay'>('multiple_choice')
  const [questions, setQuestions] = useState<Question[]>([])
  const [isQuestionDialogOpen, setIsQuestionDialogOpen] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState<Question | null>(null)

  const handleAddQuestion = () => {
    setCurrentQuestion(null)
    setIsQuestionDialogOpen(true)
  }

  const handleQuestionSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    const formData = new FormData(event.currentTarget)

    const newQuestion: Question = {
      id: currentQuestion?.id || Date.now().toString(),
      type: examType,
      content: formData.get('content') as string,
      points: Number(formData.get('points')),
      options: examType === 'multiple_choice' ? [
        formData.get('option1') as string,
        formData.get('option2') as string,
        formData.get('option3') as string,
        formData.get('option4') as string,
      ] : undefined,
      correctOption: examType === 'multiple_choice' ? 
        Number(formData.get('correctOption')) : undefined
    }

    if (currentQuestion) {
      setQuestions(questions.map(q => q.id === currentQuestion.id ? newQuestion : q))
    } else {
      setQuestions([...questions, newQuestion])
    }
    setIsQuestionDialogOpen(false)
  }

  const handleCreateExam = async () => {
    try {
      const examData = {
        title: examTitle,
        description: examDescription,
        duration: examDuration,
        type: examType === 'multiple_choice' ? 'quiz' : 'essay',
        questions: questions.map(q => ({
          content: q.content,
          type: q.type,
          points: q.points,
          options: q.options,
          correct_answer: q.correctOption !== undefined ? q.options?.[q.correctOption] : null,
        })),
        status: 'upcoming' as 'upcoming',
        class_id: 'your_class_id',
        start_time: new Date().toISOString(),
        end_time: new Date(Date.now() + examDuration * 60000).toISOString(),
        total_points: questions.reduce((total, q) => total + q.points, 0),
      }

      await createExam(examData)
      toast({
        title: "Thành công",
        description: "Đã tạo bài kiểm tra mới"
      })
      router.push('/dashboard/teacher/exams')
    } catch (error) {
      console.error('Error creating exam:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tạo bài kiểm tra"
      })
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
            <div key={question.id} className="rounded-lg border p-4 bg-white shadow-sm">
              <h3 className="font-medium">Câu {index + 1}: {question.content}</h3>
              <div className="mt-2 text-sm text-muted-foreground">Điểm: {question.points}</div>
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
                    <Label htmlFor={`option${num}`}>Đáp án {num}</Label>
                    <Input id={`option${num}`} name={`option${num}`} defaultValue={currentQuestion?.options?.[num - 1]} required />
                  </div>
                ))}
                <div className="space-y-2">
                  <Label htmlFor="correctOption">Đáp án đúng</Label>
                  <Input id="correctOption" name="correctOption" type="number" min="0" max="3" defaultValue={currentQuestion?.correctOption} required />
                </div>
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