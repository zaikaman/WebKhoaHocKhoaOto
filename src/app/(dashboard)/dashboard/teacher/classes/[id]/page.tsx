"use client"

import { useEffect, useState, use } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import {
  getCurrentUser,
  getClassById,
  getClassStudents,
  getClassLectures,
  getClassAssignments,
  getClassExams
} from "@/lib/supabase"
import type { Class, Student, Lecture, Assignment, Exam } from "@/lib/supabase"

export default function ClassDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params)
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [classData, setClassData] = useState<Class | null>(null)
  const [students, setStudents] = useState<Student[]>([])
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [exams, setExams] = useState<Exam[]>([])

  useEffect(() => {
    loadClassData()
  }, [])

  async function loadClassData() {
    try {
      setIsLoading(true)
      setError(null)
      
      const currentUser = await getCurrentUser()

      if (!currentUser) {
        router.push('/login')
        return
      }

      if (currentUser.profile.role !== 'teacher') {
        setError('Bạn không có quyền truy cập trang này')
        toast({
          variant: "destructive",
          title: "Lỗi phân quyền",
          description: "Bạn không có quyền truy cập trang này"
        })
        return
      }

      try {
        const classResponse = await getClassById(id)
        if (!classResponse) {
          setError('Không tìm thấy thông tin lớp học')
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: "Không tìm thấy thông tin lớp học"
          })
          return
        }

        // Kiểm tra xem giáo viên có phải là người phụ trách lớp này không
        if (classResponse.teacher_id !== currentUser.profile.id) {
          setError('Bạn không phải là giáo viên phụ trách lớp học này')
          toast({
            variant: "destructive",
            title: "Lỗi phân quyền",
            description: "Bạn không phải là giáo viên phụ trách lớp học này"
          })
          return
        }

        setClassData(classResponse)

        // Tải dữ liệu sinh viên
        try {
          const studentsResponse = await getClassStudents(id)
          setStudents(studentsResponse)
        } catch (error: any) {
          console.error('Lỗi khi tải danh sách sinh viên:', error)
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: `Không thể tải danh sách sinh viên: ${error.message}`
          })
        }

        // Tải dữ liệu bài giảng
        try {
          const lecturesResponse = await getClassLectures(id)
          setLectures(lecturesResponse)
        } catch (error: any) {
          console.error('Lỗi khi tải danh sách bài giảng:', error)
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: `Không thể tải danh sách bài giảng: ${error.message}`
          })
        }

        // Tải dữ liệu bài tập
        try {
          const assignmentsResponse = await getClassAssignments(id)
          setAssignments(assignmentsResponse)
        } catch (error: any) {
          console.error('Lỗi khi tải danh sách bài tập:', error)
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: `Không thể tải danh sách bài tập: ${error.message}`
          })
        }

        // Tải dữ liệu bài kiểm tra
        try {
          const examsResponse = await getClassExams(id)
          setExams(examsResponse)
        } catch (error: any) {
          console.error('Lỗi khi tải danh sách bài kiểm tra:', error)
          toast({
            variant: "destructive",
            title: "Lỗi",
            description: `Không thể tải danh sách bài kiểm tra: ${error.message}`
          })
        }

      } catch (error: any) {
        console.error('Chi tiết lỗi:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        setError(`Không thể tải dữ liệu lớp học: ${error.message}`)
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: `Không thể tải dữ liệu lớp học: ${error.message}`
        })
      }
    } catch (error: any) {
      console.error('Lỗi:', error)
      setError('Có lỗi xảy ra, vui lòng thử lại sau')
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Có lỗi xảy ra, vui lòng thử lại sau"
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

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <h3 className="text-lg font-semibold mb-2 text-red-600">{error}</h3>
        <Button variant="outline" onClick={() => router.back()}>
          Quay lại
        </Button>
      </div>
    )
  }

  if (!classData) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <h3 className="text-lg font-semibold mb-2">Không tìm thấy lớp học</h3>
        <Button variant="outline" onClick={() => router.back()}>
          Quay lại
        </Button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">{classData.name}</h1>
          <p className="text-muted-foreground mt-1">
            Mã lớp: {classData.code} • {classData.semester} - {classData.academic_year}
          </p>
        </div>
        <Button variant="outline" onClick={() => router.back()}>
          Quay lại
        </Button>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="info">
        <TabsList>
          <TabsTrigger value="info">Thông tin</TabsTrigger>
          <TabsTrigger value="students">Sinh viên ({students.length})</TabsTrigger>
          <TabsTrigger value="lectures">Bài giảng ({lectures.length})</TabsTrigger>
          <TabsTrigger value="assignments">Bài tập ({assignments.length})</TabsTrigger>
          <TabsTrigger value="exams">Kiểm tra ({exams.length})</TabsTrigger>
        </TabsList>

        {/* Thông tin */}
        <TabsContent value="info" className="space-y-6">
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
              <h3 className="font-semibold mb-2">Tổng quan</h3>
              <div className="space-y-2">
                <p>Số sinh viên: {students.length}</p>
                <p>Số bài giảng: {lectures.length}</p>
                <p>Số bài tập: {assignments.length}</p>
                <p>Số bài kiểm tra: {exams.length}</p>
              </div>
            </div>
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
              <h3 className="font-semibold mb-2">Thông tin chung</h3>
              <div className="space-y-2">
                <p>Mã môn học: {classData.subject_id}</p>
                <p>Học kỳ: {classData.semester}</p>
                <p>Năm học: {classData.academic_year}</p>
                <p>Trạng thái: {classData.status === 'active' ? 'Đang diễn ra' : 'Đã kết thúc'}</p>
              </div>
            </div>
          </div>
        </TabsContent>

        {/* Danh sách sinh viên */}
        <TabsContent value="students">
          <div className="rounded-md border">
            <div className="p-4">
              <Button>Thêm sinh viên</Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">MSSV</th>
                  <th className="py-3 px-4 text-left font-medium">Họ và tên</th>
                  <th className="py-3 px-4 text-left font-medium">Email</th>
                  <th className="py-3 px-4 text-left font-medium">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {students.map((student) => (
                  <tr key={student.id} className="border-t">
                    <td className="py-3 px-4">{student.student_id}</td>
                    <td className="py-3 px-4">{student.full_name}</td>
                    <td className="py-3 px-4">{student.email}</td>
                    <td className="py-3 px-4">
                      <Button variant="ghost" size="sm">Xem điểm</Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>

        {/* Bài giảng */}
        <TabsContent value="lectures">
          <div className="rounded-md border">
            <div className="p-4">
              <Button>Thêm bài giảng</Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">Tiêu đề</th>
                  <th className="py-3 px-4 text-left font-medium">Ngày tạo</th>
                  <th className="py-3 px-4 text-left font-medium">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {lectures.map((lecture) => (
                  <tr key={lecture.id} className="border-t">
                    <td className="py-3 px-4">{lecture.title}</td>
                    <td className="py-3 px-4">{new Date(lecture.created_at).toLocaleDateString('vi-VN')}</td>
                    <td className="py-3 px-4">
                      <Button variant="ghost" size="sm">Xem</Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>

        {/* Bài tập */}
        <TabsContent value="assignments">
          <div className="rounded-md border">
            <div className="p-4">
              <Button>Thêm bài tập</Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">Tiêu đề</th>
                  <th className="py-3 px-4 text-left font-medium">Hạn nộp</th>
                  <th className="py-3 px-4 text-left font-medium">Trạng thái</th>
                  <th className="py-3 px-4 text-left font-medium">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {assignments.map((assignment) => (
                  <tr key={assignment.id} className="border-t">
                    <td className="py-3 px-4">{assignment.title}</td>
                    <td className="py-3 px-4">{new Date(assignment.due_date).toLocaleDateString('vi-VN')}</td>
                    <td className="py-3 px-4">
                      <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                        new Date(assignment.due_date) > new Date()
                          ? 'bg-green-100 text-green-800'
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {new Date(assignment.due_date) > new Date() ? 'Đang mở' : 'Đã đóng'}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      <Button variant="ghost" size="sm">Xem chi tiết</Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>

        {/* Kiểm tra */}
        <TabsContent value="exams">
          <div className="rounded-md border">
            <div className="p-4">
              <Button>Thêm bài kiểm tra</Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">Tiêu đề</th>
                  <th className="py-3 px-4 text-left font-medium">Thời gian</th>
                  <th className="py-3 px-4 text-left font-medium">Trạng thái</th>
                  <th className="py-3 px-4 text-left font-medium">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {exams.map((exam) => (
                  <tr key={exam.id} className="border-t">
                    <td className="py-3 px-4">{exam.title}</td>
                    <td className="py-3 px-4">{new Date(exam.start_time).toLocaleDateString('vi-VN')}</td>
                    <td className="py-3 px-4">
                      <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                        exam.status === 'upcoming'
                          ? 'bg-yellow-100 text-yellow-800'
                          : exam.status === 'in-progress'
                          ? 'bg-green-100 text-green-800'
                          : 'bg-gray-100 text-gray-800'
                      }`}>
                        {exam.status === 'upcoming'
                          ? 'Sắp diễn ra'
                          : exam.status === 'in-progress'
                          ? 'Đang diễn ra'
                          : 'Đã kết thúc'}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      <Button variant="ghost" size="sm">Xem chi tiết</Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  )
} 