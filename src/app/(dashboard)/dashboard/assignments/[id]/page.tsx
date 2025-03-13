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
}

interface AssignmentSubmission {
  id: string
  content: string | null
  file_url: string | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
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

      // Kiểm tra nội dung bài nộp
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

      // Tạo bài nộp mới
      const { data: submissionData, error: createError } = await supabase
        .from('assignment_submissions')
        .insert([{
          assignment_id: params.id,
          student_id: currentUser.profile.id,
          content: content || null,
          file_url: fileUrl,
          submitted_at: new Date().toISOString()
        }])
        .select()
        .single()

      if (createError) throw createError

      toast({
        title: "Thành công",
        description: "Đã nộp bài tập"
      })

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

  return (
    <div className="space-y-8">
      <div className="sticky top-0 z-50 bg-background border-b">
        <div className="container py-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-bold tracking-tight">{assignment.title}</h2>
              <p className="text-muted-foreground">
                {assignment.class.subject.name} - {assignment.class.name}
              </p>
            </div>
            <div className="flex items-center gap-4">
              <div className="text-sm text-muted-foreground">
                Hạn nộp: {new Date(assignment.due_date).toLocaleString('vi-VN')}
              </div>
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

      <div className="container pb-8">
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
              Bạn có thể nhập nội dung trực tiếp hoặc đính kèm file
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Nội dung</Label>
              <Textarea
                value={content}
                onChange={(e) => setContent(e.target.value)}
                placeholder="Nhập nội dung bài làm của bạn"
                rows={10}
              />
            </div>

            <div className="space-y-2">
              <Label>File đính kèm</Label>
              <Input
                type="file"
                onChange={(e) => setFile(e.target.files?.[0] || null)}
                accept=".pdf,.doc,.docx,.txt"
              />
              <p className="text-sm text-muted-foreground">
                Hỗ trợ file: PDF, DOC, DOCX, TXT
              </p>
            </div>
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