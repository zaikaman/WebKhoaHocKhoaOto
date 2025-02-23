"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import Link from "next/link"
import Image from "next/image"
import { getCurrentUser, getStudentClasses } from "@/lib/supabase"

interface Course {
  id: string
  code: string
  name: string
  semester: string
  academic_year: string
  status: string
  teacher: {
    id: string
    full_name: string
  }
  subjects: {
    id: string
    name: string
    code: string
    credits: number
  }
}

export default function CoursesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [courses, setCourses] = useState<Course[]>([])

  useEffect(() => {
    loadCourses()
  }, [])

  async function loadCourses() {
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

      const classesData = await getStudentClasses(currentUser.profile.id)
      setCourses(classesData)
      
    } catch (error) {
      console.error('Lỗi khi tải danh sách lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách lớp học"
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Lớp học của tôi</h2>
          <p className="text-muted-foreground">
            Danh sách các lớp học đang tham gia
          </p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {courses.map((course) => (
          <Link
          href={`/dashboard/student/courses/${course.id}`}
          key={course.id}
          className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-md"
        >
            <div className="p-6">
              <h3 className="text-lg font-semibold group-hover:text-primary transition-colors">
                {course.name}
              </h3>
              <p className="text-sm text-muted-foreground mt-1">
                Mã lớp: {course.code}
              </p>
              <p className="text-sm text-muted-foreground">
                Giảng viên: {course.teacher.full_name}
              </p>
              <div className="mt-2">
                <p className="text-sm">Môn học: {course.subjects.name}</p>
                <p className="text-sm">Mã môn: {course.subjects.code}</p>
                <p className="text-sm">Số tín chỉ: {course.subjects.credits}</p>
              </div>
              <div className="mt-4">
                <p className="text-sm text-muted-foreground">
                  {course.semester} - {course.academic_year}
                </p>
              </div>
              <div className="mt-4 flex justify-end">
                <Button variant="secondary" className="group-hover:bg-primary group-hover:text-primary-foreground transition-colors">
                  Xem chi tiết
                </Button>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
} 