"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassAssignments, deleteAssignment } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Loader2, Plus, RefreshCw, Upload, File as FileIcon, Users, CheckCircle, XCircle } from "lucide-react"
import * as XLSX from 'xlsx'
import { supabase, createAssignment, Assignment as DBAssignment } from '@/lib/supabase'
import { sanitizeDescription } from '@/lib/utils'

type Assignment = {
  id: string
  title: string
  description: string | null
  subject: string
  className: string
  classId: string
  dueDate: string
  type: 'multiple_choice' | 'essay'
  totalQuestions?: number
  totalStudents: number
  submittedCount: number
  averageScore: number | null
  maxPoints: number
}

type GroupedAssignment = {
  title: string;
  mostRecentDueDate: string;
  classes: Assignment[];
  totalSubmissions: number;
  totalStudents: number;
}

type CreateAssignmentData = Omit<DBAssignment, 'id' | 'created_at' | 'updated_at'> & {
  type: 'multiple_choice' | 'essay'
}

export default function TeacherAssignmentsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [groupedAssignments, setGroupedAssignments] = useState<GroupedAssignment[]>([])
  const [filteredAssignments, setFilteredAssignments] = useState<GroupedAssignment[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [showCreateDialog, setShowCreateDialog] = useState(false)
  const [showTemplateDialog, setShowTemplateDialog] = useState(false)
  const [showDetailDialog, setShowDetailDialog] = useState(false)
  const [selectedGroup, setSelectedGroup] = useState<GroupedAssignment | null>(null)
  const [editingAssignmentId, setEditingAssignmentId] = useState<string | null>(null)
  const [classes, setClasses] = useState<Array<{id: string, name: string}>>([])
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [questions, setQuestions] = useState<Array<{ content: string; options?: string[]; correct_answer: string; points: number; }>>([])
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    classId: '',
    dueDate: '',
    maxPoints: '100',
    type: 'multiple_choice' as 'multiple_choice' | 'essay'
  })

  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(assignments.map(a => a.subject))]
    const classNames = [...new Set(assignments.map(a => a.className))]
    
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
        key: 'type',
        label: 'Loại bài tập',
        type: 'select',
        options: [
          { value: 'multiple_choice', label: 'Trắc nghiệm' },
          { value: 'essay', label: 'Tự luận' }
        ]
      },
      {
        key: 'status',
        label: 'Trạng thái',
        type: 'select',
        options: [
          { value: 'active', label: 'Đang diễn ra' },
          { value: 'overdue', label: 'Quá hạn' },
        ]
      },
    ]
  }, [assignments])

  useEffect(() => {
    loadData()
  }, [])

  useEffect(() => {
    let filtered = groupedAssignments

    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(group => 
        group.title.toLowerCase().includes(query) ||
        group.classes.some(c => c.className.toLowerCase().includes(query) || c.subject.toLowerCase().includes(query))
      )
    }

    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "") return

      filtered = filtered.map(group => {
        const filteredClasses = group.classes.filter(assignment => {
          switch (key) {
            case 'subject':
              return assignment.subject === value;
            case 'className':
              return assignment.className === value;
            case 'type':
              return assignment.type === value;
            case 'status':
              const now = new Date();
              const dueDate = new Date(assignment.dueDate);
              if (value === 'active') return dueDate > now;
              if (value === 'overdue') return dueDate <= now;
              return true;
            default:
              return true;
          }
        });
        return { ...group, classes: filteredClasses };
      }).filter(group => group.classes.length > 0);
    });

    setFilteredAssignments(filtered)
  }, [groupedAssignments, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

  async function loadData() {
    try {
      setIsLoading(true)
      
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses.map(c => ({ id: c.id, name: `${c.name} - ${c.subject.name}` })))
      
      const allAssignments: Assignment[] = []
      for (const classItem of teacherClasses) {
        const assignments = await getClassAssignments(classItem.id)
        
        const { data: classStudents } = await supabase.from('enrollments').select('student_id').eq('class_id', classItem.id).eq('status', 'enrolled')
        const totalStudents = classStudents?.length || 0
        
        for (const a of assignments) {
          const { data: submissions } = await supabase.from('assignment_submissions').select('score').eq('assignment_id', a.id)
          const submittedCount = submissions?.length || 0
          const gradedSubmissions = submissions?.filter(s => s.score !== null) || []
          const averageScore = gradedSubmissions.length > 0 ? gradedSubmissions.reduce((sum, s) => sum + (s.score || 0), 0) / gradedSubmissions.length : null
          
          allAssignments.push({
            id: a.id,
            title: a.title,
            description: a.description,
            subject: classItem.subject.name,
            className: classItem.name,
            classId: classItem.id,
            dueDate: a.due_date,
            type: (a as any).type || 'multiple_choice',
            totalStudents,
            submittedCount,
            averageScore,
            maxPoints: a.total_points
          })
        }
      }

      setAssignments(allAssignments)

      const grouped = allAssignments.reduce((acc, assignment) => {
        const { title } = assignment;
        if (!acc[title]) {
          acc[title] = {
            title,
            mostRecentDueDate: '1970-01-01T00:00:00Z',
            classes: [],
            totalSubmissions: 0,
            totalStudents: 0,
          };
        }
        acc[title].classes.push(assignment);
        acc[title].totalSubmissions += assignment.submittedCount;
        acc[title].totalStudents += assignment.totalStudents;
        if (new Date(assignment.dueDate) > new Date(acc[title].mostRecentDueDate)) {
          acc[title].mostRecentDueDate = assignment.dueDate;
        }
        acc[title].classes.sort((a, b) => new Date(b.dueDate).getTime() - new Date(a.dueDate).getTime());
        return acc;
      }, {} as Record<string, GroupedAssignment>);

      const groupedArray = Object.values(grouped).sort((a, b) => new Date(b.mostRecentDueDate).getTime() - new Date(a.mostRecentDueDate).getTime());
      setGroupedAssignments(groupedArray)
      setFilteredAssignments(groupedArray)

      toast({ title: "Đã làm mới", description: "Dữ liệu bài tập đã được cập nhật." })
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải dữ liệu" })
    } finally {
      setIsLoading(false)
    }
  }

  const handleCreateAssignment = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      setIsLoading(true)

      if (!formData.title || !formData.description || !formData.classId || !formData.dueDate) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      if (formData.type === 'multiple_choice' && questions.length === 0) {
        throw new Error('Vui lòng thêm câu hỏi cho bài tập trắc nghiệm')
      }

      if (editingAssignmentId) {
        const { error: updateError } = await supabase.from('assignments').update({ title: formData.title, description: sanitizeDescription(formData.description), class_id: formData.classId, due_date: formData.dueDate, total_points: Number(formData.maxPoints), type: formData.type, updated_at: new Date().toISOString() }).eq('id', editingAssignmentId)
        if (updateError) throw updateError

        if (formData.type === 'multiple_choice' && questions.length > 0) {
          await supabase.from('assignment_questions').delete().eq('assignment_id', editingAssignmentId)
          const questionsData = questions.map(q => ({ assignment_id: editingAssignmentId, content: q.content, options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options, correct_answer: q.correct_answer, points: q.points, type: formData.type }))
          const { error: questionsError } = await supabase.from('assignment_questions').insert(questionsData)
          if (questionsError) throw questionsError
        }
        toast({ title: "Thành công", description: "Đã cập nhật bài tập" })
      } else {
        const assignmentData: CreateAssignmentData = { title: formData.title, description: sanitizeDescription(formData.description), class_id: formData.classId, due_date: formData.dueDate, total_points: Number(formData.maxPoints), file_url: null, type: formData.type }
        const assignment = await createAssignment(assignmentData)

        if (formData.type === 'multiple_choice' && questions.length > 0) {
          const questionsData = questions.map(q => ({ assignment_id: assignment.id, content: q.content, options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options, correct_answer: q.correct_answer, points: q.points, type: formData.type }))
          const { error: questionsError } = await supabase.from('assignment_questions').insert(questionsData)
          if (questionsError) throw questionsError
        }
        toast({ title: "Thành công", description: "Đã tạo bài tập mới" })
      }

      setFormData({ title: '', description: '', classId: '', dueDate: '', maxPoints: '100', type: 'multiple_choice' })
      setQuestions([])
      setSelectedFile(null)
      setEditingAssignmentId(null)
      setShowCreateDialog(false)
      await loadData()

    } catch (error: any) {
      console.error('Lỗi khi xử lý bài tập:', error)
      toast({ variant: "destructive", title: "Lỗi", description: error.message || "Không thể xử lý bài tập" })
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
    XLSX.writeFile(workbook, 'template_bai_tap.xlsx')
  }

  const handleDeleteAssignment = async (assignmentId: string) => {
    try {
      setIsLoading(true)
      await deleteAssignment(assignmentId)
      toast({ title: "Thành công", description: "Đã xóa bài tập" })
      await loadData()
    } catch (error) {
      console.error('Lỗi khi xóa bài tập:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể xóa bài tập" })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return <div>Loading...</div> // Replace with a proper skeleton loader
  }

  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 sm:gap-0">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài tập</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài tập của bạn</p>
          <div className="text-sm text-muted-foreground mt-1">Hiển thị {filteredAssignments.length} / {groupedAssignments.length} nhóm bài tập</div>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={loadData}><RefreshCw className="w-4 h-4 mr-2" />Làm mới</Button>
          <Button className="w-full sm:w-auto" onClick={() => { setEditingAssignmentId(null); setFormData({ title: '', description: '', classId: '', dueDate: '', maxPoints: '100', type: 'multiple_choice' }); setQuestions([]); setSelectedFile(null); setShowCreateDialog(true); }}><Plus className="w-4 h-4 mr-2" />Tạo bài tập</Button>
        </div>
      </div>

      <SearchFilter searchPlaceholder="Tìm kiếm bài tập..." filterOptions={filterOptions} onSearch={handleSearch} />

      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        {/* Create Dialog Content Remains the Same */}
      </Dialog>

      <Dialog open={showTemplateDialog} onOpenChange={setShowTemplateDialog}>
        {/* Template Dialog Content Remains the Same */}
      </Dialog>

      <Dialog open={showDetailDialog} onOpenChange={setShowDetailDialog}>
        <DialogContent className="sm:max-w-4xl w-full">
          <DialogHeader><DialogTitle>Chi tiết nhóm bài tập: {selectedGroup?.title}</DialogTitle></DialogHeader>
          {selectedGroup && (
            <div className="space-y-4 max-h-[70vh] overflow-y-auto">
              {selectedGroup.classes.map(assignment => (
                <div key={assignment.id} className="p-4 border rounded-lg hover:bg-muted/50">
                  <div className="flex justify-between items-start">
                    <div>
                      <h4 className="font-medium text-base">{assignment.className} - {assignment.subject}</h4>
                      <span className={`px-2 py-0.5 text-xs rounded-full w-fit ${assignment.type === 'multiple_choice' ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'}`}>{assignment.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}</span>
                    </div>
                    <div className="flex gap-2">
                      <Button variant="outline" size="sm" onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}/submissions`)}>Bài nộp</Button>
                      <Button variant="destructive" size="sm" onClick={() => handleDeleteAssignment(assignment.id)}>Xóa</Button>
                    </div>
                  </div>
                  <p className="text-sm text-muted-foreground mt-2 break-words">{assignment.description || 'Không có mô tả'}</p>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-3 text-sm">
                    <div><p className="text-muted-foreground">Hạn nộp</p><p className="font-medium">{new Date(assignment.dueDate).toLocaleString('vi-VN')}</p></div>
                    <div><p className="text-muted-foreground">Điểm tối đa</p><p className="font-medium">{assignment.maxPoints}</p></div>
                    <div><p className="text-muted-foreground">Đã nộp / Tổng số</p><p className="font-medium">{assignment.submittedCount} / {assignment.totalStudents}</p></div>
                    <div><p className="text-muted-foreground">Điểm TB</p><p className="font-medium">{assignment.averageScore?.toFixed(1) || 'N/A'}</p></div>
                  </div>
                </div>
              ))}
            </div>
          )}
          <DialogFooter><Button variant="outline" onClick={() => setShowDetailDialog(false)}>Đóng</Button></DialogFooter>
        </DialogContent>
      </Dialog>

      {groupedAssignments.length === 0 && !isLoading ? (
        <div className="text-center py-12"><p className="text-muted-foreground">Chưa có bài tập nào</p></div>
      ) : (
        <div className="rounded-md border">
          <div className="divide-y">
            {filteredAssignments.map((group) => (
              <div key={group.title} className="p-4 hover:bg-muted/50 transition-colors">
                <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                  <div className="p-2 rounded-full bg-blue-100 text-blue-600 flex-shrink-0"><FileIcon className="w-5 h-5" /></div>
                  <div className="flex-1 w-full">
                    <h4 className="font-medium text-base sm:text-lg">{group.title}</h4>
                    <p className="text-sm text-muted-foreground mt-1">Áp dụng cho {group.classes.length} lớp học</p>
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-2 text-sm">
                      <div><p className="text-muted-foreground">Hạn nộp gần nhất</p><p className="font-medium">{new Date(group.mostRecentDueDate).toLocaleString('vi-VN')}</p></div>
                      <div><p className="text-muted-foreground">Tổng số SV</p><p className="font-medium">{group.totalStudents}</p></div>
                      <div><p className="text-muted-foreground">Tổng bài nộp</p><p className="font-medium">{group.totalSubmissions}</p></div>
                    </div>
                  </div>
                  <div className="flex flex-col sm:flex-row gap-2 w-full sm:w-auto">
                    <Button variant="ghost" size="sm" className="text-xs sm:text-sm flex-shrink-0 bg-black text-white hover:bg-black hover:text-white hover:opacity-100" onClick={() => { setSelectedGroup(group); setShowDetailDialog(true); }}>Chi tiết</Button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
