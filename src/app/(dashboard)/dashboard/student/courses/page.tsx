"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Input } from "@/components/ui/input"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { getCurrentUser, getStudentClasses, createEnrollment } from "@/lib/supabase"

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
  subject: {
    id: string
    name: string
    credits: number
  }
}

export default function StudentCoursesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [courses, setCourses] = useState<Course[]>([])
  const [classCode, setClassCode] = useState("")
  const [isJoining, setIsJoining] = useState(false)
  const [isDialogOpen, setIsDialogOpen] = useState(false)

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

      const coursesData = await getStudentClasses(currentUser.profile.id)
      setCourses(coursesData)
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

  async function handleJoinClass() {
    if (!classCode.trim()) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Vui lòng nhập mã lớp học"
      })
      return
    }

    try {
      setIsJoining(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      const result = await createEnrollment({
        student_id: currentUser.profile.student_id,
        full_name: currentUser.profile.full_name || '',
        class_id: classCode
      })

      if (result.success) {
        toast({
          title: "Thành công",
          description: "Đã tham gia lớp học thành công"
        })
        setClassCode("")
        setIsDialogOpen(false)
        loadCourses() // Tải lại danh sách lớp học
      } else {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: result.message
        })
      }
    } catch (error: any) {
      console.error('Lỗi khi tham gia lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể tham gia lớp học"
      })
    } finally {
      setIsJoining(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[200px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Lớp học của tôi</h2>
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button>Tham gia lớp học</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Tham gia lớp học</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 py-4">
              <div className="flex items-center gap-3">
                <Label htmlFor="class-code" >Mã lớp học :</Label>
                <Input
                  id="class-code"
                  placeholder="Nhập mã lớp học"
                  value={classCode}
                  onChange={(e) => setClassCode(e.target.value)}
                  className="flex-1"
                />
              </div>
              <Button 
                className="w-full" 
                onClick={handleJoinClass}
                disabled={isJoining}
              >
                {isJoining ? "Đang xử lý..." : "Tham gia"}
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {courses.map((course) => (
          <div 
            key={course.id} 
            className="rounded-lg border bg-card text-card-foreground shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="p-6 space-y-4">
              <div className="space-y-2">
                <h3 className="text-lg font-semibold">{course.subject.name}</h3>
                <p className="text-sm text-muted-foreground">
                  {course.name} - {course.teacher.full_name}
                </p>
              </div>
              <div className="space-y-2 text-sm text-muted-foreground">
                <p>Mã lớp: {course.code}</p>
                <p>Học kỳ: {course.semester}</p>
                <p>Năm học: {course.academic_year}</p>
                <p>Số tín chỉ: {course.subject.credits}</p>
              </div>
              <div className="flex justify-end">
                <Button
                  variant="secondary"
                  onClick={() => router.push(`/dashboard/student/courses/${course.id}`)}
                  className="transition-colors hover:bg-black hover:text-white"
                >
                  Xem chi tiết
                </Button>
              </div>
            </div>
          </div>
        ))}

        {courses.length === 0 && (
          <div className="col-span-full text-center py-12">
            <div className="text-muted-foreground">Bạn chưa tham gia lớp học nào</div>
          </div>
        )}
      </div>
    </div>
  )
} 