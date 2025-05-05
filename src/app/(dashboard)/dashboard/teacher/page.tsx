"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { 
  getCurrentUser,
  getTeacherStats,
  getTeacherClasses,
  getClassAssignments,
  getClassExams,
  getClassLectures
} from "@/lib/supabase"

// Types
type Stats = {
  totalClasses: number | null
  totalStudents: number | null
  pendingAssignments: number | null
  upcomingDeadlines: number | null
  totalLectures: number | null
  totalExams: number | null
  averageScore: number | null
}

type UpcomingEvent = {
  id: string
  title: string
  date: string
  type: 'assignment' | 'exam' | 'class'
}

type Lecture = {
  id: string
  title: string
  description: string
  subject: string
  uploadDate: string
  downloadCount: number
  fileUrl: string
}

type Exam = {
  id: string
  title: string
  subject: string
  date: string
  duration: number
  totalStudents: number
  submittedCount: number
  averageScore: number | null
  status: 'upcoming' | 'in-progress' | 'completed'
}

export default function TeacherDashboardPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [teacherName, setTeacherName] = useState('')
  const [stats, setStats] = useState<Stats>({
    totalClasses: null,
    totalStudents: null,
    pendingAssignments: null,
    upcomingDeadlines: null,
    totalLectures: null,
    totalExams: null,
    averageScore: null
  })
  const [upcomingEvents, setUpcomingEvents] = useState<UpcomingEvent[]>([])
  const [recentLectures, setRecentLectures] = useState<Lecture[]>([])
  const [recentExams, setRecentExams] = useState<Exam[]>([])

  useEffect(() => {
    loadDashboardData()
  }, [])

  async function loadDashboardData() {
    try {
      setIsLoading(true)
      
      // Lấy thông tin người dùng hiện tại
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      // Lưu tên giảng viên
      setTeacherName(currentUser.profile.full_name || 'Giảng viên')

      // Lấy thống kê từ Supabase
      const teacherStats = await getTeacherStats(currentUser.profile.id)
      setStats({
        totalClasses: teacherStats.totalClasses,
        totalStudents: teacherStats.totalStudents,
        totalLectures: teacherStats.totalLectures,
        totalExams: teacherStats.totalExams,
        pendingAssignments: 0, // TODO: Implement later
        upcomingDeadlines: 0, // TODO: Implement later
        averageScore: 0 // TODO: Implement later
      })

      // Lấy danh sách lớp học
      const classes = await getTeacherClasses(currentUser.profile.id)
      
      // Lấy các sự kiện sắp tới
      const upcomingEvents: UpcomingEvent[] = []
      
      // Thêm deadline bài tập
      for (const classItem of classes) {
        const assignments = await getClassAssignments(classItem.id)
        const upcomingAssignments = assignments.filter(a => 
          new Date(a.due_date) > new Date() && 
          new Date(a.due_date) < new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 ngày tới
        )
        upcomingEvents.push(...upcomingAssignments.map(a => ({
          id: a.id,
          title: a.title,
          date: a.due_date,
          type: 'assignment' as const
        })))
      }

      // Thêm các bài kiểm tra sắp tới
      for (const classItem of classes) {
        const exams = await getClassExams(classItem.id)
        const upcomingExams = exams.filter(e =>
          new Date(e.start_time) > new Date() &&
          new Date(e.start_time) < new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 ngày tới
        )
        upcomingEvents.push(...upcomingExams.map(e => ({
          id: e.id,
          title: e.title,
          date: e.start_time,
          type: 'exam' as const
        })))
      }

      // Sắp xếp theo thời gian và giới hạn 5 sự kiện
      upcomingEvents.sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime())
      setUpcomingEvents(upcomingEvents.slice(0, 5))

      // Lấy bài giảng gần đây
      const recentLecturesData: Lecture[] = []
      for (const classItem of classes) {
        const lectures = await getClassLectures(classItem.id)
        recentLecturesData.push(...lectures.map(l => ({
          id: l.id,
          title: l.title,
          description: l.description || '',
          subject: classItem.subject.name,
          uploadDate: l.created_at,
          downloadCount: l.download_count,
          fileUrl: l.file_url
        })))
      }

      // Sắp xếp theo thời gian và giới hạn 3 bài giảng
      recentLecturesData.sort((a, b) => new Date(b.uploadDate).getTime() - new Date(a.uploadDate).getTime())
      setRecentLectures(recentLecturesData.slice(0, 3))

      // Lấy bài kiểm tra gần đây
      const recentExamsData: Exam[] = []
      for (const classItem of classes) {
        const exams = await getClassExams(classItem.id)
        recentExamsData.push(...exams.map(e => ({
          id: e.id,
          title: e.title,
          subject: classItem.subject.name,
          date: e.start_time,
          duration: e.duration,
          totalStudents: 0, // TODO: Implement later
          submittedCount: 0, // TODO: Implement later
          averageScore: null, // TODO: Implement later
          status: e.status
        })))
      }

      // Sắp xếp theo thời gian và giới hạn 3 bài kiểm tra
      recentExamsData.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime())
      setRecentExams(recentExamsData.slice(0, 3))

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu dashboard"
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Xin chào, {teacherName}</h2>
        <Button variant="outline" onClick={loadDashboardData} disabled={isLoading}>
          {isLoading ? "Đang tải..." : "Làm mới"}
        </Button>
      </div>

      {/* Thống kê tổng quan */}
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
                <p className="text-sm font-medium text-muted-foreground">Lớp học</p>
                <h3 className="text-2xl font-bold">{stats.totalClasses}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-green-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-green-600">
                  <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                  <circle cx="9" cy="7" r="4" />
                  <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                  <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Sinh viên</p>
                <h3 className="text-2xl font-bold">{stats.totalStudents}</h3>
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
                <p className="text-sm font-medium text-muted-foreground">Bài tập chờ chấm</p>
                <h3 className="text-2xl font-bold">{stats.pendingAssignments}</h3>
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
                <h3 className="text-2xl font-bold">{stats.upcomingDeadlines}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-purple-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-purple-600">
                  <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20" />
                  <path d="m9 9 3 3-3 3" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Bài giảng</p>
                <h3 className="text-2xl font-bold">{stats.totalLectures}</h3>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-100 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-orange-600">
                  <path d="M9 11l3 3L22 4" />
                  <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-muted-foreground">Bài kiểm tra</p>
                <h3 className="text-2xl font-bold">{stats.totalExams}</h3>
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
                <h3 className="text-2xl font-bold">{stats.averageScore?.toFixed(1)}</h3>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Sự kiện sắp tới */}
      <div>
        <h3 className="text-xl font-semibold mb-4">Sự kiện sắp tới</h3>
        <div className="rounded-xl border shadow">
          <div className="divide-y">
            {upcomingEvents.map((event) => (
              <div key={event.id} className="p-4 hover:bg-muted/50 transition-colors">
                <div className="flex items-center gap-4">
                  <div className={`p-2 rounded-full ${
                    event.type === 'assignment' 
                      ? 'bg-blue-100 text-blue-600'
                      : event.type === 'exam'
                      ? 'bg-red-100 text-red-600'
                      : 'bg-green-100 text-green-600'
                  }`}>
                    {event.type === 'assignment' ? (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                        <path d="M15 2H9a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1Z" />
                      </svg>
                    ) : event.type === 'exam' ? (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M12 8v4l3 3" />
                        <circle cx="12" cy="12" r="10" />
                      </svg>
                    ) : (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
                        <line x1="16" x2="16" y1="2" y2="6" />
                        <line x1="8" x2="8" y1="2" y2="6" />
                        <line x1="3" x2="21" y1="10" y2="10" />
                      </svg>
                    )}
                  </div>
                  <div className="flex-1">
                    <h4 className="font-medium">{event.title}</h4>
                    <p className="text-sm text-muted-foreground">
                      {new Date(event.date).toLocaleDateString('vi-VN', {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                      })}
                    </p>
                  </div>
                  <Button variant="ghost" size="sm">
                    Chi tiết
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Bài giảng gần đây */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-xl font-semibold">Bài giảng gần đây</h3>
          <Button variant="outline" size="sm" onClick={() => router.push('/dashboard/teacher/lectures')}>
            Xem tất cả
          </Button>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {recentLectures.map((lecture) => (
            <div key={lecture.id} className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
              <div className="p-6">
                <div className="flex items-start justify-between">
                  <div className="space-y-1">
                    <h4 className="font-semibold line-clamp-2">{lecture.title}</h4>
                    <p className="text-sm text-muted-foreground">{lecture.subject}</p>
                  </div>
                  <Button variant="ghost" size="icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                      <polyline points="7 10 12 15 17 10" />
                      <line x1="12" x2="12" y1="15" y2="3" />
                    </svg>
                  </Button>
                </div>
                <p className="mt-2 text-sm text-muted-foreground line-clamp-2">
                  {lecture.description}
                </p>
                <div className="mt-4 flex items-center justify-between text-sm text-muted-foreground">
                  <p>Ngày tải lên: {new Date(lecture.uploadDate).toLocaleDateString('vi-VN')}</p>
                  <p>{lecture.downloadCount} lượt tải</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Bài kiểm tra */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-xl font-semibold">Bài kiểm tra gần đây</h3>
          <div className="flex items-center gap-2">
            <Button size="sm" onClick={() => router.push('/dashboard/teacher/exams')}>
              Tạo bài kiểm tra
            </Button>
            <Button variant="outline" size="sm" onClick={() => router.push('/dashboard/teacher/exams/list')}>
              Xem tất cả
            </Button>
          </div>
        </div>
        <div className="rounded-xl border shadow">
          <div className="divide-y">
            {recentExams.map((exam) => (
              <div key={exam.id} className="p-4 hover:bg-muted/50 transition-colors">
                <div className="flex items-center gap-4">
                  <div className={`p-2 rounded-full ${
                    exam.status === 'completed'
                      ? 'bg-green-100 text-green-600'
                      : exam.status === 'in-progress'
                      ? 'bg-blue-100 text-blue-600'
                      : 'bg-orange-100 text-orange-600'
                  }`}>
                    {exam.status === 'completed' ? (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M20 6 9 17l-5-5" />
                      </svg>
                    ) : exam.status === 'in-progress' ? (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M12 2v4" />
                        <path d="M12 18v4" />
                        <path d="M4.93 4.93l2.83 2.83" />
                        <path d="M16.24 16.24l2.83 2.83" />
                        <path d="M2 12h4" />
                        <path d="M18 12h4" />
                        <path d="M4.93 19.07l2.83-2.83" />
                        <path d="M16.24 7.76l2.83-2.83" />
                      </svg>
                    ) : (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M12 8v4l3 3" />
                        <circle cx="12" cy="12" r="10" />
                      </svg>
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <h4 className="font-medium">{exam.title}</h4>
                      <span className={`px-2 py-0.5 text-xs rounded-full ${
                        exam.status === 'completed'
                          ? 'bg-green-100 text-green-700'
                          : exam.status === 'in-progress'
                          ? 'bg-blue-100 text-blue-700'
                          : 'bg-orange-100 text-orange-700'
                      }`}>
                        {exam.status === 'completed' 
                          ? 'Đã hoàn thành'
                          : exam.status === 'in-progress'
                          ? 'Đang diễn ra'
                          : 'Sắp diễn ra'}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground mt-1">{exam.subject}</p>
                    <div className="grid grid-cols-4 gap-4 mt-2 text-sm">
                      <div>
                        <p className="text-muted-foreground">Thời gian</p>
                        <p className="font-medium">{exam.duration} phút</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Tổng số SV</p>
                        <p className="font-medium">{exam.totalStudents}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Đã nộp</p>
                        <p className="font-medium">{exam.submittedCount}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Điểm TB</p>
                        <p className="font-medium">{exam.averageScore?.toFixed(1)}</p>
                      </div>
                    </div>
                  </div>
                  <Button variant="ghost" size="sm">
                    Chi tiết
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
} 
