"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { getCurrentUser, supabase } from "@/lib/supabase"

interface Assignment {
  id: string
  title: string
  description: string | null
  due_date: string
  total_points: number
  file_url: string | null
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

interface AssignmentSubmission {
  id: string
  content: string | null
  file_url: string | null
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
}

export default function AssignmentDetailPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submission, setSubmission] = useState<AssignmentSubmission | null>(null)
  const [content, setContent] = useState("")
  const [file, setFile] = useState<File | null>(null)

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
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      // Lấy bài nộp của sinh viên nếu có
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
        setContent(submissionData.content || '')
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

      let fileUrl = null
      if (file) {
        // Upload file nếu có
        const fileExt = file.name.split('.').pop()
        const fileName = `${Math.random()}.${fileExt}`
        const filePath = `assignment-submissions/${fileName}`

        const { error: uploadError } = await supabase.storage
          .from('assignments')
          .upload(filePath, file)

        if (uploadError) throw uploadError

        const { data: { publicUrl } } = supabase.storage
          .from('assignments')
          .getPublicUrl(filePath)

        fileUrl = publicUrl
      }

      if (submission) {
        // Cập nhật bài nộp
        const { error: updateError } = await supabase
          .from('assignment_submissions')
          .update({
            content,
            file_url: fileUrl || submission.file_url,
            submitted_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
          })
          .eq('id', submission.id)

        if (updateError) throw updateError
      } else {
        // Tạo bài nộp mới
        const { error: createError } = await supabase
          .from('assignment_submissions')
          .insert([{
            assignment_id: params.id,
            student_id: currentUser.profile.id,
            content,
            file_url: fileUrl,
            submitted_at: new Date().toISOString()
          }])

        if (createError) throw createError
      }

      toast({
        title: "Thành công",
        description: "Đã nộp bài tập"
      })

      // Tải lại thông tin bài nộp
      loadAssignment()

    } catch (error) {
      console.error('Lỗi khi nộp bài:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể nộp bài tập"
      })
    } finally {
      setIsSubmitting(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
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

  const isOverdue = new Date() > new Date(assignment.due_date)
  const canSubmit = !isOverdue && (!submission?.graded_at)

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">{assignment.title}</h2>
          <p className="text-muted-foreground mt-2">
            {assignment.class.subject.name} - {assignment.class.name}
          </p>
        </div>
        <Button variant="outline" onClick={() => router.push('/dashboard/assignments')}>
          Quay lại
        </Button>
      </div>

      <div className="grid gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Thông tin bài tập</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {assignment.description && (
              <div>
                <Label>Mô tả</Label>
                <p className="text-sm text-muted-foreground mt-1">{assignment.description}</p>
              </div>
            )}
            <div className="grid gap-4 md:grid-cols-3">
              <div>
                <Label>Hạn nộp</Label>
                <p className="text-sm text-muted-foreground mt-1">
                  {new Date(assignment.due_date).toLocaleDateString('vi-VN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                  })}
                </p>
              </div>
              <div>
                <Label>Điểm tối đa</Label>
                <p className="text-sm text-muted-foreground mt-1">{assignment.total_points}</p>
              </div>
              <div>
                <Label>Trạng thái</Label>
                <p className="text-sm text-muted-foreground mt-1">
                  {isOverdue ? 'Đã hết hạn' : 'Còn hạn'}
                </p>
              </div>
            </div>
            {assignment.file_url && (
              <div>
                <Label>Tệp đính kèm</Label>
                <Button 
                  variant="outline" 
                  className="mt-1 w-full"
                  asChild
                >
                  <a 
                    href={assignment.file_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    download
                  >
                    Tải xuống tệp đính kèm
                  </a>
                </Button>
              </div>
            )}
          </CardContent>
        </Card>

        {submission && (
          <Card>
            <CardHeader>
              <CardTitle>Bài đã nộp</CardTitle>
              <CardDescription>
                Nộp lúc: {new Date(submission.submitted_at!).toLocaleDateString('vi-VN', {
                  year: 'numeric',
                  month: '2-digit',
                  day: '2-digit',
                  hour: '2-digit',
                  minute: '2-digit'
                })}
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {submission.graded_at ? (
                <>
                  <div>
                    <Label>Điểm số</Label>
                    <p className="text-lg font-semibold mt-1">
                      {submission.score}/{assignment.total_points}
                    </p>
                  </div>
                  {submission.feedback && (
                    <div>
                      <Label>Nhận xét</Label>
                      <p className="text-sm text-muted-foreground mt-1">{submission.feedback}</p>
                    </div>
                  )}
                </>
              ) : (
                <p className="text-sm text-muted-foreground">Chưa chấm điểm</p>
              )}
            </CardContent>
          </Card>
        )}

        {canSubmit && (
          <Card>
            <CardHeader>
              <CardTitle>Nộp bài</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="content">Nội dung</Label>
                <Textarea
                  id="content"
                  placeholder="Nhập nội dung bài làm..."
                  value={content}
                  onChange={(e) => setContent(e.target.value)}
                  rows={5}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="file">Tệp đính kèm</Label>
                <Input
                  id="file"
                  type="file"
                  onChange={(e) => setFile(e.target.files?.[0] || null)}
                />
                {submission?.file_url && !file && (
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-sm text-muted-foreground">Tệp hiện tại:</span>
                    <Button 
                      variant="outline" 
                      size="sm"
                      asChild
                    >
                      <a 
                        href={submission.file_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        download
                      >
                        Tải xuống
                      </a>
                    </Button>
                  </div>
                )}
              </div>
              <Button 
                className="w-full"
                disabled={isSubmitting}
                onClick={handleSubmit}
              >
                {isSubmitting ? 'Đang xử lý...' : (submission ? 'Nộp lại' : 'Nộp bài')}
              </Button>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  )
} 