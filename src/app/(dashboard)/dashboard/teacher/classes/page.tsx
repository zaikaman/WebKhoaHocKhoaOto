"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, createClass, getSubjects } from "@/lib/supabase"
import type { Class, Subject } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"
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
  const [filteredClasses, setFilteredClasses] = useState<Class[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [subjects, setSubjects] = useState<Subject[]>([])
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [selectedClass, setSelectedClass] = useState<Class | null>(null)
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false)

  // Tạo filter options từ dữ liệu classes
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjectNames = [...new Set(classes.map(c => c.subject?.name).filter(Boolean))] as string[]
    const semesters = [...new Set(classes.map(c => c.semester).filter(Boolean))] as string[]
    const academicYears = [...new Set(classes.map(c => c.academic_year).filter(Boolean))] as string[]
    
    return [
      {
        key: 'subject',
        label: 'Môn học',
        type: 'select',
        options: subjectNames.map(subject => ({ value: subject, label: subject }))
      },
      {
        key: 'semester',
        label: 'Học kỳ',
        type: 'select',
        options: semesters.map(semester => ({ value: semester, label: semester }))
      },
      {
        key: 'academic_year',
        label: 'Năm học',
        type: 'select',
        options: academicYears.map(year => ({ value: year, label: year }))
      },
      {
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'active', label: 'Đang diễn ra' },
          { value: 'inactive', label: 'Đã kết thúc' },
          { value: 'draft', label: 'Nháp' }
        ]
      },
      {
        key: 'students_count',
        label: 'Số lượng sinh viên',
        type: 'select',
        options: [
          { value: '0-10', label: '0-10 sinh viên' },
          { value: '10-30', label: '10-30 sinh viên' },
          { value: '30-50', label: '30-50 sinh viên' },
          { value: '50+', label: 'Trên 50 sinh viên' }
        ]
      },
      {
        key: 'activities',
        label: 'Hoạt động',
        type: 'select',
        options: [
          { value: 'has_assignments', label: 'Có bài tập' },
          { value: 'has_exams', label: 'Có bài kiểm tra' },
          { value: 'no_activities', label: 'Chưa có hoạt động' }
        ]
      }
    ]
  }, [classes])

  useEffect(() => {
    loadData()
  }, [])

  // Lọc classes dựa trên search query và filters
  useEffect(() => {
    let filtered = classes

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(classItem => 
        classItem.name.toLowerCase().includes(query) ||
        classItem.code.toLowerCase().includes(query) ||
        classItem.subject?.name.toLowerCase().includes(query) ||
        classItem.subject?.code.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(c => c.subject?.name === value)
          break
        case 'semester':
          filtered = filtered.filter(c => c.semester === value)
          break
        case 'academic_year':
          filtered = filtered.filter(c => c.academic_year === value)
          break
        case 'status':
          filtered = filtered.filter(c => c.status === value)
          break
        case 'students_count':
          filtered = filtered.filter(c => {
            const count = (c.enrollments as any)?.count ?? 0
            switch (value) {
              case '0-10':
                return count >= 0 && count <= 10
              case '10-30':
                return count > 10 && count <= 30
              case '30-50':
                return count > 30 && count <= 50
              case '50+':
                return count > 50
              default:
                return true
            }
          })
          break
        case 'activities':
          filtered = filtered.filter(c => {
            const hasAssignments = (c.assignments as any)?.count > 0
            const hasExams = (c.exams as any)?.count > 0
            
            switch (value) {
              case 'has_assignments':
                return hasAssignments
              case 'has_exams':
                return hasExams
              case 'no_activities':
                return !hasAssignments && !hasExams
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredClasses(filtered)
  }, [classes, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

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
      setFilteredClasses(classesData)
      console.log("Dữ liệu lớp học:", classesData)
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
      <div className="space-y-8">
        <div className="flex items-center justify-between">
          <div>
            <div className="h-8 w-48 bg-muted rounded animate-pulse mb-2" />
            <div className="h-4 w-64 bg-muted rounded animate-pulse mb-1" />
            <div className="h-4 w-40 bg-muted rounded animate-pulse" />
          </div>
          <div className="h-10 w-32 bg-muted rounded animate-pulse" />
        </div>

        {/* Search and Filter Skeleton */}
        <div className="space-y-4">
          <div className="flex gap-2">
            <div className="relative flex-1">
              <div className="h-10 w-full bg-muted rounded animate-pulse" />
            </div>
            <div className="h-10 w-24 bg-muted rounded animate-pulse" />
          </div>
          <div className="flex flex-wrap gap-2">
            <div className="h-6 w-24 bg-muted rounded animate-pulse" />
            <div className="h-6 w-32 bg-muted rounded animate-pulse" />
            <div className="h-6 w-28 bg-muted rounded animate-pulse" />
          </div>
        </div>

        {/* Class Cards Skeleton */}
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {[...Array(6)].map((_, index) => (
            <div key={index} className="rounded-lg border bg-card text-card-foreground shadow-sm">
              <div className="p-6">
                <div className="flex items-start justify-between">
                  <div className="space-y-2">
                    <div className="h-6 w-48 bg-muted rounded animate-pulse" />
                    <div className="h-4 w-64 bg-muted rounded animate-pulse" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="h-8 w-8 bg-muted rounded animate-pulse" />
                </div>

                <div className="mt-4 space-y-2">
                  <div className="flex items-center">
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse mr-2" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="flex items-center">
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse mr-2" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="flex items-center">
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse mr-2" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                </div>

                <div className="mt-6 flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="h-6 w-24 bg-muted rounded-full animate-pulse" />
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse mx-2" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="h-8 w-20 bg-muted rounded animate-pulse" />
                </div>
              </div>
            </div>
          ))}

          {/* Add New Class Button Skeleton */}
          <div className="rounded-lg border border-dashed h-full min-h-[250px] flex flex-col items-center justify-center p-6">
            <div className="rounded-full bg-muted p-3 mb-4">
              <div className="h-6 w-6 bg-muted rounded animate-pulse" />
            </div>
            <div className="h-5 w-32 bg-muted rounded animate-pulse mb-1" />
            <div className="h-4 w-48 bg-muted rounded animate-pulse" />
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">
            Lớp học của tôi
          </h2>
          <p className="text-sm sm:text-base text-muted-foreground">
            Quản lý các lớp học và hoạt động giảng dạy
          </p>
          <div className="text-xs sm:text-sm text-muted-foreground mt-1">
            Hiển thị {filteredClasses.length} / {classes.length} lớp học
          </div>
        </div>
        <Button
          onClick={() => {
            setSelectedClass(null)
            setIsDialogOpen(true)
          }}
          className="w-full sm:w-auto"
        >
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

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm lớp học..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      {/* Danh sách lớp học */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {filteredClasses.map((classItem) => (
          <div
            key={classItem.id}
            className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-md"
          >
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div>
                  <h3 className="font-semibold text-lg">{classItem.name}</h3>
                  <p className="text-sm text-muted-foreground mt-1">
                    {classItem.subject?.name} ({classItem.subject?.code})
                  </p>
                  <p className="text-sm text-muted-foreground">
                    Mã lớp: {classItem.code}
                  </p>
                </div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="sm">
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
                        <circle cx="12" cy="5" r="1" />
                        <circle cx="12" cy="19" r="1" />
                      </svg>
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent>
                    <DropdownMenuItem
                      onClick={() => {
                        setSelectedClass(classItem)
                        setIsDialogOpen(true)
                      }}
                    >
                      Chỉnh sửa
                    </DropdownMenuItem>
                    <DropdownMenuItem
                      onClick={() => {
                        setSelectedClass(classItem)
                        setIsDeleteDialogOpen(true)
                      }}
                      className="text-red-600"
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
                  {(classItem.enrollments as any)?.count ?? 0} sinh viên
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
                  {(classItem.assignments as any)?.count ?? 0} bài tập
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
                  {(classItem.exams as any)?.count ?? 0} bài kiểm tra
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
                  className="text-xs sm:text-sm flex-shrink-0 bg-black text-white hover:bg-black hover:text-white hover:opacity-100"
                  onClick={() => router.push(`/dashboard/teacher/classes/${classItem.id}`)}
                >
                  Chi tiết
                </Button>
              </div>
            </div>
          </div>
        ))}

        {/* Thêm lớp mới */}
        {filteredClasses.length === classes.length && (
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
        )}

        {/* Không tìm thấy kết quả */}
        {filteredClasses.length === 0 && (
          <div className="col-span-full text-center py-12">
            <div className="text-muted-foreground">
              {classes.length === 0 ? "Chưa có lớp học nào" : "Không tìm thấy lớp học phù hợp"}
            </div>
          </div>
        )}
      </div>

      {/* Dialog tạo/chỉnh sửa lớp học */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-full sm:max-w-lg p-4 sm:p-8">
          <DialogHeader>
            <DialogTitle className="text-base sm:text-lg">
              {selectedClass ? "Chỉnh sửa lớp học" : "Tạo lớp học mới"}
            </DialogTitle>
            <DialogDescription className="text-xs sm:text-sm">
              {selectedClass
                ? "Cập nhật thông tin lớp học"
                : "Nhập thông tin để tạo lớp học mới"}
            </DialogDescription>
          </DialogHeader>
          <form
            onSubmit={handleCreateClass}
            className="space-y-4"
          >
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="subject_id">
                Môn học
              </label>
              <select
                id="subject_id"
                name="subject_id"
                defaultValue={selectedClass?.subject_id}
                className="w-full px-3 py-2 border rounded-md text-sm sm:text-base"
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
                className="w-full px-3 py-2 border rounded-md text-sm sm:text-base"
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
                className="w-full px-3 py-2 border rounded-md text-sm sm:text-base"
                required
              />
            </div>
            <div className="flex flex-col sm:flex-row sm:gap-4">
              <div className="space-y-2 flex-1">
                <label className="text-sm font-medium" htmlFor="semester">
                  Học kỳ
                </label>
                <input
                  id="semester"
                  name="semester"
                  defaultValue={selectedClass?.semester}
                  className="w-full px-3 py-2 border rounded-md text-sm sm:text-base"
                  required
                />
              </div>
              <div className="space-y-2 flex-1">
                <label className="text-sm font-medium" htmlFor="academic_year">
                  Năm học
                </label>
                <input
                  id="academic_year"
                  name="academic_year"
                  defaultValue={selectedClass?.academic_year}
                  className="w-full px-3 py-2 border rounded-md text-sm sm:text-base"
                  required
                />
              </div>
            </div>
            <DialogFooter className="flex flex-col sm:flex-row sm:justify-end gap-2 pt-2">
              <Button
                type="button"
                variant="outline"
                onClick={() => setIsDialogOpen(false)}
                className="w-full sm:w-auto"
              >
                Hủy
              </Button>
              <Button
                type="submit"
                disabled={isLoading}
                className="w-full sm:w-auto"
              >
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
