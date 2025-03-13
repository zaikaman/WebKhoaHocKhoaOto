"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, getStudentStats, getStudentUpcomingAssignments, getStudentUpcomingExams } from "@/lib/supabase"

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

interface Assignment {
  id: string
  title: string
  due_date: string
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

interface Exam {
  id: string
  title: string
  start_time: string
  duration: number
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

interface Stats {
  totalClasses: number
  pendingAssignments: number
  averageScore: number | null
}

export default function DashboardPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [userName, setUserName] = useState("")
  const [isLoading, setIsLoading] = useState(true)
  const [courses, setCourses] = useState<Course[]>([])
  const [stats, setStats] = useState<Stats | null>(null)
  const [upcomingAssignments, setUpcomingAssignments] = useState<Assignment[]>([])
  const [upcomingExams, setUpcomingExams] = useState<Exam[]>([])

  useEffect(() => {
    checkAuth()
  }, [])

  async function checkAuth() {
    try {
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      // Kiểm tra role và chuyển hướng
      if (currentUser.profile.role === 'teacher') {
        router.push('/dashboard/teacher')
        return
      } else if (currentUser.profile.role === 'admin') {
        router.push('/admin/dashboard')
        return
      }

      // Nếu là sinh viên thì hiển thị trang này
      setUserName(currentUser.profile.full_name || currentUser.profile.student_id)

      // Lấy thống kê
      const statsData = await getStudentStats(currentUser.profile.id)
      setStats(statsData)

      // Lấy danh sách lớp học
      const classesData = await getStudentClasses(currentUser.profile.id)
      setCourses(classesData)

      // Lấy bài tập sắp đến hạn
      const assignmentsData = await getStudentUpcomingAssignments(currentUser.profile.id)
      setUpcomingAssignments(assignmentsData)

      // Lấy bài kiểm tra sắp tới
      const examsData = await getStudentUpcomingExams(currentUser.profile.id)
      setUpcomingExams(examsData)
      
      setIsLoading(false)
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu"
      })
      router.push('/login')
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Xin chào, {userName}</h2>
      </div>

      {/* Stats */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-blue-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-blue-600">
                  <path d="M18 6h-5c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h5c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                  <path d="M9 6H4c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h5c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Lớp đang học</p>
                <h3 className="text-2xl font-bold">{stats?.totalClasses || 0}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-yellow-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-yellow-600">
                  <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                  <path d="M15 2H9a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1Z" />
                  <path d="M12 11h4" />
                  <path d="M12 16h4" />
                  <path d="M8 11h.01" />
                  <path d="M8 16h.01" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Bài tập đang chờ</p>
                <h3 className="text-2xl font-bold">{stats?.pendingAssignments || 0}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-green-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-green-600">
                  <path d="M12 20v-8" />
                  <path d="M18 20V4" />
                  <path d="M6 20v-4" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Điểm trung bình</p>
                <h3 className="text-2xl font-bold">{stats?.averageScore?.toFixed(1) || 'N/A'}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-red-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-red-600">
                  <path d="M21 7.5V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-1.5" />
                  <path d="M16 2v4" />
                  <path d="M8 2v4" />
                  <path d="M3 10h18" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Deadline sắp tới</p>
                <h3 className="text-2xl font-bold">0</h3>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Recent courses */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Lớp học</h3>
          <Button variant="outline" onClick={() => router.push('/dashboard/student/courses')}>
            Xem tất cả
          </Button>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {courses.slice(0, 3).map((course) => (
            <div key={course.id} className="rounded-lg border bg-card text-card-foreground shadow-sm">
              <div className="p-6">
                <h4 className="text-lg font-semibold">{course.subject.name}</h4>
                <p className="text-sm text-gray-500 mt-2">
                  {course.name} - {course.teacher.full_name}
                </p>
                <div className="mt-4 flex items-center justify-between">
                  <span className="text-sm text-gray-500">Học kỳ: {course.semester}</span>
                  <Button 
                    variant="secondary" 
                    size="sm"
                    onClick={() => router.push(`/dashboard/student/courses/${course.id}`)}
                  >
                    Xem chi tiết
                  </Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Upcoming assignments */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Bài tập sắp đến hạn</h3>
          <Button variant="outline" onClick={() => router.push('/dashboard/student/assignments')}>
            Xem tất cả
          </Button>
        </div>
        <div className="rounded-lg border">
          <div className="p-4">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2">Tên bài tập</th>
                  <th className="text-left py-2">Môn học</th>
                  <th className="text-left py-2">Hạn nộp</th>
                  <th className="text-left py-2">Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {upcomingAssignments.map((assignment) => (
                  <tr key={assignment.id} className="border-b last:border-0">
                    <td className="py-3">{assignment.title}</td>
                    <td className="py-3">{assignment.class.subject.name}</td>
                    <td className="py-3">{new Date(assignment.due_date).toLocaleDateString('vi-VN', {
                      year: 'numeric',
                      month: '2-digit',
                      day: '2-digit',
                      hour: '2-digit',
                      minute: '2-digit'
                    })}</td>
                    <td className="py-3">
                      <span className="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                        Chưa nộp
                      </span>
                    </td>
                  </tr>
                ))}

                {upcomingAssignments.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      Không có bài tập nào sắp đến hạn
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Upcoming exams */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Bài kiểm tra sắp tới</h3>
          <Button variant="outline" onClick={() => router.push('/dashboard/student/exams')}>
            Xem tất cả
          </Button>
        </div>
        <div className="rounded-lg border">
          <div className="p-4">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2">Tên bài kiểm tra</th>
                  <th className="text-left py-2">Môn học</th>
                  <th className="text-left py-2">Thời gian</th>
                  <th className="text-left py-2">Thời lượng</th>
                </tr>
              </thead>
              <tbody>
                {upcomingExams.map((exam) => (
                  <tr key={exam.id} className="border-b last:border-0">
                    <td className="py-3">{exam.title}</td>
                    <td className="py-3">{exam.class.subject.name}</td>
                    <td className="py-3">{new Date(exam.start_time).toLocaleDateString('vi-VN', {
                      year: 'numeric',
                      month: '2-digit',
                      day: '2-digit',
                      hour: '2-digit',
                      minute: '2-digit'
                    })}</td>
                    <td className="py-3">{exam.duration} phút</td>
                  </tr>
                ))}

                {upcomingExams.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      Không có bài kiểm tra nào sắp tới
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
} 