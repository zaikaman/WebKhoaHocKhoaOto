"use client"

import { useEffect, useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Input } from "@/components/ui/input"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { getCurrentUser, getStudentClasses, createEnrollment } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"

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
  const [filteredCourses, setFilteredCourses] = useState<Course[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [classCode, setClassCode] = useState("")
  const [isJoining, setIsJoining] = useState(false)
  const [isDialogOpen, setIsDialogOpen] = useState(false)

  // Tạo filter options từ dữ liệu courses
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(courses.map(c => c.subject.name))]
    const teachers = [...new Set(courses.map(c => c.teacher.full_name))]
    const semesters = [...new Set(courses.map(c => c.semester))]
    const academicYears = [...new Set(courses.map(c => c.academic_year))]
    
    return [
      {
        key: 'subject',
        label: 'Môn học',
        type: 'select',
        options: subjects.map(subject => ({ value: subject, label: subject }))
      },
      {
        key: 'teacher',
        label: 'Giảng viên',
        type: 'select',
        options: teachers.map(teacher => ({ value: teacher, label: teacher }))
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
        key: 'credits',
        label: 'Số tín chỉ',
        type: 'select',
        options: [
          { value: '1-2', label: '1-2 tín chỉ' },
          { value: '3-4', label: '3-4 tín chỉ' },
          { value: '5+', label: '5+ tín chỉ' }
        ]
      },
      {
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'active', label: 'Đang hoạt động' },
          { value: 'completed', label: 'Đã hoàn thành' },
          { value: 'inactive', label: 'Không hoạt động' }
        ]
      }
    ]
  }, [courses])

  useEffect(() => {
    loadCourses()
  }, [])

  // Lọc courses dựa trên search query và filters
  useEffect(() => {
    let filtered = courses

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(course => 
        course.subject.name.toLowerCase().includes(query) ||
        course.name.toLowerCase().includes(query) ||
        course.code.toLowerCase().includes(query) ||
        course.teacher.full_name.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(c => c.subject.name === value)
          break
        case 'teacher':
          filtered = filtered.filter(c => c.teacher.full_name === value)
          break
        case 'semester':
          filtered = filtered.filter(c => c.semester === value)
          break
        case 'academic_year':
          filtered = filtered.filter(c => c.academic_year === value)
          break
        case 'credits':
          filtered = filtered.filter(c => {
            const credits = c.subject.credits
            switch (value) {
              case '1-2':
                return credits >= 1 && credits <= 2
              case '3-4':
                return credits >= 3 && credits <= 4
              case '5+':
                return credits >= 5
              default:
                return true
            }
          })
          break
        case 'status':
          filtered = filtered.filter(c => c.status === value)
          break
      }
    })

    setFilteredCourses(filtered)
  }, [courses, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

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
      setFilteredCourses(coursesData)
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
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Lớp học của tôi</h2>
          <div className="text-sm text-muted-foreground mt-1">
            Hiển thị {filteredCourses.length} / {courses.length} lớp học
          </div>
        </div>
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button>Tham gia lớp học</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Tham gia lớp học</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 py-4">
              <div className="space-y-2">
                <Label htmlFor="class-code">Mã lớp học</Label>
                <Input
                  id="class-code"
                  placeholder="Nhập mã lớp học"
                  value={classCode}
                  onChange={(e) => setClassCode(e.target.value)}
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

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm lớp học..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {filteredCourses.map((course) => (
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
                >
                  Xem chi tiết
                </Button>
              </div>
            </div>
          </div>
        ))}

        {filteredCourses.length === 0 && (
          <div className="col-span-full text-center py-12">
            <div className="text-muted-foreground">
              {courses.length === 0 ? "Bạn chưa tham gia lớp học nào" : "Không tìm thấy lớp học phù hợp"}
            </div>
          </div>
        )}
      </div>
    </div>
  )
} 