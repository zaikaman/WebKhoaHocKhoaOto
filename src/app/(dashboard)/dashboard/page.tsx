"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getStudentClasses, getStudentStats, getStudentUpcomingAssignments, getStudentUpcomingExams, getStudentPendingExams } from "@/lib/supabase"

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
  start_time: string,
  end_time: string,
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
  const [isStatsLoading, setIsStatsLoading] = useState(true)
  const [isCoursesLoading, setIsCoursesLoading] = useState(true)
  const [isAssignmentsLoading, setIsAssignmentsLoading] = useState(true)
  const [isExamsLoading, setIsExamsLoading] = useState(true)
  const [isPendingExamsLoading, setIsPendingExamsLoading] = useState(true)
  const [courses, setCourses] = useState<Course[]>([])
  const [stats, setStats] = useState<Stats | null>(null)
  const [upcomingAssignments, setUpcomingAssignments] = useState<Assignment[]>([])
  const [upcomingExams, setUpcomingExams] = useState<Exam[]>([])
  const [pendingExams, setPendingExams] = useState<Exam[]>([])

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
      setIsStatsLoading(false)

      // Lấy danh sách lớp học
      const classesData = await getStudentClasses(currentUser.profile.id)
      setCourses(classesData)
      setIsCoursesLoading(false)

      // Lấy bài tập sắp đến hạn
      const assignmentsData = await getStudentUpcomingAssignments(currentUser.profile.id)
      setUpcomingAssignments(assignmentsData)
      setIsAssignmentsLoading(false)

      // Lấy bài kiểm tra sắp tới
      const examsData = await getStudentUpcomingExams(currentUser.profile.id)
      setUpcomingExams(examsData)
      setIsExamsLoading(false)

      // Lấy bài kiểm tra chưa làm
      const pendingExamsData = await getStudentPendingExams(currentUser.profile.id)
      setPendingExams(pendingExamsData)
      setIsPendingExamsLoading(false)
      
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

  // Skeleton components
  const StatsSkeleton = () => (
    <div className="rounded-xl border bg-card text-card-foreground shadow">
      <div className="p-6">
        <div className="flex items-center gap-4">
          <div className="p-3 bg-muted rounded-full animate-pulse">
            <div className="w-6 h-6" />
          </div>
          <div>
            <div className="h-4 w-24 bg-muted rounded animate-pulse mb-2" />
            <div className="h-8 w-12 bg-muted rounded animate-pulse" />
          </div>
        </div>
      </div>
    </div>
  )

  const CourseSkeleton = () => (
    <div className="rounded-lg border bg-card text-card-foreground shadow-sm">
      <div className="p-6">
        <div className="h-6 w-48 bg-muted rounded animate-pulse mb-2" />
        <div className="h-4 w-64 bg-muted rounded animate-pulse" />
        <div className="mt-4 flex items-center justify-between">
          <div className="h-4 w-32 bg-muted rounded animate-pulse" />
          <div className="h-8 w-24 bg-muted rounded animate-pulse" />
        </div>
      </div>
    </div>
  )

  const TableRowSkeleton = () => (
    <tr className="border-b last:border-0">
      <td className="py-3">
        <div className="h-4 w-48 bg-muted rounded animate-pulse" />
      </td>
      <td className="py-3">
        <div className="h-4 w-32 bg-muted rounded animate-pulse" />
      </td>
      <td className="py-3">
        <div className="h-4 w-40 bg-muted rounded animate-pulse" />
      </td>
      <td className="py-3">
        <div className="h-4 w-24 bg-muted rounded animate-pulse" />
      </td>
    </tr>
  )

  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight w-full sm:w-auto sm:text-left">Xin chào, {userName}</h2>
      </div>

      {/* Stats */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {isStatsLoading ? (
          <>
            <StatsSkeleton />
            <StatsSkeleton />
            <StatsSkeleton />
            <StatsSkeleton />
          </>
        ) : (
          <>
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
          </>
        )}
      </div>

      {/* Recent courses */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
          <h3 className="text-lg font-medium w-full sm:w-auto sm:text-left">Lớp học</h3>
          <Button variant="outline" className="w-full sm:w-auto" onClick={() => router.push('/dashboard/student/courses')}>
            Xem tất cả
          </Button>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {isCoursesLoading ? (
            <>
              <CourseSkeleton />
              <CourseSkeleton />
              <CourseSkeleton />
            </>
          ) : courses.length === 0 ? (
            <div className="col-span-full p-4 text-center text-muted-foreground">
              Chưa có lớp học nào
            </div>
          ) : (
            courses.slice(0, 3).map((course) => (
              <div key={course.id} className="rounded-lg border bg-card text-card-foreground shadow-sm">
                <div className="p-6">
                  <h4 className="text-lg font-semibold">{course.subject.name}</h4>
                  <p className="text-sm text-gray-500 mt-2">
                    {course.name} - {course.teacher.full_name}
                  </p>
                    <span className="text-sm text-gray-500">Học kỳ: {course.semester}</span>
                  <div className="mt-4 flex flex-col sm:flex-row items-center justify-between gap-2 sm:gap-0">
                    <Button 
                      variant="secondary" 
                      size="sm"
                      className="hover:bg-black hover:text-white transition-colors w-full sm:w-auto"
                      onClick={() => router.push(`/dashboard/student/courses/${course.id}`)}
                    >
                      Xem chi tiết
                    </Button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Upcoming assignments */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
          <h3 className="text-lg font-medium w-full sm:w-auto sm:text-left">Bài tập sắp đến hạn</h3>
          <Button variant="outline" className="w-full sm:w-auto" onClick={() => router.push('/dashboard/assignments')}>
            Xem tất cả
          </Button>
        </div>
        <div className="rounded-lg border overflow-x-auto">
          <div className="p-4 min-w-[600px]">
            <table className="min-w-[600px] w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Tên bài tập</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Môn học</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Hạn nộp</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {isAssignmentsLoading ? (
                  <>
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                  </>
                ) : upcomingAssignments.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      Không có bài tập nào sắp đến hạn
                    </td>
                  </tr>
                ) : (
                  upcomingAssignments.map((assignment) => (
                    <tr key={assignment.id} className="border-b last:border-0">
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{assignment.title}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{assignment.class.subject.name}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{new Date(assignment.due_date).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">
                        <span className="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                          Chưa nộp
                        </span>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Pending exams */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
          <h3 className="text-lg font-medium w-full sm:w-auto sm:text-left">Bài kiểm tra chưa làm</h3>
          <Button variant="outline" className="w-full sm:w-auto" onClick={() => router.push('/dashboard/student/exams')}>
            Xem tất cả
          </Button>
        </div>
        <div className="rounded-lg border overflow-x-auto">
          <div className="p-4 min-w-[600px]">
            <table className="min-w-[600px] w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Tên bài kiểm tra</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Môn học</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời gian bắt đầu</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời gian kết thúc</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời lượng</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4"></th>
                </tr>
              </thead>
              <tbody>
                {isPendingExamsLoading ? (
                  <>
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                  </>
                ) : pendingExams.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="py-8 text-center text-muted-foreground">
                      Không có bài kiểm tra nào chưa làm
                    </td>
                  </tr>
                ) : (
                  pendingExams.map((exam) => (
                    <tr key={exam.id} className="border-b last:border-0">
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.title}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.class.subject.name}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{new Date(exam.start_time).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{new Date(exam.end_time).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.duration} phút</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">
                        <Button 
                          variant="secondary" 
                          size="sm"
                          onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                        >
                          Làm bài
                        </Button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Upcoming exams */}
      <div className="space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
          <h3 className="text-lg font-medium w-full sm:w-auto sm:text-left">Bài kiểm tra sắp tới</h3>
          <Button variant="outline" className="w-full sm:w-auto" onClick={() => router.push('/dashboard/student/exams')}>
            Xem tất cả
          </Button>
        </div>
        <div className="rounded-lg border overflow-x-auto">
          <div className="p-4 min-w-[600px]">
            <table className="min-w-[600px] w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Tên bài kiểm tra</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Môn học</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời gian</th>
                  <th className="text-left py-2 px-2 sm:py-3 sm:px-4">Thời lượng</th>
                </tr>
              </thead>
              <tbody>
                {isExamsLoading ? (
                  <>
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                    <TableRowSkeleton />
                  </>
                ) : upcomingExams.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      Không có bài kiểm tra nào sắp tới
                    </td>
                  </tr>
                ) : (
                  upcomingExams.map((exam) => (
                    <tr key={exam.id} className="border-b last:border-0">
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.title}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.class.subject.name}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{new Date(exam.start_time).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                      })}</td>
                      <td className="py-2 px-2 sm:py-3 sm:px-4">{exam.duration} phút</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}