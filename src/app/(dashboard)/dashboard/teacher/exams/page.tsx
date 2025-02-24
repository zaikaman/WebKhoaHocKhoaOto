"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useToast } from '@/components/ui/use-toast'
import { Button } from '@/components/ui/button'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Editor } from '@/components/editor'
import { FileUpload } from '@/components/file-upload'
import { getTeacherClasses, getCurrentUser, uploadAssignmentFile, createAssignment } from '@/lib/supabase'

interface Class {
  id: string;
  name: string;
  subject: {
    name: string;
  };
}

export default function CreateAssignmentPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [classes, setClasses] = useState<Class[]>([])
  const [assignmentType, setAssignmentType] = useState('manual')
  
  useEffect(() => {
    loadTeacherClasses()
  }, [])

  async function loadTeacherClasses() {
    try {
      const currentUser = await getCurrentUser()
      if (!currentUser) {
        router.push('/login')
        return
      }
      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses)
    } catch (error) {
      console.error('Error loading classes:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách lớp học"
      })
    }
  }

  async function handleFileUpload(file: File) {
    try {
      setIsLoading(true)
      const fileUrl = await uploadAssignmentFile(file)
      
      const assignmentData = {
        title: file.name,
        description: 'Bài tập đã tải lên',
        class_id: '', // Cần thêm phần chọn lớp cho upload file
        due_date: new Date().toISOString(),
        type: 'essay' as const,
        submission_type: 'file_upload' as const,
        show_answer_after: false,
        file_url: fileUrl,
        total_points: 100 // Added total_points field
      }

      await createAssignment(assignmentData)
      
      router.push('/dashboard/teacher/assignments')
      toast({
        title: "Thành công",
        description: "Đã tải lên và tạo bài tập mới"
      })
    } catch (error: any) {
      console.error('Error processing file:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể xử lý file bài tập"
      })
    } finally {
      setIsLoading(false)
    }
  }

  async function handleManualCreate(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      
      const assignmentData = {
        title: formData.get('title') as string,
        description: formData.get('description') as string,
        class_id: formData.get('class_id') as string,
        due_date: formData.get('due_date') as string,
        type: 'essay' as const,
        submission_type: formData.get('submission_type') as 'online' | 'file_upload' | 'both',
        show_answer_after: formData.get('show_answer_after') === 'true',
        total_points: 100 // Added total_points field
      }

      // TODO: Implement assignment creation API
      
      router.push('/dashboard/teacher/exams/')
      toast({
        title: "Thành công",
        description: "Đã tạo bài tập mới"
      })
    } catch (error) {
      console.error('Error creating assignment:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tạo bài tập"
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài tập mới</h2>
        <p className="text-muted-foreground">
          Tạo bài tập mới cho lớp học của bạn
        </p>
      </div>

      <Tabs defaultValue="manual" onValueChange={setAssignmentType}>
        <TabsList>
          <TabsTrigger value="manual">Tạo thủ công</TabsTrigger>
          <TabsTrigger value="file">Tải file lên</TabsTrigger>
        </TabsList>

        <TabsContent value="manual">
          <form onSubmit={handleManualCreate} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Tiêu đề</label>
              <input
                name="title"
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Lớp học</label>
              <select
                name="class_id"
                className="w-full px-3 py-2 border rounded-md"
                required
              >
                <option value="">Chọn lớp học</option>
                {classes.map(c => (
                  <option key={c.id} value={c.id}>
                    {c.name} - {c.subject.name}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Mô tả</label>
              <Editor name="description" />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Hạn nộp</label>
              <input
                type="datetime-local"
                name="due_date"
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Hình thức nộp bài</label>
              <select
                name="submission_type"
                className="w-full px-3 py-2 border rounded-md"
                required
              >
                <option value="online">Làm trực tiếp trên web</option>
                <option value="file_upload">Nộp file</option>
                <option value="both">Cả hai hình thức</option>
              </select>
            </div>

            <div className="flex items-center space-x-2">
              <input
                type="checkbox"
                name="show_answer_after"
                id="show_answer_after"
                value="true"
              />
              <label htmlFor="show_answer_after">
                Hiển thị đáp án sau khi nộp bài
              </label>
            </div>

            <div className="flex justify-end space-x-4">
              <Button variant="outline" onClick={() => router.back()}>
                Hủy
              </Button>
              <Button 
                disabled={classes.length === 0} 
                onClick={() => router.push('/dashboard/teacher/exams/test_preparation')}
              >
                Tạo bài tập
              </Button>
            </div>
          </form>
        </TabsContent>

        <TabsContent value="file">
          <div className="space-y-4">
            <div className="border-2 border-dashed rounded-lg p-6">
              <FileUpload
                accept=".pdf,.doc,.docx"
                onUpload={handleFileUpload}
                disabled={isLoading}
              />
            </div>
            <p className="text-sm text-muted-foreground">
              Hỗ trợ file PDF, Word. File cần theo mẫu quy định để hệ thống có thể tự động nhận diện.
            </p>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  )
}
