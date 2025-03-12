"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { getTeacherClasses, createLecture, getCurrentUser } from '@/lib/supabase'


type Class = {
  id: string;
  name: string;
  subject: {
    name: string;
  };
}

export default function CreateLecturePage() {
  const router = useRouter()
  const { toast } = useToast()
  const [classes, setClasses] = useState<Class[]>([])
  const [isLoading, setIsLoading] = useState(false)

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
      console.error('Lỗi khi tải danh sách lớp:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: 'Không thể tải danh sách lớp'
      })
    }
  }

  async function handleCreateLecture(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      const lectureData = {
        title: formData.get('title') as string,
        description: formData.get('description') as string,
        class_id: formData.get('class_id') as string,
        file_url: formData.get('file_url') as string,
        file_type: "unknown",
        file_size: 0,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }

      const lecture = await createLecture(lectureData)
      if (!lecture) throw new Error('Không thể tạo bài giảng')

      toast({
        title: 'Thành công',
        description: 'Đã tạo bài giảng mới'
      })
      router.push('/dashboard/teacher/lectures')
    } catch (error) {
      console.error('Lỗi khi tạo bài giảng:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: 'Không thể tạo bài giảng'
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo bài giảng mới</h2>
      </div>
      <form onSubmit={handleCreateLecture} className="space-y-4">
        <div className="space-y-2">
          <label className="text-sm font-medium">Tiêu đề</label>
          <Input name="title" required className="w-full px-3 py-2 border rounded-md" />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Mô tả</label>
          <Textarea name="description" required className="w-full px-3 py-2 border rounded-md" rows={4} />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Lớp học</label>
          <select name="class_id" required className="w-full px-3 py-2 border rounded-md">
            <option value="">Chọn lớp học</option>
            {classes.map(c => (
              <option key={c.id} value={c.id}>
                {c.name} - {c.subject.name}
              </option>
            ))}
          </select>
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">File bài giảng (URL)</label>
          <Input name="file_url" placeholder="Nhập URL của file bài giảng" required className="w-full px-3 py-2 border rounded-md" />
        </div>
        <div className="flex justify-end space-x-4">
          <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
          <Button type="submit" disabled={isLoading}>{isLoading ? 'Đang tạo...' : 'Tạo bài giảng'}</Button>
        </div>
      </form>
    </div>
  )
}
