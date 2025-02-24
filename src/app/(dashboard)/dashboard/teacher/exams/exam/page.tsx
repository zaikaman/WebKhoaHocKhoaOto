"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"

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
  const [isLoading, setIsLoading] = useState(false)
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

  return (
    <div className="space-y-6 p-6 bg-gray-50 rounded-lg shadow-md">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài kiểm tra mới</h2>
        <p className="text-muted-foreground">
          Tạo bài kiểm tra cho lớp học của bạn
        </p>
      </div>

      <div className="space-y-4">
        <div className="grid gap-4 md:grid-cols-1">
          <div className="space-y-2">
            <Label htmlFor="title">Tiêu đề</Label>
            <Input id="title" placeholder="Nhập tiêu đề bài kiểm tra" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="duration">Thời gian làm bài (phút)</Label>
            <Input id="duration" type="number" min="1" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="description">Mô tả</Label>
            <Textarea id="description" placeholder="Nhập mô tả bài kiểm tra" />
          </div>
        </div>
      </div>

      <Tabs 
        value={examType} 
        onValueChange={(value) => setExamType(value as 'multiple_choice' | 'essay')}
      >
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
              <div className="flex items-center justify-between">
                <h3 className="font-medium">Câu {index + 1}</h3>
                <div className="space-x-2">
                  <Button variant="outline" size="sm" 
                    onClick={() => {
                      setCurrentQuestion(question)
                      setIsQuestionDialogOpen(true)
                    }}
                  >
                    Sửa
                  </Button>
                  <Button variant="destructive" size="sm"
                    onClick={() => setQuestions(questions.filter(q => q.id !== question.id))}
                  >
                    Xóa
                  </Button>
                </div>
              </div>
              <p className="mt-2">{question.content}</p>
              {question.type === 'multiple_choice' && (
                <div className="mt-2 space-y-2">
                  {question.options?.map((option, i) => (
                    <div key={i} className="flex items-center">
                      <span className={`w-6 h-6 flex items-center justify-center rounded-full border
                        ${i === question.correctOption ? 'bg-primary text-primary-foreground' : ''}`}>
                        {String.fromCharCode(65 + i)}
                      </span>
                      <span className="ml-2">{option}</span>
                    </div>
                  ))}
                </div>
              )}
              <div className="mt-2 text-sm text-muted-foreground">
                Điểm: {question.points}
              </div>
            </div>
          ))}
        </div>
      </Tabs>

      <Dialog open={isQuestionDialogOpen} onOpenChange={setIsQuestionDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {currentQuestion ? "Chỉnh sửa câu hỏi" : "Thêm câu hỏi mới"}
            </DialogTitle>
          </DialogHeader>
          <form onSubmit={handleQuestionSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="content">Nội dung câu hỏi</Label>
              <Textarea
                id="content"
                name="content"
                defaultValue={currentQuestion?.content}
                required
              />
            </div>

            {examType === 'multiple_choice' && (
              <div className="space-y-4">
                {[1, 2, 3, 4].map((num) => (
                  <div key={num} className="space-y-2">
                    <Label htmlFor={`option${num}`}>Đáp án {num}</Label>
                    <Input
                      id={`option${num}`}
                      name={`option${num}`}
                      defaultValue={currentQuestion?.options?.[num - 1]}
                      required
                    />
                  </div>
                ))}
                <div className="space-y-2">
                  <Label htmlFor="correctOption">Đáp án đúng</Label>
                  <RadioGroup
                    name="correctOption"
                    defaultValue={String(currentQuestion?.correctOption || 0)}
                  >
                    {[0, 1, 2, 3].map((num) => (
                      <div key={num} className="flex items-center space-x-2">
                        <RadioGroupItem value={String(num)} id={`answer${num}`} />
                        <Label htmlFor={`answer${num}`}>Đáp án {String.fromCharCode(65 + num)}</Label>
                      </div>
                    ))}
                  </RadioGroup>
                </div>
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="points">Điểm</Label>
              <Input
                id="points"
                name="points"
                type="number"
                min="0"
                step="0.5"
                defaultValue={currentQuestion?.points || 1}
                required
              />
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" 
                onClick={() => setIsQuestionDialogOpen(false)}
              >
                Hủy
              </Button>
              <Button type="submit">
                {currentQuestion ? "Cập nhật" : "Thêm"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <div className="flex justify-end space-x-4">
        <Button variant="outline" onClick={() => router.back()}>
          Hủy
        </Button>
        <Button disabled={questions.length === 0}>
          Tạo bài kiểm tra
        </Button>
      </div>
    </div>
  )
}
