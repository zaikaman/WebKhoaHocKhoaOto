"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getTeacherClasses, getClassExams, deleteExam, createExam } from "@/lib/supabase"
import { supabase, Exam as DBExam } from "@/lib/supabase"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Checkbox } from "@/components/ui/checkbox"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import { Plus, RefreshCw, Check, Loader, Clock, MoreHorizontal, Users, FileIcon, Upload } from "lucide-react"
import * as XLSX from 'xlsx'
import { sanitizeDescription } from '@/lib/utils'
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

type CreateExamData = Omit<DBExam, 'id' | 'created_at' | 'updated_at'> & {
  type: 'quiz' | 'midterm' | 'final',
  max_attempts?: number
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
  const [creationMode, setCreationMode] = useState<'multiple_choice' | 'essay'>('multiple_choice')
  const [currentExamId, setCurrentExamId] = useState<string | null>(null)
  const [editTitle, setEditTitle] = useState('')
  const [editStartTime, setEditStartTime] = useState('')
  const [editEndTime, setEditEndTime] = useState('')
  const [editDuration, setEditDuration] = useState('')

  const [showCreateDialog, setShowCreateDialog] = useState(false)
  const [editingExamId, setEditingExamId] = useState<string | null>(null)
  const [classes, setClasses] = useState<Array<{id: string, name: string}>>([])
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [questions, setQuestions] = useState<Array<{ content: string; options?: string[]; correct_answer: string; points: number; }>>([])
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    classId: '',
    start_time: '',
    end_time: '',
    duration: '60',
    total_points: '100',
    type: 'quiz' as 'quiz' | 'midterm' | 'final',
    max_attempts: '1',
    questions_to_show: '',
    show_answers: false
  })

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

  const handleCreateExam = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      setIsLoading(true)

      if (!formData.title || !formData.description || !formData.classId || !formData.start_time || !formData.end_time) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      if (creationMode === 'multiple_choice' && questions.length === 0) {
        throw new Error('Vui lòng thêm câu hỏi cho bài kiểm tra trắc nghiệm')
      }

      if (editingExamId) {
        const { error: updateError } = await supabase.from('exams').update({ title: formData.title, description: sanitizeDescription(formData.description), class_id: formData.classId, start_time: formData.start_time, end_time: formData.end_time, duration: Number(formData.duration), total_points: Number(formData.total_points), type: formData.type, max_attempts: Number(formData.max_attempts), updated_at: new Date().toISOString() }).eq('id', editingExamId)
        if (updateError) throw updateError

        if (questions.length > 0) {
          await supabase.from('exam_questions').delete().eq('exam_id', editingExamId)
          const questionsData = questions.map(q => ({ exam_id: editingExamId, content: q.content, options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options, correct_answer: q.correct_answer, points: q.points, type: 'multiple_choice' }))
          const { error: questionsError } = await supabase.from('exam_questions').insert(questionsData)
          if (questionsError) throw questionsError
        }
        toast({ title: "Thành công", description: "Đã cập nhật bài kiểm tra" })
      } else {
        const examData: CreateExamData = { title: formData.title, description: sanitizeDescription(formData.description), class_id: formData.classId, start_time: formData.start_time, end_time: formData.end_time, duration: Number(formData.duration), total_points: Number(formData.total_points), type: formData.type, max_attempts: Number(formData.max_attempts), questions_to_show: Number(formData.questions_to_show) || null, show_answers: formData.show_answers, status: 'upcoming' }
        const exam = await createExam(examData)

        if (questions.length > 0) {
          const questionsData = questions.map(q => ({ exam_id: exam.id, content: q.content, options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options, correct_answer: q.correct_answer, points: q.points, type: 'multiple_choice' }))
          const { error: questionsError } = await supabase.from('exam_questions').insert(questionsData)
          if (questionsError) throw questionsError
        }
        toast({ title: "Thành công", description: "Đã tạo bài kiểm tra mới" })
      }

      setFormData({
        title: '',
        description: '',
        classId: '',
        start_time: '',
        end_time: '',
        duration: '60',
        total_points: '100',
        type: 'quiz' as 'quiz' | 'midterm' | 'final',
        max_attempts: '1',
        questions_to_show: '',
        show_answers: false
      })
      setQuestions([])
      setSelectedFile(null)
      setEditingExamId(null)
      setShowCreateDialog(false)
      await loadExams()

    } catch (error: any) {
      console.error('Lỗi khi xử lý bài kiểm tra:', error)
      toast({ variant: "destructive", title: "Lỗi", description: error.message || "Không thể xử lý bài kiểm tra" })
    } finally {
      setIsLoading(false)
    }
  }

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    setQuestions([]);
    setSelectedFile(file)

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data, { type: 'buffer' });
      if (!workbook || !workbook.SheetNames || workbook.SheetNames.length === 0) throw new Error("File Excel không hợp lệ hoặc không có trang tính (sheet) nào.");
      const worksheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[worksheetName];
      if (!worksheet) throw new Error(`Không thể tìm thấy trang tính có tên "${worksheetName}".`);
      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      if (jsonData.length === 0) {
        setQuestions([]);
        toast({ variant: "default", title: "File trống", description: "File Excel không có dữ liệu hoặc các cột không được đặt tên đúng." });
        return;
      }

      const newQuestions = jsonData.map((row: any) => ({ content: String(row['Câu hỏi'] || row['Question'] || ''), options: [row['Phương án A'] || row['Option A'], row['Phương án B'] || row['Option B'], row['Phương án C'] || row['Option C'], row['Phương án D'] || row['Option D']].map(option => String(option || '')).filter(option => option.trim() !== ''), correct_answer: String(row['Đáp án đúng'] || row['Correct Answer'] || ''), points: Number(row['Điểm'] || row['Points'] || 10) })).filter(q => q.content && q.correct_answer)

      if (newQuestions.length === 0) {
        setQuestions([]);
        toast({ variant: "default", title: "Không tìm thấy câu hỏi", description: "Không tìm thấy câu hỏi hợp lệ nào. Vui lòng kiểm tra lại tên các cột trong file Excel." });
        return;
      }

      setQuestions(newQuestions)
      toast({ title: "Thành công", description: `Đã tải ${newQuestions.length} câu hỏi từ file Excel` })
    } catch (error: any) {
      console.error('Lỗi khi đọc file Excel:', error)
      toast({ variant: "destructive", title: "Lỗi", description: error.message || "Không thể đọc file Excel. Vui lòng kiểm tra định dạng file." })
    }
  }

  const handleDownloadTemplate = () => {
    const templateData = [ { 'Câu hỏi': 'Câu hỏi mẫu 1?', 'Phương án A': 'Đáp án A', 'Phương án B': 'Đáp án B', 'Phương án C': 'Đáp án C', 'Phương án D': 'Đáp án D', 'Đáp án đúng': 'Đáp án A', 'Điểm': 10 }, { 'Câu hỏi': 'Câu hỏi mẫu 2?', 'Phương án A': 'Đáp án A', 'Phương án B': 'Đáp án B', 'Phương án C': 'Đáp án C', 'Phương án D': 'Đáp án D', 'Đáp án đúng': 'Đáp án B', 'Điểm': 10 } ]
    const worksheet = XLSX.utils.json_to_sheet(templateData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Template')
    XLSX.writeFile(workbook, 'template_bai_kiem_tra.xlsx')
  }

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

      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses.map(c => ({ id: c.id, name: `${c.name} - ${c.subject.name}` })))
      
      const allExams: Exam[] = []
      for (const classItem of teacherClasses) {
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
          <Button className="w-full sm:w-auto" onClick={() => { setEditingExamId(null); setFormData({ title: '', description: '', classId: '', start_time: '', end_time: '', duration: '60', total_points: '100', type: 'quiz', max_attempts: '1', questions_to_show: '', show_answers: false }); setQuestions([]); setSelectedFile(null); setShowCreateDialog(true); }}><Plus className="w-4 h-4 mr-2" />Tạo bài kiểm tra</Button>
        </div>
      </div>

      <SearchFilter searchPlaceholder="Tìm kiếm bài kiểm tra..." filterOptions={filterOptions} onSearch={handleSearch} />

      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent className="sm:max-w-[600px]">
          <form onSubmit={handleCreateExam}>
            <DialogHeader>
              <DialogTitle>{editingExamId ? 'Chỉnh sửa bài kiểm tra' : 'Tạo bài kiểm tra mới'}</DialogTitle>
              <DialogDescription>
                Điền thông tin chi tiết cho bài kiểm tra của bạn.
              </DialogDescription>
            </DialogHeader>
            <Tabs defaultValue="multiple_choice" onValueChange={(value) => setCreationMode(value as 'multiple_choice' | 'essay')}>
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="multiple_choice">Trắc nghiệm (File Excel)</TabsTrigger>
                <TabsTrigger value="essay">Tự luận / Nhập tay</TabsTrigger>
              </TabsList>
              <TabsContent value="multiple_choice" className="space-y-4 py-4">
                <div className="space-y-2">
                  {selectedFile ? (
                    <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors flex flex-col items-center justify-center space-y-4">
                      <Upload className="h-12 w-12 text-blue-400" />
                      <div className="text-center">
                        <p className="text-base font-medium text-blue-600">Đã chọn file:</p>
                        <p className="text-sm font-medium mt-1">{selectedFile.name}</p>
                        <p className="text-xs text-muted-foreground mt-1">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</p>
                      </div>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => setSelectedFile(null)}
                      >
                        Xóa file
                      </Button>
                    </div>
                  ) : (
                    <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors text-center flex flex-col items-center justify-center space-y-4">
                      <Upload className="h-12 w-12 text-blue-500" />
                      <div className="text-center">
                        <p className="text-base font-medium text-blue-600">Chọn file Excel để tải lên câu hỏi</p>
                        <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                        <p className="text-xs text-muted-foreground mt-2">
                          Định dạng hỗ trợ: XLSX, XLS
                        </p>
                      </div>
                      <input
                        id="file-upload"
                        type="file"
                        accept=".xlsx,.xls"
                        onChange={handleFileUpload}
                        className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                      />
                    </div>
                  )}
                </div>
                <p className="text-sm text-muted-foreground">
                  File Excel của bạn phải có định dạng với các cột "Câu hỏi", "Phương án A", "Phương án B", "Phương án C", "Phương án D" và "Đáp án đúng".{' '}
                  <Button 
                    variant="link" 
                    className="h-auto p-0 text-blue-600 underline"
                    onClick={handleDownloadTemplate}
                    type="button"
                  >
                    Tải mẫu
                  </Button>
                </p>
              </TabsContent>
              <TabsContent value="essay" className="space-y-4 py-4">
                <div className="grid gap-4">
                <div className="form-field">
                  <Input 
                    id="title-exam-essay"
                    placeholder="Nhập tiêu đề bài kiểm tra"
                    value={formData.title}
                    onChange={(e) => setFormData({...formData, title: e.target.value})}
                    required
                    className="form-input peer"
                  />
                  <Label htmlFor="title-exam-essay" className="form-label">Tiêu đề</Label>
                </div>
                <div className="relative pt-5">
                  <Textarea 
                    id="description-exam-essay"
                    placeholder="Nhập mô tả bài kiểm tra"
                    value={formData.description}
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    required
                    className="form-textarea peer"
                  />
                  <Label htmlFor="description-exam-essay" className="form-textarea-label">Mô tả</Label>
                </div>
                <div className="form-field">
                  <Label htmlFor="class-exam-essay" className="absolute -top-3 left-3 text-sm text-blue-500">Lớp học</Label>
                  <select
                    id="class-exam-essay"
                    name="class_id"
                    className="w-full px-3 py-2 border rounded-md"
                    value={formData.classId}
                    onChange={(e) => setFormData({...formData, classId: e.target.value})}
                    required
                  >
                    <option value="">Chọn lớp học</option>
                    {classes.map(c => (
                      <option key={c.id} value={c.id}>{c.name}</option>
                    ))}
                  </select>
                </div>
                <div className="form-field">
                  <Input
                    type="datetime-local"
                    id="start_time-exam-essay"
                    value={formData.start_time}
                    onChange={(e) => setFormData({...formData, start_time: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian bắt đầu"
                  />
                  <Label htmlFor="start_time-exam-essay" className="form-label">Thời gian bắt đầu</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="datetime-local"
                    id="end_time-exam-essay"
                    value={formData.end_time}
                    onChange={(e) => setFormData({...formData, end_time: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian kết thúc"
                  />
                  <Label htmlFor="end_time-exam-essay" className="form-label">Thời gian kết thúc</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="duration-exam-essay"
                    min="1"
                    value={formData.duration}
                    onChange={(e) => setFormData({...formData, duration: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian làm bài (phút)"
                  />
                  <Label htmlFor="duration-exam-essay" className="form-label">Thời gian làm bài (phút)</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="total_points-exam-essay"
                    min="0"
                    value={formData.total_points}
                    onChange={(e) => setFormData({...formData, total_points: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Điểm tối đa"
                  />
                  <Label htmlFor="total_points-exam-essay" className="form-label">Điểm tối đa</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="max_attempts-exam-essay"
                    min="1"
                    value={formData.max_attempts}
                    onChange={(e) => setFormData({...formData, max_attempts: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Số lần làm bài"
                  />
                  <Label htmlFor="max_attempts-exam-essay" className="form-label">Số lần làm bài</Label>
                </div>
              </div>
              </TabsContent>
            </Tabs>
              <div className="grid gap-4">
                <div className="form-field">
                  <Input 
                    id="title-exam"
                    placeholder="Nhập tiêu đề bài kiểm tra"
                    value={formData.title}
                    onChange={(e) => setFormData({...formData, title: e.target.value})}
                    required
                    className="form-input peer"
                  />
                  <Label htmlFor="title-exam" className="form-label">Tiêu đề</Label>
                </div>
                <div className="relative pt-5">
                  <Textarea 
                    id="description-exam"
                    placeholder="Nhập mô tả bài kiểm tra"
                    value={formData.description}
                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                    required
                    className="form-textarea peer"
                  />
                  <Label htmlFor="description-exam" className="form-textarea-label">Mô tả</Label>
                </div>
                <div className="form-field">
                  <Label htmlFor="class-exam" className="absolute -top-3 left-3 text-sm text-blue-500">Lớp học</Label>
                  <select
                    id="class-exam"
                    name="class_id"
                    className="w-full px-3 py-2 border rounded-md"
                    value={formData.classId}
                    onChange={(e) => setFormData({...formData, classId: e.target.value})}
                    required
                  >
                    <option value="">Chọn lớp học</option>
                    {classes.map(c => (
                      <option key={c.id} value={c.id}>{c.name}</option>
                    ))}
                  </select>
                </div>
                <div className="form-field">
                  <Input
                    type="datetime-local"
                    id="start_time-exam"
                    value={formData.start_time}
                    onChange={(e) => setFormData({...formData, start_time: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian bắt đầu"
                  />
                  <Label htmlFor="start_time-exam" className="form-label">Thời gian bắt đầu</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="datetime-local"
                    id="end_time-exam"
                    value={formData.end_time}
                    onChange={(e) => setFormData({...formData, end_time: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian kết thúc"
                  />
                  <Label htmlFor="end_time-exam" className="form-label">Thời gian kết thúc</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="duration-exam"
                    min="1"
                    value={formData.duration}
                    onChange={(e) => setFormData({...formData, duration: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Thời gian làm bài (phút)"
                  />
                  <Label htmlFor="duration-exam" className="form-label">Thời gian làm bài (phút)</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="total_points-exam"
                    min="0"
                    value={formData.total_points}
                    onChange={(e) => setFormData({...formData, total_points: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Điểm tối đa"
                  />
                  <Label htmlFor="total_points-exam" className="form-label">Điểm tối đa</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="max_attempts-exam"
                    min="1"
                    value={formData.max_attempts}
                    onChange={(e) => setFormData({...formData, max_attempts: e.target.value})}
                    required
                    className="form-input peer"
                    placeholder="Số lần làm bài"
                  />
                  <Label htmlFor="max_attempts-exam" className="form-label">Số lần làm bài</Label>
                </div>
                <div className="form-field">
                  <Input
                    type="number"
                    id="questions_to_show-exam"
                    min="1"
                    value={formData.questions_to_show}
                    onChange={(e) => setFormData({...formData, questions_to_show: e.target.value})}
                    className="form-input peer"
                    placeholder="Để trống nếu hiện tất cả câu hỏi"
                  />
                  <Label htmlFor="questions_to_show-exam" className="form-label">Số câu hỏi hiển thị</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <Checkbox 
                    id="show_answers-exam"
                    checked={formData.show_answers}
                    onCheckedChange={(checked) => setFormData({...formData, show_answers: !!checked})}
                  />
                  <Label htmlFor="show_answers-exam">Cho phép sinh viên xem đáp án sau khi nộp bài</Label>
                </div>
              </div>
            <DialogFooter className="mt-6">
              <Button type="button" variant="outline" onClick={() => setShowCreateDialog(false)}>
                Hủy
              </Button>
              <Button type="submit" disabled={isLoading}>
                {isLoading ? (editingExamId ? "Đang cập nhật..." : "Đang tạo...") : (editingExamId ? "Cập nhật bài kiểm tra" : "Tạo bài kiểm tra")}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

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