"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassAssignments } from "@/lib/supabase"
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
import { Loader2 } from "lucide-react"
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

  // Tạo filter options từ dữ liệu assignments
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

  // Lọc assignments dựa trên search query và filters
  useEffect(() => {
    let filtered = assignments

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(assignment => 
        assignment.title.toLowerCase().includes(query) ||
        assignment.description?.toLowerCase().includes(query) ||
        assignment.subject.toLowerCase().includes(query) ||
        assignment.className.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
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
      
      // Lấy thông tin người dùng hiện tại
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      // Lấy danh sách lớp học
      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses.map(c => ({
        id: c.id,
        name: `${c.name} - ${c.subject.name}`
      })))
      
      // Lấy bài tập từ tất cả các lớp
      const allAssignments: Assignment[] = []
      for (const classItem of teacherClasses) {
        const assignments = await getClassAssignments(classItem.id)
        
        // Lấy tổng số sinh viên trong lớp
        const { data: classStudents, error: studentsError } = await supabase
          .from('enrollments')
          .select('student_id')
          .eq('class_id', classItem.id)
          .eq('status', 'enrolled')
        
        const totalStudents = classStudents?.length || 0
        
        for (const a of assignments) {
          // Lấy thống kê bài nộp cho từng assignment
          const { data: submissions, error: submissionsError } = await supabase
            .from('assignment_submissions')
            .select('score')
            .eq('assignment_id', a.id)
          
          const submittedCount = submissions?.length || 0
          
          // Tính điểm trung bình từ các bài đã chấm
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

      // Sắp xếp theo thời gian mới nhất
      allAssignments.sort((a, b) => new Date(b.dueDate).getTime() - new Date(a.dueDate).getTime())
      setAssignments(allAssignments)
      setFilteredAssignments(allAssignments)

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

      // Validate form data
      if (!formData.title || !formData.description || !formData.classId || !formData.dueDate) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      if (formData.type === 'multiple_choice' && questions.length === 0) {
        throw new Error('Vui lòng thêm câu hỏi cho bài tập trắc nghiệm')
      }

      if (editingAssignmentId) {
        // Update existing assignment
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

        // Update questions if multiple choice
        if (formData.type === 'multiple_choice' && questions.length > 0) {
          // Delete existing questions
          await supabase
            .from('assignment_questions')
            .delete()
            .eq('assignment_id', editingAssignmentId)

          // Insert new questions
          const questionsData = questions.map(q => ({
            assignment_id: editingAssignmentId,
            content: q.content,
            options: q.options,
            correct_answer: q.correct_answer,
            points: q.points
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
        // Create new assignment
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

        // If multiple choice, create questions
        if (formData.type === 'multiple_choice' && questions.length > 0) {
          const questionsData = questions.map(q => ({
            assignment_id: assignment.id,
            content: q.content,
            options: q.options,
            correct_answer: q.correct_answer,
            points: q.points
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

      // Reset form and close dialog
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

    setSelectedFile(file)

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data)
      const worksheet = workbook.Sheets[workbook.SheetNames[0]]
      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      const newQuestions = jsonData.map((row: any) => ({
        content: row['Câu hỏi'] || row['Question'] || '',
        options: [
          row['Phương án A'] || row['Option A'] || '',
          row['Phương án B'] || row['Option B'] || '',
          row['Phương án C'] || row['Option C'] || '',
          row['Phương án D'] || row['Option D'] || ''
        ].filter(option => option.trim() !== ''),
        correct_answer: row['Đáp án đúng'] || row['Correct Answer'] || '',
        points: Number(row['Điểm'] || row['Points'] || 10)
      })).filter(q => q.content && q.correct_answer)

      setQuestions(newQuestions)
      
      toast({
        title: "Thành công",
        description: `Đã tải ${newQuestions.length} câu hỏi từ file Excel`
      })
    } catch (error) {
      console.error('Lỗi khi đọc file Excel:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể đọc file Excel. Vui lòng kiểm tra định dạng file."
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
        'Đáp án đúng': 'A',
        'Điểm': 10
      },
      {
        'Câu hỏi': 'Câu hỏi mẫu 2?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'B',
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
      
      // Thêm logic xóa bài tập ở đây
      // await deleteAssignment(assignmentId)
      
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
            Tạo bài tập
          </Button>
          <Button className="w-full sm:w-auto" variant="outline" onClick={loadData}>
            Làm mới
          </Button>
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài tập..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      {/* Dialog tạo bài tập */}
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
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                        </svg>
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
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                          <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                        </svg>
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
                  <div className="grid gap-2">
                    <Label htmlFor="title-mc">Tiêu đề</Label>
                    <Input 
                      id="title-mc"
                      placeholder="Nhập tiêu đề bài tập"
                      value={formData.title}
                      onChange={(e) => setFormData({...formData, title: e.target.value})}
                      required
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="description-mc">Mô tả</Label>
                    <Textarea 
                      id="description-mc"
                      placeholder="Nhập mô tả bài tập"
                      value={formData.description}
                      onChange={(e) => setFormData({...formData, description: e.target.value})}
                      required
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="class-mc">Lớp học</Label>
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
                  <div className="grid gap-2">
                    <Label htmlFor="dueDate-mc">Hạn nộp</Label>
                    <Input
                      type="datetime-local"
                      id="dueDate-mc"
                      value={formData.dueDate}
                      onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                      required
                    />
                  </div>
                  <div className="grid gap-2">
                    <Label htmlFor="maxPoints-mc">Điểm tối đa</Label>
                    <Input
                      type="number"
                      id="maxPoints-mc"
                      min="0"
                      max="100"
                      value={formData.maxPoints}
                      onChange={(e) => setFormData({...formData, maxPoints: e.target.value})}
                      required
                    />
                  </div>
                </div>
              </TabsContent>
              <TabsContent value="essay" className="space-y-4">
                <div className="space-y-4 pt-4">
                  <div className="grid gap-4">
                    <div className="grid gap-2">
                      <Label htmlFor="title-essay">Tiêu đề</Label>
                      <Input 
                        id="title-essay"
                        placeholder="Nhập tiêu đề bài tập"
                        value={formData.title}
                        onChange={(e) => setFormData({...formData, title: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="description-essay">Mô tả</Label>
                      <Textarea 
                        id="description-essay"
                        placeholder="Nhập mô tả và yêu cầu của bài tập"
                        value={formData.description}
                        onChange={(e) => setFormData({...formData, description: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="class-essay">Lớp học</Label>
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
                    <div className="grid gap-2">
                      <Label htmlFor="maxPoints-essay">Điểm tối đa</Label>
                      <Input
                        type="number"
                        id="maxPoints-essay"
                        min="0"
                        max="100"
                        value={formData.maxPoints}
                        onChange={(e) => setFormData({...formData, maxPoints: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="dueDate-essay">Hạn nộp</Label>
                      <Input
                        type="datetime-local"
                        id="dueDate-essay"
                        value={formData.dueDate}
                        onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                        required
                      />
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

      {/* Dialog xem mẫu file */}
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

      {/* Dialog xem chi tiết bài tập */}
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

                      // Load existing questions if multiple choice
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

      {/* Danh sách bài tập */}
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
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    >
                      <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
                      <polyline points="14 2 14 8 20 8" />
                      <line x1="16" y1="13" x2="8" y2="13" />
                      <line x1="16" y1="17" x2="8" y2="17" />
                      <line x1="10" y1="9" x2="8" y2="9" />
                    </svg>
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
