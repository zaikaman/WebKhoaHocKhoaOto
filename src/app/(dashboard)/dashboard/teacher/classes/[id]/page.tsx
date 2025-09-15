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
  getClassExams,
  createEnrollment,
  removeStudentFromClass,
} from "@/lib/supabase"
import type { Class, Student, Lecture, Assignment, Exam } from "@/lib/supabase"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"

import { LectureList } from "../../lectures/lecture-list"
import { LectureDetail } from "../../lectures/lecture-details"

export default function ClassDetailPage({ params }: { params: { id: string } }) {
const { id } = params
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [classData, setClassData] = useState<Class | null>(null)
  const [students, setStudents] = useState<Student[]>([])
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [exams, setExams] = useState<Exam[]>([])
  const [isAddStudentDialogOpen, setIsAddStudentDialogOpen] = useState(false)
  const [selectedStudent, setSelectedStudent] = useState<Student | null>(null)
  const [isStudentInfoDialogOpen, setIsStudentInfoDialogOpen] = useState(false)

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

  const handleAddStudent = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setIsLoading(true)

    try {
      const formData = new FormData(event.currentTarget)
      const studentData = {
        student_id: formData.get("student_id") as string,
        full_name: formData.get("full_name") as string,
        class_id: id
      }

      const response = await createEnrollment(studentData)
      
      if (response.success) {
        await loadClassData() // Tải lại danh sách sinh viên
        setIsAddStudentDialogOpen(false)
        toast({
          title: "Thành công",
          description: response.message
        })
      } else {
        toast({
          variant: "destructive", 
          title: "Lỗi",
          description: response.message
        })
      }
    } catch (error: any) {
      console.error('Lỗi khi thêm sinh viên:', error)
      toast({
        variant: "destructive",
        title: "Lỗi", 
        description: error.message || "Không thể thêm sinh viên"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleRemoveStudent = async (studentId: string) => {
    setIsLoading(true)

    try {
      const result = await removeStudentFromClass(studentId, id)
      if (result.success) {
        toast({
          title: "Thành công",
          description: result.message
        })
        await loadClassData()
      } else {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: result.message
        })
      }
    } catch (error: any) {
      console.error('Lỗi khi xóa sinh viên:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể xóa sinh viên"
      })
    } finally {
      setIsLoading(false)
    }
  }

  // const handleUpdateStudent = async (studentId: string, data: {
  //   student_id?: string
  //   full_name?: string
  //   class_code?: string
  //   status?: 'active' | 'inactive'
  // }) => {
  //   setIsLoading(true)

  //   try {
  //     const result = await updateStudentInfo(studentId, data)
  //     if (result.success) {
  //       toast({
  //         title: "Thành công",
  //         description: result.message
  //       })
  //       await loadClassData()
  //     } else {
  //       toast({
  //         variant: "destructive",
  //         title: "Lỗi",
  //         description: result.message
  //       })
  //     }
  //   } catch (error: any) {
  //     console.error('Lỗi khi cập nhật thông tin sinh viên:', error)
  //     toast({
  //       variant: "destructive",
  //       title: "Lỗi",
  //       description: error.message || "Không thể cập nhật thông tin sinh viên"
  //     })
  //   } finally {
  //     setIsLoading(false)
  //   }
  // }

  // Thêm hàm xử lý khi nhấn nút Thông tin
  const handleShowStudentInfo = (student: Student) => {
    setSelectedStudent(student)
    setIsStudentInfoDialogOpen(true)
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
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
          <h1 className="text-2xl font-bold">Môn học : {classData.name}</h1>
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
              <Button onClick={() => setIsAddStudentDialogOpen(true)}>
                Thêm sinh viên
              </Button>
            </div>
            {students.length === 0 ? (
              <div className="flex flex-col items-center justify-center p-8">
                <p className="text-muted-foreground">Chưa có sinh viên nào trong lớp học</p>
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full min-w-[500px] text-xs md:text-sm">
                  <thead className="bg-muted">
                    <tr>
                      <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">MSSV</th>
                      <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Họ và tên</th>
                      <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Thao tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    {students.map((student) => (
                      <tr key={student.id} className="border-t">
                        <td className="py-2 px-2 md:py-3 md:px-4">{student.student_id}</td>
                        <td className="py-2 px-2 md:py-3 md:px-4">{student.full_name}</td>
                        <td className="py-2 px-2 md:py-3 md:px-4">
                          <Button variant="ghost" size="sm" onClick={() => handleShowStudentInfo(student)}>Thông tin</Button>
                          <Button variant="ghost" size="sm" onClick={() => {
                            console.log(student.id)
                            handleRemoveStudent(student.id)
                          }}>Xóa</Button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          {/* Dialog thêm sinh viên */}
          <Dialog open={isAddStudentDialogOpen} onOpenChange={setIsAddStudentDialogOpen}>
            <DialogContent className="w-full max-w-md sm:max-w-lg md:max-w-xl">
              <DialogHeader>
                <DialogTitle>Thêm sinh viên vào lớp</DialogTitle>
                <DialogDescription>
                  Nhập thông tin sinh viên để thêm vào lớp học
                </DialogDescription>
              </DialogHeader>
              <form 
                onSubmit={handleAddStudent} 
                className="space-y-4"
              >
                <div className="form-field">
                  <input
                    id="student_id"
                    name="student_id"
                    className="form-input peer"
                    required
                    placeholder="Mã số sinh viên"
                  />
                  <label className="form-label" htmlFor="student_id">
                    Mã số sinh viên
                  </label>
                </div>
                <div className="form-field">
                  <input
                    id="full_name"
                    name="full_name"
                    className="form-input peer"
                    required
                    placeholder="Họ và tên"
                  />
                  <label className="form-label" htmlFor="full_name">
                    Họ và tên
                  </label>
                </div>
                <DialogFooter className="flex flex-col-reverse gap-2 sm:flex-row sm:justify-end sm:gap-3">
                  <Button 
                    type="button" 
                    variant="outline" 
                    onClick={() => setIsAddStudentDialogOpen(false)}
                    className="w-full sm:w-auto"
                  >
                    Hủy
                  </Button>
                  <Button 
                    type="submit" 
                    disabled={isLoading}
                    className="w-full sm:w-auto"
                  >
                    {isLoading ? "Đang xử lý..." : "Thêm sinh viên"}
                  </Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        </TabsContent>

        {/* Bài giảng */}
        <TabsContent value="lectures">
          <div className="rounded-md border">
            <div className="p-4">
              <LectureList
                classId={id}
                onUploadSuccess={loadClassData}
              />
            </div>
          </div>
        </TabsContent>

        {/* Bài tập */}
        <TabsContent value="assignments">
          <div className="rounded-md border">
            <div className="p-4">
              <Button onClick={() => router.push('/dashboard/teacher/assignments')}>
                Đến trang Bài tập
              </Button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full min-w-[500px] text-xs md:text-sm">
                <thead className="bg-muted">
                  <tr>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Tiêu đề</th>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Hạn nộp</th>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  {assignments.map((assignment) => (
                    <tr key={assignment.id} className="border-t">
                      <td className="py-2 px-2 md:py-3 md:px-4">{assignment.title}</td>
                      <td className="py-2 px-2 md:py-3 md:px-4">{new Date(assignment.due_date).toLocaleDateString('vi-VN')}</td>
                      <td className="py-2 px-2 md:py-3 md:px-4">
                        <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                          new Date(assignment.due_date) > new Date()
                            ? 'bg-green-100 text-green-800'
                            : 'bg-red-100 text-red-800'
                        }`}>
                          {new Date(assignment.due_date) > new Date() ? 'Đang mở' : 'Đã đóng'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </TabsContent>

        {/* Kiểm tra */}
        <TabsContent value="exams">
          <div className="rounded-md border">
            <div className="p-4">
              <Button onClick={() => router.push('/dashboard/teacher/exams/list')}>
                Đến trang Kiểm tra
              </Button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full min-w-[500px] text-xs md:text-sm">
                <thead className="bg-muted">
                  <tr>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Tiêu đề</th>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Thời gian</th>
                    <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  {exams.map((exam) => (
                    <tr key={exam.id} className="border-t">
                      <td className="py-2 px-2 md:py-3 md:px-4">{exam.title}</td>
                      <td className="py-2 px-2 md:py-3 md:px-4">{new Date(exam.start_time).toLocaleDateString('vi-VN')}</td>
                      <td className="py-2 px-2 md:py-3 md:px-4">
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
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </TabsContent>
      </Tabs>

      {/* Dialog thông tin sinh viên */}
      <Dialog open={isStudentInfoDialogOpen} onOpenChange={setIsStudentInfoDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Thông tin sinh viên</DialogTitle>
            <DialogDescription>
              Chi tiết thông tin sinh viên trong lớp học
            </DialogDescription>
          </DialogHeader>
          {selectedStudent && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Mã số sinh viên</h3>
                  <p className="mt-1 text-base">{selectedStudent.student_id}</p>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Họ và tên</h3>
                  <p className="mt-1 text-base">{selectedStudent.full_name}</p>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Email</h3>
                  <p className="mt-1 text-base">{selectedStudent.email || 'Chưa cập nhật'}</p>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Mã lớp</h3>
                  <p className="mt-1 text-base">{selectedStudent.class_code || 'Chưa cập nhật'}</p>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Trạng thái</h3>
                  <p className="mt-1 text-base">
                    <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                      selectedStudent.status === 'active' 
                        ? 'bg-green-100 text-green-800' 
                        : 'bg-red-100 text-red-800'
                    }`}>
                      {selectedStudent.status === 'active' ? 'Đang hoạt động' : 'Không hoạt động'}
                    </span>
                  </p>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-gray-500">Ngày tạo</h3>
                  <p className="mt-1 text-base">
                    {new Date(selectedStudent.created_at).toLocaleDateString('vi-VN')}
                  </p>
                </div>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button onClick={() => setIsStudentInfoDialogOpen(false)}>
              Đóng
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
