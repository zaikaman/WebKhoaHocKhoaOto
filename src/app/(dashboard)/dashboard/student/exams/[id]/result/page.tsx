"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { getCurrentUser, supabase } from "@/lib/supabase"

interface ExamResult {
  exam: {
    id: string
    title: string
    class: {
      name: string
      subject: {
        name: string
      }
    }
    total_points: number
  }
  submission: {
    id: string
    answers: Record<string, string>
    score: number
    submitted_at: string
  }
  questions: Array<{
    id: string
    content: string
    type: string
    points: number
    options: string[]
    correct_answer: string
  }>
}

export default function ExamResultPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [result, setResult] = useState<ExamResult | null>(null)

  useEffect(() => {
    loadResult()
  }, [])

  async function loadResult() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      // Lấy thông tin bài thi và bài làm
      const { data: examData, error: examError } = await supabase
        .from('exams')
        .select(`
          id,
          title,
          total_points,
          class:classes (
            name,
            subject:subjects (
              name
            )
          )
        `)
        .eq('id', params.id)
        .single()

      if (examError) throw examError

      // Lấy bài làm của sinh viên
      const { data: submissionData, error: submissionError } = await supabase
        .from('exam_submissions')
        .select('*')
        .eq('exam_id', params.id)
        .eq('student_id', currentUser.profile.id)
        .single()

      if (submissionError) throw submissionError

      // Lấy danh sách câu hỏi
      const { data: questionsData, error: questionsError } = await supabase
        .from('exam_questions')
        .select('*')
        .eq('exam_id', params.id)
        .order('created_at', { ascending: true })

      if (questionsError) throw questionsError

      setResult({
        exam: examData,
        submission: submissionData,
        questions: questionsData
      })

    } catch (error) {
      console.error('Lỗi khi tải kết quả:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải kết quả bài kiểm tra"
      })
      router.push('/dashboard/student/exams')
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!result) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy kết quả</h2>
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
    <div className="container py-8 space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">{result.exam.title}</h2>
          <p className="text-muted-foreground">
            {result.exam.class.subject.name} - {result.exam.class.name}
          </p>
        </div>
        <Button onClick={() => router.push('/dashboard/student/exams')}>
          Quay lại
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Kết quả bài làm</CardTitle>
          <CardDescription>
            Nộp bài lúc: {new Date(result.submission.submitted_at).toLocaleString('vi-VN')}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="text-2xl font-bold">
            Điểm số: {result.submission.score}/{result.exam.total_points}
          </div>
        </CardContent>
      </Card>

      <div className="grid gap-6">
        {result.questions.map((question, index) => {
          const userAnswer = result.submission.answers[question.id]
          const isCorrect = userAnswer === question.correct_answer
          
          return (
            <Card key={question.id}>
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle>Câu {index + 1}</CardTitle>
                    <CardDescription>Điểm: {question.points}</CardDescription>
                  </div>
                  {question.type === 'multiple_choice' && (
                    <div className={`px-2 py-1 rounded text-sm ${
                      isCorrect ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                    }`}>
                      {isCorrect ? 'Đúng' : 'Sai'}
                    </div>
                  )}
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <div className="font-medium">Câu hỏi:</div>
                  <div className="text-sm">{question.content}</div>
                </div>

                {question.type === 'multiple_choice' && (
                  <div className="space-y-3">
                    {(() => {
                      try {
                        const options = typeof question.options === 'string' 
                          ? JSON.parse(question.options) 
                          : question.options

                        return options.map((option: string, optionIndex: number) => (
                          <div key={optionIndex} className="flex items-center space-x-3">
                            <input
                              type="radio"
                              checked={userAnswer === option}
                              readOnly
                              className="h-4 w-4 border-gray-300 text-primary"
                            />
                            <label className={`text-sm ${
                              option === question.correct_answer
                                ? 'font-medium text-green-700'
                                : userAnswer === option
                                ? 'font-medium text-red-700'
                                : ''
                            }`}>
                              {option}
                              {option === question.correct_answer && ' (Đáp án đúng)'}
                            </label>
                          </div>
                        ))
                      } catch (error) {
                        console.error('Lỗi khi parse options:', error)
                        return <div className="text-red-500">Lỗi hiển thị câu hỏi</div>
                      }
                    })()}
                  </div>
                )}
              </CardContent>
            </Card>
          )
        })}
      </div>
    </div>
  )
} 