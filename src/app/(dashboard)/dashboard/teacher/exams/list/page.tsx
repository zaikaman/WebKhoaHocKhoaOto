"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { getCurrentUser, getTeacherClasses, getClassExams, deleteExam } from "@/lib/supabase"
import { supabase } from "@/lib/supabase"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import { Plus, RefreshCw, Check, Loader, Clock } from "lucide-react"

type Exam = {
  id: string
  title: string
  subject: string
  className: string
  start_time: string
  end_time: string
  duration: number
  totalStudents: number
  submittedCount: number
  averageScore: number | null
  status: 'upcoming' | 'in-progress' | 'completed'
}

export default function TeacherExamsListPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exams, setExams] = useState<Exam[]>([])
  const [filteredExams, setFilteredExams] = useState<Exam[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [isEditTitleDialogOpen, setIsEditTitleDialogOpen] = useState(false)
  const [currentExamId, setCurrentExamId] = useState<string | null>(null)
  const [editTitle, setEditTitle] = useState('')
  const [editStartTime, setEditStartTime] = useState('')
  const [editEndTime, setEditEndTime] = useState('')
  const [editDuration, setEditDuration] = useState('')

  // Filter options from exams data
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(exams.map(e => e.subject))]
    const classNames = [...new Set(exams.map(e => e.className))]
    
    return [
      {
        key: 'subject',
        label: 'Môn học',
        type: 'select',
        options: subjects.map(subject => ({ value: subject, label: subject }))
      },
      {
        key: 'className',
        label: 'Lớp học',
        type: 'select',
        options: classNames.map(className => ({ value: className, label: className }))
      },
      {
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'upcoming', label: 'Sắp diễn ra' },
          { value: 'in-progress', label: 'Đang diễn ra' },
          { value: 'completed', label: 'Đã hoàn thành' }
        ]
      },
      {
        key: 'examDate',
        label: 'Thời gian thi',
        type: 'daterange'
      },
      {
        key: 'duration',
        label: 'Thời gian làm bài',
        type: 'select',
        options: [
          { value: '0-60', label: '0-60 phút' },
          { value: '60-120', label: '60-120 phút' },
          { value: '120-180', label: '120-180 phút' },
          { value: '180+', label: 'Trên 180 phút' }
        ]
      },
      {
        key: 'submissions',
        label: 'Tình trạng nộp bài',
        type: 'select',
        options: [
          { value: 'has_submissions', label: 'Có bài nộp' },
          { value: 'no_submissions', label: 'Chưa có bài nộp' }
        ]
      },
      {
        key: 'timing',
        label: 'Thời điểm',
        type: 'select',
        options: [
          { value: 'today', label: 'Hôm nay' },
          { value: 'this_week', label: 'Tuần này' },
          { value: 'this_month', label: 'Tháng này' },
          { value: 'past', label: 'Đã qua' }
        ]
      }
    ]
  }, [exams])

  useEffect(() => {
    loadExams()
  }, [])

  // Filter exams based on search query and filters
  useEffect(() => {
    let filtered = exams

    // Text search
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(exam => 
        exam.title.toLowerCase().includes(query) ||
        exam.subject.toLowerCase().includes(query) ||
        exam.className.toLowerCase().includes(query)
      )
    }

    // Apply filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(e => e.subject === value)
          break
        case 'className':
          filtered = filtered.filter(e => e.className === value)
          break
        case 'status':
          filtered = filtered.filter(e => e.status === value)
          break
        case 'examDate':
          if (Array.isArray(value) && (value[0] || value[1])) {
            const [startDate, endDate] = value
            filtered = filtered.filter(e => {
              const examDate = new Date(e.start_time)
              const start = startDate ? new Date(startDate) : null
              const end = endDate ? new Date(endDate) : null
              
              if (start && end) {
                return examDate >= start && examDate <= end
              } else if (start) {
                return examDate >= start
              } else if (end) {
                return examDate <= end
              }
              return true
            })
          }
          break
        case 'duration':
          filtered = filtered.filter(e => {
            const duration = e.duration
            switch (value) {
              case '0-60':
                return duration >= 0 && duration <= 60
              case '60-120':
                return duration > 60 && duration <= 120
              case '120-180':
                return duration > 120 && duration <= 180
              case '180+':
                return duration > 180
              default:
                return true
            }
          })
          break
        case 'submissions':
          filtered = filtered.filter(e => {
            switch (value) {
              case 'has_submissions':
                return e.submittedCount > 0
              case 'no_submissions':
                return e.submittedCount === 0
              default:
                return true
            }
          })
          break
        case 'timing':
          filtered = filtered.filter(e => {
            const now = new Date()
            const examDate = new Date(e.start_time)
            
            switch (value) {
              case 'today':
                return examDate.toDateString() === now.toDateString()
              case 'this_week':
                const weekStart = new Date(now.setDate(now.getDate() - now.getDay()))
                const weekEnd = new Date(weekStart)
                weekEnd.setDate(weekEnd.getDate() + 6)
                return examDate >= weekStart && examDate <= weekEnd
              case 'this_month':
                return examDate.getMonth() === now.getMonth() && examDate.getFullYear() === now.getFullYear()
              case 'past':
                return examDate < now
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredExams(filtered)
  }, [exams, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

  async function loadExams() {
    try {
      setIsLoading(true)
      
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      const classes = await getTeacherClasses(currentUser.profile.id)
      
      const allExams: Exam[] = []
      for (const classItem of classes) {
        const exams = await getClassExams(classItem.id)
        
        const { data: classStudents, error: studentsError } = await supabase
          .from('enrollments')
          .select('student_id')
          .eq('class_id', classItem.id)
          .eq('status', 'enrolled')
        
        const totalStudents = classStudents?.length || 0
        
        for (const e of exams) {
          const now = new Date()
          const startTime = new Date(e.start_time)
          const endTime = new Date(e.end_time)
          
          let status: 'upcoming' | 'in-progress' | 'completed' = 'upcoming'
          if (now >= endTime) {
            status = 'completed'
          } else if (now >= startTime && now < endTime) {
            status = 'in-progress'
          }

          if (status !== e.status) {
            supabase
              .from('exams')
              .update({ status })
              .eq('id', e.id)
              .then(({ error }) => {
                if (error) {
                  console.error('Lỗi khi cập nhật trạng thái:', error)
                }
              })
          }

          const { data: submissions, error: submissionsError } = await supabase
            .from('exam_submissions')
            .select('score')
            .eq('exam_id', e.id)
          
          const submittedCount = submissions?.length || 0
          
          const gradedSubmissions = submissions?.filter(s => s.score !== null) || []
          const averageScore = gradedSubmissions.length > 0 
            ? gradedSubmissions.reduce((sum, s) => sum + (s.score || 0), 0) / gradedSubmissions.length
            : null

          allExams.push({
            id: e.id,
            title: e.title,
            subject: classItem.subject.name,
            className: classItem.name,
            start_time: e.start_time,
            end_time: e.end_time,
            duration: e.duration,
            totalStudents,
            submittedCount,
            averageScore,
            status
          })
        }
      }

      allExams.sort((a, b) => new Date(b.start_time).getTime() - new Date(a.start_time).getTime())
      setExams(allExams)
      setFilteredExams(allExams)
      toast({
        title: "Đã làm mới",
        description: "Dữ liệu bài kiểm tra đã được cập nhật.",
      })
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách bài kiểm tra"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleEdit = (examId: string) => {
    setCurrentExamId(examId)
    setIsEditDialogOpen(true)
  }

  const handleEditChoice = (choice: 'info' | 'question') => {
    setIsEditDialogOpen(false)
    if (choice === 'info') {
      const exam = exams.find(e => e.id === currentExamId)
      if (exam) {
        setEditTitle(exam.title)
        
        const adjustedStartTime = new Date(new Date(exam.start_time).getTime() - 7 * 60 * 60 * 1000);
        const adjustedEndTime = new Date(new Date(exam.end_time).getTime() - 7 * 60 * 60 * 1000);
        setEditStartTime(adjustedStartTime.toLocaleString('sv', { timeZone: 'UTC' }).replace(' ', 'T').slice(0, 16));
        setEditEndTime(adjustedEndTime.toLocaleString('sv', { timeZone: 'UTC' }).replace(' ', 'T').slice(0, 16));
        setEditDuration(exam.duration.toString())
        setIsEditTitleDialogOpen(true)
      }
    } else {
      router.push(`/dashboard/teacher/exams/examQuestion?examId=${currentExamId}`)
    }
  }

  const handleUpdateInfo = async () => {
    if (!currentExamId || !editTitle.trim() || !editStartTime || !editEndTime || !editDuration) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Vui lòng điền đầy đủ thông tin"
      })
      return
    }

    try {
      const startTimeUTC = new Date(editStartTime).toISOString();
      const endTimeUTC = new Date(editEndTime).toISOString();

      const { error } = await supabase
        .from('exams')
        .update({ 
          title: editTitle.trim(),
          start_time: startTimeUTC,
          end_time: endTimeUTC,
          duration: parseInt(editDuration)
        })
        .eq('id', currentExamId)

      if (error) throw error

      toast({
        title: "Thành công",
        description: "Đã cập nhật thông tin bài kiểm tra"
      })
      
      setIsEditTitleDialogOpen(false)
      loadExams()
    } catch (error) {
      console.error('Lỗi khi cập nhật thông tin:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể cập nhật thông tin bài kiểm tra"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleDeleteExam = async (examId: string) => {
    if (!examId) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không tìm thấy ID bài kiểm tra để xóa"
      })
      return
    }

    try {
      setIsLoading(true)
      const result = await deleteExam(examId)
      if (!result) throw new Error('Không thể xóa bài kiểm tra')

      toast({
        variant: "success",
        title: "Thành công",
        description: "Đã xóa bài kiểm tra"
      })
      loadExams()
    } catch (error) {
      console.error('Error deleting exam:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa bài kiểm tra"
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
          <div className="flex items-center gap-2">
            <div className="h-10 w-32 bg-muted rounded animate-pulse" />
            <div className="h-10 w-24 bg-muted rounded animate-pulse" />
            <div className="h-10 w-24 bg-muted rounded animate-pulse" />
          </div>
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
            <div className="h-6 w-32 bg-muted rounded animate-pulse" />
            <div className="h-6 w-24 bg-muted rounded animate-pulse" />
          </div>
        </div>

        {/* Exams List Skeleton */}
        <div className="rounded-xl border shadow">
          <div className="divide-y">
            {[...Array(5)].map((_, index) => (
              <div key={index} className="p-4 hover:bg-muted/50 transition-colors">
                <div className="flex items-center gap-4">
                  <div className="h-10 w-10 bg-muted rounded-full animate-pulse" />
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <div className="h-5 w-48 bg-muted rounded animate-pulse" />
                      <div className="h-5 w-24 bg-muted rounded-full animate-pulse" />
                    </div>
                    <div className="h-4 w-64 bg-muted rounded animate-pulse mt-1" />
                    <div className="grid grid-cols-5 gap-4 mt-2">
                      <div>
                        <div className="h-3 w-24 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-48 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-24 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-24 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-24 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-24 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <div className="h-8 w-24 bg-muted rounded animate-pulse" />
                    <div className="h-8 w-24 bg-muted rounded animate-pulse" />
                    <div className="h-8 w-24 bg-muted rounded animate-pulse" />
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    )
  }
  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài kiểm tra</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài kiểm tra của bạn</p>
          <div className="text-sm text-muted-foreground mt-1">
            Hiển thị {filteredExams.length} / {exams.length} bài kiểm tra
          </div>
        </div>
        <div className="flex flex-col sm:flex-row items-center gap-2">
          <Button variant="outline" onClick={loadExams} disabled={isLoading}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Làm mới
          </Button>
          <Button className="w-full sm:w-auto" onClick={() => router.push('/dashboard/teacher/exams')}>
            <Plus className="w-4 h-4 mr-2" />
            Tạo bài kiểm tra
          </Button>
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài kiểm tra..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="rounded-xl border shadow overflow-x-auto">
        <div className="divide-y">
          {filteredExams.map((exam) => (
            <div key={exam.id} className="p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-4 min-w-[1000px]">
                <div className={`p-2 rounded-full ${
                  exam.status === 'completed'
                    ? 'bg-green-100 text-green-600'
                    : exam.status === 'in-progress'
                    ? 'bg-blue-100 text-blue-600'
                    : 'bg-orange-100 text-orange-600'
                }`}>
                  {exam.status === 'completed' ? (
                    <Check className="w-5 h-5" />
                  ) : exam.status === 'in-progress' ? (
                    <Loader className="w-5 h-5 animate-spin" />
                  ) : (
                    <Clock className="w-5 h-5" />
                  )}
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2">
                    <h4 className="font-medium">{exam.title}</h4>
                    <span className={`px-2 py-0.5 text-xs rounded-full flex-shrink-0 ${
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
                  <p className="text-sm text-muted-foreground mt-1">{exam.subject} - {exam.className}</p>
                  <div className="grid grid-cols-5 gap-4 mt-2 text-sm">
                    <div>
                      <p className="text-muted-foreground">Thời gian thi</p>
                      <p className="font-medium">
                        {new Date(new Date(exam.start_time).getTime() - 7 * 60 * 60 * 1000).toLocaleString('vi-VN', { 
                          year: 'numeric',
                          month: '2-digit',
                          day: '2-digit',
                          hour: '2-digit',
                          minute: '2-digit',
                          hour12: true
                        })} - {new Date(new Date(exam.end_time).getTime() - 7 * 60 * 60 * 1000).toLocaleString('vi-VN', {
                          year: 'numeric',
                          month: '2-digit',
                          day: '2-digit',
                          hour: '2-digit',
                          minute: '2-digit',
                          hour12: true
                        })}
                      </p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Thời gian làm bài</p>
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
                      <p className="font-medium">{exam.averageScore?.toFixed(1) || 'N/A'}</p>
                    </div>
                  </div>
                </div>
                <div className="flex items-center gap-2 flex-shrink-0">
                  <Button variant="ghost" size="sm" onClick={() => handleEdit(exam.id)}>
                    Chỉnh sửa
                  </Button>
                  <Button variant="secondary" size="sm" onClick={() => router.push(`/dashboard/teacher/exams/${exam.id}/submissions`)}>
                    Bài nộp
                  </Button>
                  <Button variant="destructive" size="sm" onClick={() => handleDeleteExam(exam.id)}>
                    Xóa
                  </Button>
                </div>
              </div>
            </div>
          ))}

          {filteredExams.length === 0 && !isLoading && (
            <div className="text-center py-12">
              <p className="text-muted-foreground">
                {exams.length === 0 ? "Chưa có bài kiểm tra nào" : "Không tìm thấy bài kiểm tra phù hợp"}
              </p>
            </div>
          )}
        </div>
      </div>

      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Chọn hành động chỉnh sửa</DialogTitle>
          </DialogHeader>
          <DialogFooter className="flex-col sm:flex-row sm:justify-end gap-2 pt-4">
            <Button className="w-full sm:w-auto" onClick={() => handleEditChoice('info')}>Chỉnh sửa thông tin</Button>
            <Button className="w-full sm:w-auto" onClick={() => handleEditChoice('question')}>Chỉnh sửa câu hỏi</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isEditTitleDialogOpen} onOpenChange={setIsEditTitleDialogOpen}>
        <DialogContent className="w-full max-w-md">
          <DialogHeader>
            <DialogTitle>Chỉnh sửa thông tin bài kiểm tra</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
          <div className="flex items-center gap-4 mt-4">
  <p className="w-32 text-sm">Tiêu đề :</p>
  <Input
    id="edit-title"
    value={editTitle}
    onChange={(e) => setEditTitle(e.target.value)}
    placeholder="Nhập tiêu đề"
    className="flex-1"
  />
</div>

<div className="flex items-center gap-4 mt-4">
  <p className="w-32 text-sm">Thời gian bắt đầu :</p>
  <Input
    id="edit-start-time"
    type="datetime-local"
    value={editStartTime}
    onChange={(e) => setEditStartTime(e.target.value)}
    className="flex-1"
  />
</div>

<div className="flex items-center gap-4 mt-4">
  <p className="w-32 text-sm">Thời gian kết thúc :</p>
  <Input
    id="edit-end-time"
    type="datetime-local"
    value={editEndTime}
    onChange={(e) => setEditEndTime(e.target.value)}
    className="flex-1"
  />
</div>

<div className="flex items-center gap-4 mt-4">
  <p className="w-32 text-sm">Thời gian làm bài (phút) :</p>
  <Input
    id="edit-duration"
    type="number"
    min="1"
    value={editDuration}
    onChange={(e) => setEditDuration(e.target.value)}
    placeholder="Nhập thời gian làm bài"
    className="flex-1"
  />
</div>
          </div>
          <DialogFooter className="flex-col sm:flex-row sm:justify-end gap-2 pt-4">
            <Button variant="outline" className="w-full sm:w-auto" onClick={() => setIsEditTitleDialogOpen(false)}>
              Hủy
            </Button>
            <Button className="w-full sm:w-auto" onClick={handleUpdateInfo} disabled={isLoading}>
              {isLoading ? "Đang cập nhật..." : "Cập nhật"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}