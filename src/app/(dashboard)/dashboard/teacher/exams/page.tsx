"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useToast } from '@/components/ui/use-toast'
import { Button } from '@/components/ui/button'
import { Editor } from '@/components/editor'
import { getTeacherClasses, getCurrentUser, createExam } from '@/lib/supabase'

interface Class {
  id: string;
  name: string;
  subject: {
    name: string;
  };
}

export default function CreateExamPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [classes, setClasses] = useState<Class[]>([])

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

  async function handleManualCreate(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)

      const examData = {
        title: formData.get('title') as string,
        description: formData.get('description') as string,
        class_id: formData.get('class_id') as string,
        type: formData.get('type') as "quiz" | "midterm" | "final",
        duration: Number(formData.get('duration')) || 60,
        total_points: Number(formData.get('total_points')) || 100,
        start_time: formData.get('start_time') as string,
        end_time: formData.get('end_time') as string,
        status: 'upcoming' as "completed" | "upcoming" | "in-progress",
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }

      // Call the createExam function to save the exam data
      const exam = await createExam(examData)
      if (!exam) throw new Error('Không thể tạo bài kiểm tra')

      router.push(`/dashboard/teacher/exams/examQuestion?examId=${exam.id}`)
      toast({
        title: "Thành công",
        description: "Đã tạo bài kiểm tra mới"
      })
    } catch (error) {
      console.error('Error creating exam:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tạo bài kiểm tra"
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài kiểm tra mới</h2>
        <p className="text-muted-foreground">
          Tạo bài kiểm tra mới cho lớp học của bạn
        </p>
      </div>

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
          <label className="text-sm font-medium">Thời gian bắt đầu</label>
          <input
            type="datetime-local"
            name="start_time"
            className="w-full px-3 py-2 border rounded-md"
            required
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Thời gian kết thúc</label>
          <input
            type="datetime-local"
            name="end_time"
            className="w-full px-3 py-2 border rounded-md"
            required
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Thời gian làm bài (phút)</label>
          <input
            type="number"
            name="duration"
            className="w-full px-3 py-2 border rounded-md"
            defaultValue={60}
            min={1}
            required
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Loại bài kiểm tra</label>
          <select
            name="type"
            className="w-full px-3 py-2 border rounded-md"
            required
          >
            <option value="quiz">Quiz</option>
            <option value="midterm">Midterm</option>
            <option value="final">Final</option>
          </select>
        </div>
        <div className="flex justify-end space-x-4">
          <Button variant="outline" onClick={() => router.back()}>
            Hủy
          </Button>
          <Button type="submit" disabled={isLoading}>
            Tạo bài kiểm tra
          </Button>
        </div>
      </form>
    </div>
  )
}
