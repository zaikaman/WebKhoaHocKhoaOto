"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"
import { getCurrentUser, getTeacherClasses, getClassExams, deleteExam } from "@/lib/supabase"
import { supabase } from "@/lib/supabase"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import { Plus, RefreshCw, Check, Loader, Clock, MoreHorizontal, Users, FileIcon } from "lucide-react"
import { AssignmentListSkeleton } from "../../components/AssignmentListSkeleton";

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

type GroupedExam = {
  title: string;
  mostRecentStartTime: string;
  classes: Exam[];
  totalSubmissions: number;
  totalStudents: number;
  duration: number;
}

export default function TeacherExamsListPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exams, setExams] = useState<Exam[]>([])
  const [groupedExams, setGroupedExams] = useState<GroupedExam[]>([])
  const [filteredExams, setFilteredExams] = useState<GroupedExam[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedGroup, setSelectedGroup] = useState<GroupedExam | null>(null)
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [isEditTitleDialogOpen, setIsEditTitleDialogOpen] = useState(false)
  const [currentExamId, setCurrentExamId] = useState<string | null>(null)
  const [editTitle, setEditTitle] = useState('')
  const [editStartTime, setEditStartTime] = useState('')
  const [editEndTime, setEditEndTime] = useState('')
  const [editDuration, setEditDuration] = useState('')

  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(exams.map(e => e.subject))]
    const classNames = [...new Set(exams.map(e => e.className))]
    
    return [
      { key: 'subject', label: 'Môn học', type: 'select', options: subjects.map(s => ({ value: s, label: s })) },
      { key: 'className', label: 'Lớp học', type: 'select', options: classNames.map(c => ({ value: c, label: c })) },
      { key: 'status', label: 'Trạng thái', type: 'select', options: [{ value: 'upcoming', label: 'Sắp diễn ra' }, { value: 'in-progress', label: 'Đang diễn ra' }, { value: 'completed', label: 'Đã hoàn thành' }] },
    ]
  }, [exams])

  useEffect(() => {
    loadExams()
  }, [])

  useEffect(() => {
    let filtered = groupedExams;

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(group =>
        group.title.toLowerCase().includes(query) ||
        group.classes.some(c => c.className.toLowerCase().includes(query) || c.subject.toLowerCase().includes(query))
      );
    }

    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "") return;

      filtered = filtered.map(group => {
        const filteredClasses = group.classes.filter(exam => {
          switch (key) {
            case 'subject':
              return exam.subject === value;
            case 'className':
              return exam.className === value;
            case 'status':
              return exam.status === value;
            default:
              return true;
          }
        });
        return { ...group, classes: filteredClasses };
      }).filter(group => group.classes.length > 0);
    });

    setFilteredExams(filtered);
  }, [groupedExams, searchQuery, filters]);

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
        const { data: classStudents } = await supabase.from('enrollments').select('student_id').eq('class_id', classItem.id).eq('status', 'enrolled')
        const totalStudents = classStudents?.length || 0
        
        for (const e of exams) {
          const now = new Date(), startTime = new Date(e.start_time), endTime = new Date(e.end_time)
          let status: 'upcoming' | 'in-progress' | 'completed' = now >= endTime ? 'completed' : (now >= startTime && now < endTime ? 'in-progress' : 'upcoming')
          if (status !== e.status) {
            supabase.from('exams').update({ status }).eq('id', e.id).then(({ error }) => error && console.error('Lỗi khi cập nhật trạng thái:', error))
          }

          const { data: submissions } = await supabase.from('exam_submissions').select('score').eq('exam_id', e.id)
          const submittedCount = submissions?.length || 0
          const gradedSubmissions = submissions?.filter(s => s.score !== null) || []
          const averageScore = gradedSubmissions.length > 0 ? gradedSubmissions.reduce((sum, s) => sum + (s.score || 0), 0) / gradedSubmissions.length : null

          allExams.push({ id: e.id, title: e.title, subject: classItem.subject.name, className: classItem.name, start_time: e.start_time, end_time: e.end_time, duration: e.duration, totalStudents, submittedCount, averageScore, status })
        }
      }

      setExams(allExams)

      const grouped = allExams.reduce((acc, exam) => {
        const { title } = exam;
        if (!acc[title]) {
          acc[title] = { title, mostRecentStartTime: '1970-01-01T00:00:00Z', classes: [], totalSubmissions: 0, totalStudents: 0, duration: exam.duration };
        }
        acc[title].classes.push(exam);
        acc[title].totalSubmissions += exam.submittedCount;
        acc[title].totalStudents += exam.totalStudents;
        if (new Date(exam.start_time) > new Date(acc[title].mostRecentStartTime)) {
          acc[title].mostRecentStartTime = exam.start_time;
        }
        acc[title].classes.sort((a, b) => new Date(b.start_time).getTime() - new Date(a.start_time).getTime());
        return acc;
      }, {} as Record<string, GroupedExam>);

      const groupedArray = Object.values(grouped).sort((a, b) => new Date(b.mostRecentStartTime).getTime() - new Date(a.mostRecentStartTime).getTime());
      setGroupedExams(groupedArray)
      setFilteredExams(groupedArray)

      toast({ title: "Đã làm mới", description: "Dữ liệu bài kiểm tra đã được cập nhật." })
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải danh sách bài kiểm tra" })
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
      toast({ variant: "destructive", title: "Lỗi", description: "Vui lòng điền đầy đủ thông tin" })
      return
    }
    try {
      const { error } = await supabase.from('exams').update({ title: editTitle.trim(), start_time: new Date(editStartTime).toISOString(), end_time: new Date(editEndTime).toISOString(), duration: parseInt(editDuration) }).eq('id', currentExamId)
      if (error) throw error
      toast({ title: "Thành công", description: "Đã cập nhật thông tin bài kiểm tra" })
      setIsEditTitleDialogOpen(false)
      loadExams()
    } catch (error) {
      console.error('Lỗi khi cập nhật thông tin:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể cập nhật thông tin bài kiểm tra" })
    } finally {
      setIsLoading(false)
    }
  }

  const handleDeleteExam = async (examId: string) => {
    if (!examId) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không tìm thấy ID bài kiểm tra để xóa" })
      return
    }
    try {
      setIsLoading(true)
      const result = await deleteExam(examId)
      if (!result) throw new Error('Không thể xóa bài kiểm tra')
      toast({ title: "Thành công", description: "Đã xóa bài kiểm tra" })
      loadExams()
    } catch (error) {
      console.error('Error deleting exam:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể xóa bài kiểm tra" })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return <div className="p-8"><AssignmentListSkeleton /></div>
  }

  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài kiểm tra</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài kiểm tra của bạn</p>
          <div className="text-sm text-muted-foreground mt-1">Hiển thị {filteredExams.length} / {groupedExams.length} nhóm bài kiểm tra</div>
        </div>
        <div className="flex flex-col sm:flex-row items-center gap-2">
          <Button variant="outline" onClick={loadExams} disabled={isLoading}><RefreshCw className="w-4 h-4 mr-2" />Làm mới</Button>
          <Button className="w-full sm:w-auto" onClick={() => router.push('/dashboard/teacher/exams')}><Plus className="w-4 h-4 mr-2" />Tạo bài kiểm tra</Button>
        </div>
      </div>

      <SearchFilter searchPlaceholder="Tìm kiếm bài kiểm tra..." filterOptions={filterOptions} onSearch={handleSearch} />

      <div className="rounded-xl border shadow overflow-x-auto">
        <div className="divide-y">
          {filteredExams.map((group) => (
            <div key={group.title} className="p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-4 min-w-[800px]">
                <div className="p-2 rounded-full bg-blue-100 text-blue-600"><FileIcon className="w-5 h-5" /></div>
                <div className="flex-1">
                  <h4 className="font-medium">{group.title}</h4>
                  <p className="text-sm text-muted-foreground mt-1">Áp dụng cho {group.classes.length} lớp học</p>
                  <div className="grid grid-cols-4 gap-4 mt-2 text-sm">
                    <div><p className="text-muted-foreground">Bắt đầu gần nhất</p><p className="font-medium">{new Date(group.mostRecentStartTime).toLocaleString('vi-VN')}</p></div>
                    <div><p className="text-muted-foreground">Thời gian làm bài</p><p className="font-medium">{group.duration} phút</p></div>
                    <div><p className="text-muted-foreground">Tổng số SV</p><p className="font-medium">{group.totalStudents}</p></div>
                    <div><p className="text-muted-foreground">Tổng bài nộp</p><p className="font-medium">{group.totalSubmissions}</p></div>
                  </div>
                </div>
                <div className="flex items-center gap-2 flex-shrink-0">
                  <Button variant="ghost" size="sm" onClick={() => { setSelectedGroup(group); setIsDetailDialogOpen(true); }}>Chi tiết</Button>
                </div>
              </div>
            </div>
          ))}
          {filteredExams.length === 0 && !isLoading && (
            <div className="text-center py-12"><p className="text-muted-foreground">{groupedExams.length === 0 ? "Chưa có bài kiểm tra nào" : "Không tìm thấy bài kiểm tra phù hợp"}</p></div>
          )}
        </div>
      </div>

      <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="sm:max-w-4xl w-full">
          <DialogHeader>
            <DialogTitle>Chi tiết nhóm bài kiểm tra: {selectedGroup?.title}</DialogTitle>
            <DialogDescription>Danh sách các bài kiểm tra theo từng lớp.</DialogDescription>
          </DialogHeader>
          {selectedGroup && (
            <div className="space-y-4 max-h-[70vh] overflow-y-auto">
              {selectedGroup.classes.map(exam => (
                <div key={exam.id} className="p-4 border rounded-lg hover:bg-muted/50">
                  <div className="flex justify-between items-start">
                    <div>
                      <h4 className="font-medium text-base">{exam.className} - {exam.subject}</h4>
                      <span className={`px-2 py-0.5 text-xs rounded-full flex-shrink-0 ${exam.status === 'completed' ? 'bg-green-100 text-green-700' : exam.status === 'in-progress' ? 'bg-blue-100 text-blue-700' : 'bg-orange-100 text-orange-700'}`}>
                        {exam.status === 'completed' ? 'Đã hoàn thành' : exam.status === 'in-progress' ? 'Đang diễn ra' : 'Sắp diễn ra'}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 flex-shrink-0">
                      <Button variant="outline" size="sm" onClick={() => handleEdit(exam.id)}>Chỉnh sửa</Button>
                      <Button variant="secondary" size="sm" onClick={() => router.push(`/dashboard/teacher/exams/${exam.id}/submissions`)}>Bài nộp</Button>
                      <Button variant="destructive" size="sm" onClick={() => handleDeleteExam(exam.id)}>Xóa</Button>
                    </div>
                  </div>
                  <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 mt-3 text-sm">
                    <div><p className="text-muted-foreground">Thời gian</p><p className="font-medium">{new Date(exam.start_time).toLocaleString('vi-VN')} - {new Date(exam.end_time).toLocaleString('vi-VN')}</p></div>
                    <div><p className="text-muted-foreground">Thời gian làm bài</p><p className="font-medium">{exam.duration} phút</p></div>
                    <div><p className="text-muted-foreground">Đã nộp / Tổng số</p><p className="font-medium">{exam.submittedCount} / {exam.totalStudents}</p></div>
                    <div><p className="text-muted-foreground">Điểm TB</p><p className="font-medium">{exam.averageScore?.toFixed(1) || 'N/A'}</p></div>
                  </div>
                </div>
              ))}
            </div>
          )}
          <DialogFooter><Button variant="outline" onClick={() => setIsDetailDialogOpen(false)}>Đóng</Button></DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader><DialogTitle>Chọn hành động chỉnh sửa</DialogTitle></DialogHeader>
          <DialogFooter className="flex-col sm:flex-row sm:justify-end gap-2 pt-4">
            <Button className="w-full sm:w-auto" onClick={() => handleEditChoice('info')}>Chỉnh sửa thông tin</Button>
            <Button className="w-full sm:w-auto" onClick={() => handleEditChoice('question')}>Chỉnh sửa câu hỏi</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isEditTitleDialogOpen} onOpenChange={setIsEditTitleDialogOpen}>
        <DialogContent className="w-full max-w-md">
          <DialogHeader><DialogTitle>Chỉnh sửa thông tin bài kiểm tra</DialogTitle></DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-4">
              <div>
                <Label htmlFor="edit-title">Tiêu đề</Label>
                <Input id="edit-title" value={editTitle} onChange={(e) => setEditTitle(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="edit-start-time">Thời gian bắt đầu</Label>
                <Input id="edit-start-time" type="datetime-local" value={editStartTime} onChange={(e) => setEditStartTime(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="edit-end-time">Thời gian kết thúc</Label>
                <Input id="edit-end-time" type="datetime-local" value={editEndTime} onChange={(e) => setEditEndTime(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="edit-duration">Thời gian làm bài (phút)</Label>
                <Input id="edit-duration" type="number" value={editDuration} onChange={(e) => setEditDuration(e.target.value)} />
              </div>
            </div>
          </div>
          <DialogFooter className="flex-col sm:flex-row sm:justify-end gap-2 pt-4">
            <Button variant="outline" className="w-full sm:w-auto" onClick={() => setIsEditTitleDialogOpen(false)}>Hủy</Button>
            <Button className="w-full sm:w-auto" onClick={handleUpdateInfo} disabled={isLoading}>{isLoading ? "Đang cập nhật..." : "Cập nhật"}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}