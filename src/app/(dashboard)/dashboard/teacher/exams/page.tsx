"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useToast } from '@/components/ui/use-toast'
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { getTeacherClasses, getCurrentUser, createExam } from '@/lib/supabase'
import { sanitizeDescription } from '@/lib/utils'

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
        description: sanitizeDescription(formData.get('description') as string),
        class_id: formData.get('class_id') as string,
        type: formData.get('type') as "quiz" | "midterm" | "final",
        duration: Number(formData.get('duration')) || 60,
        total_points: Number(formData.get('total_points')) || 100,
        start_time: formData.get('start_time') as string,
        end_time: formData.get('end_time') as string,
        status: 'upcoming' as "completed" | "upcoming" | "in-progress",
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
        max_attempts: Number(formData.get('max_attempts')) || 1,
        questions_to_show: Number(formData.get('questions_to_show')) || null
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
        <div className="form-field">
          <input
            name="title"
            className="form-input peer"
            required
            placeholder="Tiêu đề"
          />
          <label className="form-label">Tiêu đề</label>
        </div>
        <div className="form-field">
          <label className="absolute -top-3 left-3 text-sm text-blue-500">Lớp học</label>
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
        <div className="relative pt-5">
          <Textarea 
            name="description"
            placeholder="Nhập mô tả bài kiểm tra"
            className="form-textarea peer"
            rows={4}
          />
          <label className="form-textarea-label">Mô tả</label>
        </div>
        <div className="form-field">
          <input
            type="datetime-local"
            name="start_time"
            className="form-input peer"
            required
            placeholder="Thời gian bắt đầu"
          />
          <label className="form-label">Thời gian bắt đầu</label>
        </div>
        <div className="form-field">
          <input
            type="datetime-local"
            name="end_time"
            className="form-input peer"
            required
            placeholder="Thời gian kết thúc"
          />
          <label className="form-label">Thời gian kết thúc</label>
        </div>
        <div className="form-field">
          <input
            type="number"
            name="duration"
            className="form-input peer"
            defaultValue={60}
            min={1}
            required
            placeholder="Thời gian làm bài (phút)"
          />
          <label className="form-label">Thời gian làm bài (phút)</label>
        </div>
        <div className="form-field">
          <input
            type="number"
            name="total_points"
            className="form-input peer"
            defaultValue={100}
            min={1}
            required
            placeholder="Tổng điểm"
          />
          <label className="form-label">Tổng điểm</label>
        </div>
        <div className="form-field">
          <input
            type="number"
            name="max_attempts"
            className="form-input peer"
            defaultValue={1}
            min={1}
            required
            placeholder="Số lần làm bài"
          />
          <label className="form-label">Số lần làm bài</label>
        </div>
        <div className="form-field">
          <input
            type="number"
            name="questions_to_show"
            className="form-input peer"
            min={1}
            placeholder="Để trống nếu muốn hiển thị tất cả câu hỏi"
          />
          <label className="form-label">Số câu hỏi hiển thị</label>
        </div>
        <div className="form-field">
          <label className="absolute -top-3 left-3 text-sm text-blue-500">Loại bài kiểm tra</label>
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
