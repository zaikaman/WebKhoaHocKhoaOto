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
import { Loader2, Plus, RefreshCw, Upload, File as FileIcon } from "lucide-react"
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

type CreateAssignmentData = Omit<DBAssignment, 'id' | 'created_at' | 'updated_at'> & {
  type: 'multiple_choice' | 'essay'
}

export default function TeacherAssignmentsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [filteredAssignments, setFilteredAssignments] = useState<Assignment[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [showCreateDialog, setShowCreateDialog] = useState(false)
  const [showTemplateDialog, setShowTemplateDialog] = useState(false)
  const [showDetailDialog, setShowDetailDialog] = useState(false)
  const [selectedAssignment, setSelectedAssignment] = useState<Assignment | null>(null)
  const [editingAssignmentId, setEditingAssignmentId] = useState<string | null>(null)
  const [classes, setClasses] = useState<Array<{id: string, name: string}>>([])
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [questions, setQuestions] = useState<Array<{
    content: string
    options?: string[]
    correct_answer: string
    points: number
  }>>([])
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    classId: '',
    dueDate: '',
    maxPoints: '100',
    type: 'multiple_choice' as 'multiple_choice' | 'essay'
  })

  // Filter options from assignments data
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
          { value: 'upcoming', label: 'Sắp đến hạn' }
        ]
      },
      {
        key: 'dueDate',
        label: 'Hạn nộp',
        type: 'daterange'
      },
      {
        key: 'points',
        label: 'Điểm tối đa',
        type: 'select',
        options: [
          { value: '0-50', label: '0-50 điểm' },
          { value: '50-80', label: '50-80 điểm' },
          { value: '80-100', label: '80-100 điểm' }
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
      }
    ]
  }, [assignments])

  useEffect(() => {
    loadData()
  }, [])

  // Filter assignments based on search query and filters
  useEffect(() => {
    let filtered = assignments

    // Text search
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(assignment => 
        assignment.title.toLowerCase().includes(query) ||
        assignment.description?.toLowerCase().includes(query) ||
        assignment.subject.toLowerCase().includes(query) ||
        assignment.className.toLowerCase().includes(query)
      )
    }

    // Apply filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(a => a.subject === value)
          break
        case 'className':
          filtered = filtered.filter(a => a.className === value)
          break
        case 'type':
          filtered = filtered.filter(a => a.type === value)
          break
        case 'status':
          filtered = filtered.filter(a => {
            const now = new Date()
            const dueDate = new Date(a.dueDate)
            const timeDiff = dueDate.getTime() - now.getTime()
            const daysDiff = timeDiff / (1000 * 3600 * 24)
            
            switch (value) {
              case 'active':
                return daysDiff > 0
              case 'overdue':
                return daysDiff <= 0
              case 'upcoming':
                return daysDiff > 0 && daysDiff <= 7
              default:
                return true
            }
          })
          break
        case 'dueDate':
          if (Array.isArray(value) && (value[0] || value[1])) {
            const [startDate, endDate] = value
            filtered = filtered.filter(a => {
              const assignmentDate = new Date(a.dueDate)
              const start = startDate ? new Date(startDate) : null
              const end = endDate ? new Date(endDate) : null
              
              if (start && end) {
                return assignmentDate >= start && assignmentDate <= end
              } else if (start) {
                return assignmentDate >= start
              } else if (end) {
                return assignmentDate <= end
              }
              return true
            })
          }
          break
        case 'points':
          filtered = filtered.filter(a => {
            const points = a.maxPoints
            switch (value) {
              case '0-50':
                return points >= 0 && points <= 50
              case '50-80':
                return points > 50 && points <= 80
              case '80-100':
                return points > 80 && points <= 100
              default:
                return true
            }
          })
          break
        case 'submissions':
          filtered = filtered.filter(a => {
            switch (value) {
              case 'has_submissions':
                return a.submittedCount > 0
              case 'no_submissions':
                return a.submittedCount === 0
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredAssignments(filtered)
  }, [assignments, searchQuery, filters])

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
      setClasses(teacherClasses.map(c => ({
        id: c.id,
        name: `${c.name} - ${c.subject.name}`
      })))
      
      const allAssignments: Assignment[] = []
      for (const classItem of teacherClasses) {
        const assignments = await getClassAssignments(classItem.id)
        
        const { data: classStudents, error: studentsError } = await supabase
          .from('enrollments')
          .select('student_id')
          .eq('class_id', classItem.id)
          .eq('status', 'enrolled')
        
        const totalStudents = classStudents?.length || 0
        
        for (const a of assignments) {
          const { data: submissions, error: submissionsError } = await supabase
            .from('assignment_submissions')
            .select('score')
            .eq('assignment_id', a.id)
          
          const submittedCount = submissions?.length || 0
          
          const gradedSubmissions = submissions?.filter(s => s.score !== null) || []
          const averageScore = gradedSubmissions.length > 0 
            ? gradedSubmissions.reduce((sum, s) => sum + (s.score || 0), 0) / gradedSubmissions.length
            : null
          
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

      allAssignments.sort((a, b) => new Date(b.dueDate).getTime() - new Date(a.dueDate).getTime())
      setAssignments(allAssignments)
      setFilteredAssignments(allAssignments)
      toast({
        title: "Đã làm mới",
        description: "Dữ liệu bài tập đã được cập nhật.",
      })
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu"
      })
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
        const { error: updateError } = await supabase
          .from('assignments')
          .update({
            title: formData.title,
            description: sanitizeDescription(formData.description),
            class_id: formData.classId,
            due_date: formData.dueDate,
            total_points: Number(formData.maxPoints),
            type: formData.type,
            updated_at: new Date().toISOString()
          })
          .eq('id', editingAssignmentId)

        if (updateError) throw updateError

        if (formData.type === 'multiple_choice' && questions.length > 0) {
          await supabase
            .from('assignment_questions')
            .delete()
            .eq('assignment_id', editingAssignmentId)

          const questionsData = questions.map(q => ({
            assignment_id: editingAssignmentId,
            content: q.content,
            options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options,
            correct_answer: q.correct_answer,
            points: q.points,
            type: formData.type
          }))

          const { error: questionsError } = await supabase
            .from('assignment_questions')
            .insert(questionsData)

          if (questionsError) throw questionsError
        }

        toast({
          title: "Thành công",
          description: "Đã cập nhật bài tập"
        })
      } else {
        const assignmentData: CreateAssignmentData = {
          title: formData.title,
          description: sanitizeDescription(formData.description),
          class_id: formData.classId,
          due_date: formData.dueDate,
          total_points: Number(formData.maxPoints),
          file_url: null,
          type: formData.type
        }

        const assignment = await createAssignment(assignmentData)

        if (formData.type === 'multiple_choice' && questions.length > 0) {
          const questionsData = questions.map(q => ({
            assignment_id: assignment.id,
            content: q.content,
            options: Array.isArray(q.options) ? JSON.stringify(q.options) : q.options,
            correct_answer: q.correct_answer,
            points: q.points,
            type: formData.type
          }))

          const { error: questionsError } = await supabase
            .from('assignment_questions')
            .insert(questionsData)

          if (questionsError) throw questionsError
        }

        toast({
          title: "Thành công",
          description: "Đã tạo bài tập mới"
        })
      }

      setFormData({
        title: '',
        description: '',
        classId: '',
        dueDate: '',
        maxPoints: '100',
        type: 'multiple_choice'
      })
      setQuestions([])
      setSelectedFile(null)
      setEditingAssignmentId(null)
      setShowCreateDialog(false)
      await loadData()

    } catch (error: any) {
      console.error('Lỗi khi xử lý bài tập:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể xử lý bài tập"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    setQuestions([]); // Reset questions on new file selection
    setSelectedFile(file)

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data, { type: 'buffer' });

      if (!workbook || !workbook.SheetNames || workbook.SheetNames.length === 0) {
          throw new Error("File Excel không hợp lệ hoặc không có trang tính (sheet) nào.");
      }

      const worksheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[worksheetName];

      if (!worksheet) {
          throw new Error(`Không thể tìm thấy trang tính có tên "${worksheetName}".`);
      }

      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      if (jsonData.length === 0) {
        setQuestions([]);
        toast({
            variant: "default",
            title: "File trống",
            description: "File Excel không có dữ liệu hoặc các cột không được đặt tên đúng."
        });
        return;
      }

      const newQuestions = jsonData.map((row: any) => ({
        content: String(row['Câu hỏi'] || row['Question'] || ''),
        options: [
          row['Phương án A'] || row['Option A'],
          row['Phương án B'] || row['Option B'],
          row['Phương án C'] || row['Option C'],
          row['Phương án D'] || row['Option D']
        ].map(option => String(option || '')).filter(option => option.trim() !== ''),
        correct_answer: String(row['Đáp án đúng'] || row['Correct Answer'] || ''),
        points: Number(row['Điểm'] || row['Points'] || 10)
      })).filter(q => q.content && q.correct_answer)

      if (newQuestions.length === 0) {
        setQuestions([]);
        toast({
            variant: "default",
            title: "Không tìm thấy câu hỏi",
            description: "Không tìm thấy câu hỏi hợp lệ nào. Vui lòng kiểm tra lại tên các cột trong file Excel."
        });
        return;
      }

      setQuestions(newQuestions)
      
      toast({
        title: "Thành công",
        description: `Đã tải ${newQuestions.length} câu hỏi từ file Excel`
      })
    } catch (error: any) {
      console.error('Lỗi khi đọc file Excel:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể đọc file Excel. Vui lòng kiểm tra định dạng file."
      })
    }
  }

  const handleDownloadTemplate = () => {
    const templateData = [
      {
        'Câu hỏi': 'Câu hỏi mẫu 1?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'Đáp án A',
        'Điểm': 10
      },
      {
        'Câu hỏi': 'Câu hỏi mẫu 2?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'Đáp án B',
        'Điểm': 10
      }
    ]

    const worksheet = XLSX.utils.json_to_sheet(templateData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Template')
    XLSX.writeFile(workbook, 'template_bai_tap.xlsx')
  }

  const handleDeleteAssignment = async (assignmentId: string) => {
    try {
      setIsLoading(true)
      
      await deleteAssignment(assignmentId)
      
      toast({
        title: "Thành công",
        description: "Đã xóa bài tập"
      })
      
      await loadData()
    } catch (error) {
      console.error('Lỗi khi xóa bài tập:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa bài tập"
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

        {/* Assignment List Skeleton */}
        <div className="rounded-md border">
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
                    <div className="grid grid-cols-3 gap-4 mt-2">
                      <div>
                        <div className="h-3 w-20 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-20 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                      </div>
                      <div>
                        <div className="h-3 w-20 bg-muted rounded animate-pulse mb-1" />
                        <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                      </div>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <div className="h-8 w-20 bg-muted rounded animate-pulse" />
                    <div className="h-8 w-20 bg-muted rounded animate-pulse" />
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
      {/* Header and Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 sm:gap-0">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài tập</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài tập của bạn</p>
          <div className="text-sm text-muted-foreground mt-1">
            Hiển thị {filteredAssignments.length} / {assignments.length} bài tập
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={loadData}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Làm mới
          </Button>
          <Button className="w-full sm:w-auto" onClick={() => {
            setEditingAssignmentId(null)
            setFormData({
              title: '',
              description: '',
              classId: '',
              dueDate: '',
              maxPoints: '100',
              type: 'multiple_choice'
            })
            setQuestions([])
            setSelectedFile(null)
            setShowCreateDialog(true)
          }}>
            <Plus className="w-4 h-4 mr-2" />
            Tạo bài tập
          </Button>
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài tập..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      {/* Create Assignment Dialog */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent className="sm:max-w-[600px]">
          <form onSubmit={handleCreateAssignment}>
            <DialogHeader>
              <DialogTitle>{editingAssignmentId ? 'Chỉnh sửa bài tập' : 'Tạo bài tập mới'}</DialogTitle>
              <DialogDescription>
                Chọn loại bài tập bạn muốn tạo
              </DialogDescription>
            </DialogHeader>
            <Tabs defaultValue="multiple_choice" onValueChange={(value) => setFormData({...formData, type: value as 'multiple_choice' | 'essay'})}>
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="multiple_choice">Trắc nghiệm</TabsTrigger>
                <TabsTrigger value="essay">Tự luận</TabsTrigger>
              </TabsList>
              <TabsContent value="multiple_choice" className="space-y-4">
                <div className="space-y-4 pt-4">
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
                          <p className="text-base font-medium text-blue-600">Chọn file Excel để tải lên</p>
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
                      onClick={() => setShowTemplateDialog(true)}
                      type="button"
                    >
                      Tải mẫu
                    </Button>
                  </p>
                </div>
                <div className="grid gap-4">
                  <div className="form-field">
                    <Input 
                      id="title-mc"
                      placeholder="Nhập tiêu đề bài tập"
                      value={formData.title}
                      onChange={(e) => setFormData({...formData, title: e.target.value})}
                      required
                      className="form-input peer"
                    />
                    <Label htmlFor="title-mc" className="form-label">Tiêu đề</Label>
                  </div>
                  <div className="relative pt-5">
                    <Textarea 
                      id="description-mc"
                      placeholder="Nhập mô tả bài tập"
                      value={formData.description}
                      onChange={(e) => setFormData({...formData, description: e.target.value})}
                      required
                      className="form-textarea peer"
                    />
                    <Label htmlFor="description-mc" className="form-textarea-label">Mô tả</Label>
                  </div>
                  <div className="form-field">
                    <Label htmlFor="class-mc" className="absolute -top-3 left-3 text-sm text-blue-500">Lớp học</Label>
                    <select
                      id="class-mc"
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
                      id="dueDate-mc"
                      value={formData.dueDate}
                      onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                      required
                      className="form-input peer"
                      placeholder="Hạn nộp"
                    />
                    <Label htmlFor="dueDate-mc" className="form-label">Hạn nộp</Label>
                  </div>
                  <div className="form-field">
                    <Input
                      type="number"
                      id="maxPoints-mc"
                      min="0"
                      max="100"
                      value={formData.maxPoints}
                      onChange={(e) => setFormData({...formData, maxPoints: e.target.value})}
                      required
                      className="form-input peer"
                      placeholder="Điểm tối đa"
                    />
                    <Label htmlFor="maxPoints-mc" className="form-label">Điểm tối đa</Label>
                  </div>
                </div>
              </TabsContent>
              <TabsContent value="essay" className="space-y-4">
                <div className="space-y-4 pt-4">
                  <div className="grid gap-4">
                    <div className="form-field">
                      <Input 
                        id="title-essay"
                        placeholder="Nhập tiêu đề bài tập"
                        value={formData.title}
                        onChange={(e) => setFormData({...formData, title: e.target.value})}
                        required
                        className="form-input peer"
                      />
                      <Label htmlFor="title-essay" className="form-label">Tiêu đề</Label>
                    </div>
                    <div className="relative pt-5">
                      <Textarea 
                        id="description-essay"
                        placeholder="Nhập mô tả và yêu cầu của bài tập"
                        value={formData.description}
                        onChange={(e) => setFormData({...formData, description: e.target.value})}
                        required
                        className="form-textarea peer"
                      />
                      <Label htmlFor="description-essay" className="form-textarea-label">Mô tả</Label>
                    </div>
                    <div className="form-field">
                      <Label htmlFor="class-essay" className="absolute -top-3 left-3 text-sm text-blue-500">Lớp học</Label>
                      <select
                        id="class-essay"
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
                        type="number"
                        id="maxPoints-essay"
                        min="0"
                        max="100"
                        value={formData.maxPoints}
                        onChange={(e) => setFormData({...formData, maxPoints: e.target.value})}
                        required
                        className="form-input peer"
                        placeholder="Điểm tối đa"
                      />
                      <Label htmlFor="maxPoints-essay" className="form-label">Điểm tối đa</Label>
                    </div>
                    <div className="form-field">
                      <Input
                        type="datetime-local"
                        id="dueDate-essay"
                        value={formData.dueDate}
                        onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                        required
                        className="form-input peer"
                        placeholder="Hạn nộp"
                      />
                      <Label htmlFor="dueDate-essay" className="form-label">Hạn nộp</Label>
                    </div>
                  </div>
                </div>
              </TabsContent>
            </Tabs>
            <DialogFooter className="mt-6">
              <Button type="button" variant="outline" onClick={() => setShowCreateDialog(false)}>
                Hủy
              </Button>
                              <Button type="submit" disabled={isLoading}>
                  {isLoading ? (editingAssignmentId ? "Đang cập nhật..." : "Đang tạo...") : (editingAssignmentId ? "Cập nhật bài tập" : "Tạo bài tập")}
                </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Template File Dialog */}
      <Dialog open={showTemplateDialog} onOpenChange={setShowTemplateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>File mẫu (Excel)</DialogTitle>
            <DialogDescription>
              Để tạo bài tập trắc nghiệm tự động, file Excel của bạn phải có các cột sau: "Câu hỏi", "Phương án A", "Phương án B", "Phương án C", "Phương án D", "Đáp án đúng".
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <p className="text-sm text-muted-foreground">
              Bạn có thể tải file mẫu để tham khảo định dạng:
            </p>
            <Button variant="link" className="h-auto p-0" onClick={handleDownloadTemplate}>
              Tải file mẫu Excel
            </Button>
          </div>
          <DialogFooter>
            <Button onClick={() => setShowTemplateDialog(false)}>Đóng</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Assignment Detail Dialog */}
      <Dialog open={showDetailDialog} onOpenChange={setShowDetailDialog}>
        <DialogContent className="sm:max-w-[600px] w-full">
          <DialogHeader>
            <DialogTitle>Chi tiết bài tập</DialogTitle>
          </DialogHeader>
          {selectedAssignment && (
            <div className="space-y-4">
              <div className="flex flex-col sm:flex-row sm:items-center gap-2">
                <h3 className="text-lg font-semibold break-words">{selectedAssignment.title}</h3>
                <span
                  className={`px-2 py-0.5 text-xs rounded-full w-fit ${
                    selectedAssignment.type === 'multiple_choice'
                      ? 'bg-blue-100 text-blue-700'
                      : 'bg-purple-100 text-purple-700'
                  }`}
                >
                  {selectedAssignment.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}
                </span>
              </div>

              <div className="space-y-2">
                <Label htmlFor="detail-description">Mô tả</Label>
                <p
                  id="detail-description"
                  className="text-sm text-muted-foreground break-words"
                >
                  {selectedAssignment.description || 'Không có mô tả'}
                </p>
              </div>

              <div className="space-y-2">
                <Label htmlFor="detail-class">Thông tin lớp học</Label>
                <p
                  id="detail-class"
                  className="text-sm text-muted-foreground break-words"
                >
                  {selectedAssignment.subject} - {selectedAssignment.className}
                </p>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <Label htmlFor="detail-points">Điểm tối đa</Label>
                  <p id="detail-points" className="text-sm font-medium mt-1">{selectedAssignment.maxPoints} điểm</p>
                </div>
                <div>
                  <Label htmlFor="detail-due-date">Hạn nộp</Label>
                  <p id="detail-due-date" className="text-sm font-medium mt-1">
                    {new Date(selectedAssignment.dueDate).toISOString().replace('T', ' ').substring(0, 19)}
                  </p>
                </div>
                <div>
                  <Label htmlFor="detail-submissions">Số bài đã nộp</Label>
                  <p id="detail-submissions" className="text-sm font-medium mt-1">{selectedAssignment.submittedCount}</p>
                </div>
              </div>

              <div className="flex flex-col sm:flex-row justify-end gap-2">
                <Button
                  variant="outline"
                  className="w-full sm:w-auto"
                  onClick={() => setShowDetailDialog(false)}
                >
                  Đóng
                </Button>
                <Button
                  variant="outline"
                  className="w-full sm:w-auto"
                  onClick={async () => {
                    setShowDetailDialog(false)
                    if (selectedAssignment) {
                      setEditingAssignmentId(selectedAssignment.id)
                      setFormData({
                        title: selectedAssignment.title,
                        description: selectedAssignment.description || '',
                        classId: selectedAssignment.classId,
                        dueDate: new Date(selectedAssignment.dueDate).toISOString().slice(0, 16),
                        maxPoints: selectedAssignment.maxPoints.toString(),
                        type: selectedAssignment.type
                      })

                      if (selectedAssignment.type === 'multiple_choice') {
                        try {
                          const { data: questionsData, error } = await supabase
                            .from('assignment_questions')
                            .select('*')
                            .eq('assignment_id', selectedAssignment.id)
                            .order('created_at', { ascending: true })

                          if (!error && questionsData) {
                            setQuestions(questionsData.map(q => ({
                              content: q.content,
                              options: q.options,
                              correct_answer: q.correct_answer,
                              points: q.points
                            })))
                          }
                        } catch (error) {
                          console.error('Error loading questions:', error)
                        }
                      } else {
                        setQuestions([])
                      }

                      setShowCreateDialog(true)
                    }
                  }}
                >
                  Chỉnh sửa
                </Button>
                <Button
                  variant="destructive"
                  className="w-full sm:w-auto"
                  onClick={() => {
                    setShowDetailDialog(false)
                    handleDeleteAssignment(selectedAssignment.id)
                  }}
                >
                  Xóa
                </Button>
                <Button
                  className="w-full sm:w-auto"
                  onClick={() =>
                    router.push(`/dashboard/teacher/assignments/${selectedAssignment.id}/submissions`)
                  }
                >
                  Xem bài nộp
                </Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Assignment List */}
      {assignments.length === 0 && !isLoading ? (
        <div className="text-center py-12">
          <p className="text-muted-foreground">Chưa có bài tập nào</p>
        </div>
      ) : (
        <div className="rounded-md border">
          <div className="divide-y">
            {assignments.map((assignment) => (
              <div key={assignment.id} className="p-4 hover:bg-muted/50 transition-colors">
                <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                  <div className="p-2 rounded-full bg-blue-100 text-blue-600 flex-shrink-0">
                    <FileIcon className="w-5 h-5" />
                  </div>
                  <div className="flex-1 w-full">
                    <div className="flex flex-col sm:flex-row sm:items-center gap-2">
                      <h4 className="font-medium text-base sm:text-lg">{assignment.title}</h4>
                      <span className={`px-2 py-0.5 text-xs rounded-full w-fit ${
                        assignment.type === 'multiple_choice'
                          ? 'bg-blue-100 text-blue-700'
                          : 'bg-purple-100 text-purple-700'
                      }`}>
                        {assignment.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground mt-1">{assignment.subject} - {assignment.className}</p>
                    <div className="grid grid-cols-1 sm:grid-cols-5 gap-4 mt-2 text-sm">
                      <div>
                        <p className="text-muted-foreground">Điểm tối đa</p>
                        <p className="font-medium">{assignment.maxPoints} điểm</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Hạn nộp</p>
                        <p className="font-medium">
                          {new Date(assignment.dueDate).toISOString().replace('T', ' ').substring(0, 19)}
                        </p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Tổng số SV</p>
                        <p className="font-medium">{assignment.totalStudents}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Đã nộp</p>
                        <p className="font-medium">{assignment.submittedCount}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Điểm TB</p>
                        <p className="font-medium">{assignment.averageScore?.toFixed(1) || 'N/A'}</p>
                      </div>
                    </div>
                  </div>
                  <div className="flex flex-col sm:flex-row gap-2 w-full sm:w-auto">
                    <Button 
                      variant="ghost" 
                      size="sm" 
                      className="text-xs sm:text-sm flex-shrink-0 bg-black text-white hover:bg-black hover:text-white hover:opacity-100"
                      onClick={() => {
                        setSelectedAssignment(assignment)
                        setShowDetailDialog(true)
                      }}
                    >
                      Chi tiết
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      className="w-full sm:w-auto"
                      onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}/submissions`)}
                    >
                      Bài nộp
                    </Button>
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