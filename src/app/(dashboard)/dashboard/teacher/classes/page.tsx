"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, createClass, getSubjects } from "@/lib/supabase"
import type { Class, Subject } from "@/lib/supabase"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

export default function TeacherClassesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [classes, setClasses] = useState<Class[]>([])
  const [subjects, setSubjects] = useState<Subject[]>([])
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [selectedClass, setSelectedClass] = useState<Class | null>(null)
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false)

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      if (currentUser.profile.role !== 'teacher') {
        router.push('/dashboard')
        return
      }

      const [classesData, subjectsData] = await Promise.all([
        getTeacherClasses(currentUser.profile.id),
        getSubjects()
      ])
      
      setClasses(classesData)
      setSubjects(subjectsData)
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu. Vui lòng thử lại sau."
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleCreateClass = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setIsLoading(true)

    try {
      const formData = new FormData(event.currentTarget)
      const currentUser = await getCurrentUser()

      if (!currentUser) {
        router.push('/login')
        return
      }

      const classData = {
        subject_id: formData.get("subject_id") as string,
        teacher_id: currentUser.profile.id,
        code: formData.get("code") as string,
        name: formData.get("name") as string,
        semester: formData.get("semester") as string,
        academic_year: formData.get("academic_year") as string,
        status: "active" as const
      }

      try {
        await createClass(classData)
        await loadData()
        setIsDialogOpen(false)
        toast({
          title: "Thành công",
          description: "Đã tạo lớp học mới"
        })
      } catch (error: any) {
        console.error('Chi tiết lỗi:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        toast({
          variant: "destructive",
          title: "Lỗi khi tạo lớp học",
          description: error.message || "Không thể tạo lớp học mới. Vui lòng thử lại sau."
        })
      }
    } catch (error: any) {
      console.error('Lỗi khi tạo lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể tạo lớp học mới"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleDeleteClass = async () => {
    if (!selectedClass) return

    try {
      setIsLoading(true)
      // Thêm hàm xóa lớp học ở đây
      await loadData()
      setIsDeleteDialogOpen(false)
      toast({
        title: "Thành công",
        description: "Đã xóa lớp học"
      })
    } catch (error) {
      console.error('Lỗi khi xóa lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa lớp học"
      })
    } finally {
      setIsLoading(false)
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
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Lớp học của tôi</h2>
          <p className="text-muted-foreground">
            Quản lý các lớp học và hoạt động giảng dạy
          </p>
        </div>
        <Button>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="w-4 h-4 mr-2"
          >
            <path d="M5 12h14" />
            <path d="M12 5v14" />
          </svg>
          Tạo lớp mới
        </Button>
      </div>

      {/* Danh sách lớp học */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {classes.map((classItem) => (
          <div
            key={classItem.id}
            className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-md"
          >
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div>
                  <h3 className="font-semibold text-lg">{classItem.name}</h3>
                  <p className="text-sm text-muted-foreground mt-1">
                    Mã lớp: {classItem.code}
                  </p>
                </div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="icon">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        className="w-4 h-4"
                      >
                        <circle cx="12" cy="12" r="1" />
                        <circle cx="19" cy="12" r="1" />
                        <circle cx="5" cy="12" r="1" />
                      </svg>
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => router.push(`/dashboard/teacher/classes/${classItem.id}`)}>
                      Xem chi tiết
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => {
                      setSelectedClass(classItem)
                      setIsDialogOpen(true)
                    }}>
                      Chỉnh sửa
                    </DropdownMenuItem>
                    <DropdownMenuItem
                      className="text-red-600"
                      onClick={() => {
                        setSelectedClass(classItem)
                        setIsDeleteDialogOpen(true)
                      }}
                    >
                      Xóa
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>

              <div className="mt-4 space-y-2">
                <div className="flex items-center text-sm text-muted-foreground">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    className="w-4 h-4 mr-2"
                  >
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                    <circle cx="9" cy="7" r="4" />
                    <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                  </svg>
                  {classItem.enrollments?.count || 0} sinh viên
                </div>
                <div className="flex items-center text-sm text-muted-foreground">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    className="w-4 h-4 mr-2"
                  >
                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20" />
                  </svg>
                  {classItem.lectures?.count || 0} bài giảng
                </div>
                <div className="flex items-center text-sm text-muted-foreground">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    className="w-4 h-4 mr-2"
                  >
                    <path d="M9 11l3 3L22 4" />
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                  </svg>
                  {classItem.assignments?.count || 0} bài tập
                </div>
              </div>

              <div className="mt-6 flex items-center justify-between">
                <div className="flex items-center">
                  <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                    classItem.status === 'active'
                      ? 'bg-green-100 text-green-800'
                      : 'bg-gray-100 text-gray-800'
                  }`}>
                    {classItem.status === 'active' ? 'Đang diễn ra' : 'Đã kết thúc'}
                  </span>
                  <span className="mx-2 text-gray-300">•</span>
                  <span className="text-sm text-muted-foreground">
                    {classItem.semester} - {classItem.academic_year}
                  </span>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  className="group-hover:bg-primary group-hover:text-primary-foreground"
                  onClick={() => router.push(`/dashboard/teacher/classes/${classItem.id}`)}
                >
                  Chi tiết
                </Button>
              </div>
            </div>
          </div>
        ))}

        {/* Thêm lớp mới */}
        <button
          className="rounded-lg border border-dashed hover:border-primary hover:bg-primary/5 transition-colors h-full min-h-[250px] flex flex-col items-center justify-center p-6"
          onClick={() => {
            setSelectedClass(null)
            setIsDialogOpen(true)
          }}
        >
          <div className="rounded-full bg-primary/10 p-3 mb-4">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="w-6 h-6 text-primary"
            >
              <path d="M5 12h14" />
              <path d="M12 5v14" />
            </svg>
          </div>
          <p className="font-medium mb-1">Tạo lớp học mới</p>
          <p className="text-sm text-muted-foreground text-center">
            Thêm lớp học mới và bắt đầu quản lý hoạt động giảng dạy
          </p>
        </button>
      </div>

      {/* Dialog tạo/chỉnh sửa lớp học */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {selectedClass ? "Chỉnh sửa lớp học" : "Tạo lớp học mới"}
            </DialogTitle>
            <DialogDescription>
              {selectedClass
                ? "Cập nhật thông tin lớp học"
                : "Nhập thông tin để tạo lớp học mới"}
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleCreateClass} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="subject_id">
                Môn học
              </label>
              <select
                id="subject_id"
                name="subject_id"
                defaultValue={selectedClass?.subject_id}
                className="w-full px-3 py-2 border rounded-md"
                required
              >
                <option value="">Chọn môn học</option>
                {subjects.map((subject) => (
                  <option key={subject.id} value={subject.id}>
                    {subject.code} - {subject.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="code">
                Mã lớp
              </label>
              <input
                id="code"
                name="code"
                defaultValue={selectedClass?.code}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="name">
                Tên lớp
              </label>
              <input
                id="name"
                name="name"
                defaultValue={selectedClass?.name}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="semester">
                Học kỳ
              </label>
              <input
                id="semester"
                name="semester"
                defaultValue={selectedClass?.semester}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="academic_year">
                Năm học
              </label>
              <input
                id="academic_year"
                name="academic_year"
                defaultValue={selectedClass?.academic_year}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                Hủy
              </Button>
              <Button type="submit" disabled={isLoading}>
                {selectedClass ? "Cập nhật" : "Tạo mới"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Dialog xác nhận xóa */}
      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận xóa lớp học</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn xóa lớp học này? Hành động này không thể hoàn tác.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>
              Hủy
            </Button>
            <Button variant="destructive" onClick={handleDeleteClass} disabled={isLoading}>
              Xóa
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 