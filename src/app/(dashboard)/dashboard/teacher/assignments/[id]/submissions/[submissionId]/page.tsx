"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { getCurrentUser, supabase } from "@/lib/supabase"

interface AssignmentSubmission {
  id: string
  student: {
    id: string
    full_name: string
  }
  content: string | null
  file_url: string | null
  score: number | null
  submitted_at: string
  graded_at: string | null
  feedback: string | null
}

interface Assignment {
  id: string
  title: string
  total_points: number
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

export default function AssignmentSubmissionDetailPage({ 
  params 
}: { 
  params: { id: string, submissionId: string } 
}) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSaving, setIsSaving] = useState(false)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submission, setSubmission] = useState<AssignmentSubmission | null>(null)
  const [score, setScore] = useState("")
  const [feedback, setFeedback] = useState("")

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
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
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      // Lấy thông tin bài nộp
      const { data: submissionData, error: submissionError } = await supabase
        .from('assignment_submissions')
        .select(`
          *,
          student:profiles(
            id,
            full_name
          )
        `)
        .eq('id', params.submissionId)
        .single()

      if (submissionError) throw submissionError
      setSubmission(submissionData)

      // Set giá trị ban đầu cho form
      setScore(submissionData.score?.toString() || "")
      setFeedback(submissionData.feedback || "")

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài nộp"
      })
      router.push(`/dashboard/teacher/assignments/${params.id}/submissions`)
    } finally {
      setIsLoading(false)
    }
  }

  async function handleSubmit() {
    try {
      setIsSaving(true)
      
      const scoreNumber = parseFloat(score)
      if (isNaN(scoreNumber) || scoreNumber < 0 || scoreNumber > assignment?.total_points!) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Điểm số không hợp lệ"
        })
        return
      }

      const { error } = await supabase
        .from('assignment_submissions')
        .update({
          score: scoreNumber,
          feedback,
          graded_at: new Date().toISOString()
        })
        .eq('id', params.submissionId)

      if (error) throw error

      toast({
        title: "Thành công",
        description: "Đã lưu điểm và nhận xét"
      })

      router.push(`/dashboard/teacher/assignments/${params.id}/submissions`)

    } catch (error) {
      console.error('Lỗi khi lưu điểm:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể lưu điểm và nhận xét"
      })
    } finally {
      setIsSaving(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!assignment || !submission) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy thông tin bài nộp</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push(`/dashboard/teacher/assignments/${params.id}/submissions`)}
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
          <h2 className="text-2xl font-bold tracking-tight">{assignment.title}</h2>
          <p className="text-muted-foreground">
            {assignment.class.subject.name} - {assignment.class.name}
          </p>
        </div>
        <Button onClick={() => router.push(`/dashboard/teacher/assignments/${params.id}/submissions`)}>
          Quay lại
        </Button>
      </div>

      <div className="grid gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Thông tin sinh viên</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-1">
              <div className="font-medium">{submission.student.full_name}</div>
              <div className="text-sm text-muted-foreground">
                Nộp bài lúc: {new Date(submission.submitted_at).toLocaleString('vi-VN')}
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Bài làm</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {submission.content && (
                <div>
                  <Label htmlFor="content">Nội dung:</Label>
                  <div className="mt-2 p-4 rounded-lg bg-muted whitespace-pre-wrap">
                    {submission.content}
                  </div>
                </div>
              )}
              
              {submission.file_url && (
                <div>
                  <Label htmlFor="file">File đính kèm:</Label>
                  <div className="mt-2">
                    <a
                      href={submission.file_url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center space-x-2 text-sm text-primary hover:underline"
                    >
                      Tải xuống file
                    </a>
                  </div>
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Chấm điểm</CardTitle>
            <CardDescription>
              Nhập điểm và nhận xét cho bài làm
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-6">
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <p className="text-base font-medium">Điểm số</p>
                    <span className="text-sm text-muted-foreground">
                      (Tối đa {assignment.total_points} điểm)
                    </span>
                  </div>
                  <div className="relative">
                    <Input
                      id="score"
                      type="number"
                      min="0" 
                      max={assignment.total_points}
                      value={score}
                      onChange={(e) => setScore(e.target.value)}
                      placeholder={`Nhập điểm (tối đa ${assignment.total_points} điểm)...`}
                      className="text-lg font-medium"
                    />
                  </div>
                </div>

                <div className="space-y-3 col-span-2">
                  <div className="flex items-center gap-2">
                    <p className="text-base font-medium">Nhận xét</p>
                    <span className="text-sm text-muted-foreground">
                      (Nhập nhận xét chi tiết về bài làm)
                    </span>
                  </div>
                  <Textarea
                    id="feedback"
                    value={feedback}
                    onChange={(e) => setFeedback(e.target.value)}
                    placeholder="Nhập nhận xét về điểm mạnh, điểm yếu và góp ý cải thiện..."
                    rows={6}
                    className="resize-none text-base w-full"
                  />
                </div>
              </div>

              <div className="flex justify-end">
                <Button onClick={handleSubmit} disabled={isSaving}>
                  {isSaving ? "Đang lưu..." : "Lưu điểm"}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
} 