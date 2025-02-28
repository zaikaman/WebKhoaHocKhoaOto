"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassAssignments } from "@/lib/supabase"
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

type Assignment = {
  id: string
  title: string
  description: string | null
  subject: string
  className: string
  dueDate: string
  status: 'draft' | 'published'
  totalQuestions?: number
  submittedCount: number
  maxPoints: number
}

export default function TeacherAssignmentsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [showCreateDialog, setShowCreateDialog] = useState(false)
  const [showTemplateDialog, setShowTemplateDialog] = useState(false)
  const [classes, setClasses] = useState<Array<{id: string, name: string}>>([])
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    classId: '',
    dueDate: '',
    maxPoints: '100',
    type: 'multiple_choice' as 'multiple_choice' | 'essay'
  })

  useEffect(() => {
    loadData()
  }, [])

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
        allAssignments.push(...assignments.map(a => ({
          id: a.id,
          title: a.title,
          description: a.description,
          subject: classItem.subject.name,
          className: classItem.name,
          dueDate: a.due_date,
          status: 'published' as const,
          submittedCount: 0,
          maxPoints: a.total_points
        })))
      }

      // Sắp xếp theo thời gian mới nhất
      allAssignments.sort((a, b) => new Date(b.dueDate).getTime() - new Date(a.dueDate).getTime())
      setAssignments(allAssignments)

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
    // TODO: Implement assignment creation
    setShowCreateDialog(false)
    toast({
      title: "Thành công",
      description: "Đã tạo bài tập mới"
    })
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-[200px]">
        <Loader2 className="h-8 w-8 animate-spin" />
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Bài tập</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài tập của bạn</p>
        </div>
        <div className="flex items-center gap-2">
          <Button onClick={() => setShowCreateDialog(true)}>
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
          <Button variant="outline" onClick={loadData}>
            Làm mới
          </Button>
        </div>
      </div>

      {/* Dialog tạo bài tập */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent className="sm:max-w-[600px]">
          <form onSubmit={handleCreateAssignment}>
            <DialogHeader>
              <DialogTitle>Tạo bài tập mới</DialogTitle>
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
                    <Label>Tải lên file Word/PDF theo mẫu</Label>
                    <div className="grid w-full max-w-sm items-center gap-1.5">
                      <Input 
                        type="file" 
                        accept=".docx,.pdf"
                        onChange={(e) => {
                          // TODO: Handle file upload
                        }}
                      />
                    </div>
                    <p className="text-sm text-muted-foreground">
                      File của bạn phải theo đúng format để có thể tự động tạo câu hỏi trắc nghiệm.{' '}
                      <Button 
                        variant="link" 
                        className="h-auto p-0" 
                        onClick={() => setShowTemplateDialog(true)}
                        type="button"
                      >
                        Xem mẫu
                      </Button>
                    </p>
                  </div>
                  <div className="grid gap-4">
                    <div className="grid gap-2">
                      <Label htmlFor="title">Tiêu đề</Label>
                      <Input 
                        id="title" 
                        placeholder="Nhập tiêu đề bài tập"
                        value={formData.title}
                        onChange={(e) => setFormData({...formData, title: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="description">Mô tả</Label>
                      <Textarea 
                        id="description" 
                        placeholder="Nhập mô tả bài tập"
                        value={formData.description}
                        onChange={(e) => setFormData({...formData, description: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="class">Lớp học</Label>
                      <select 
                        className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background"
                        value={formData.classId}
                        onChange={(e) => setFormData({...formData, classId: e.target.value})}
                        required
                      >
                        <option value="">Chọn lớp học</option>
                        {classes.map((c) => (
                          <option key={c.id} value={c.id}>{c.name}</option>
                        ))}
                      </select>
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="dueDate">Hạn nộp</Label>
                      <Input 
                        id="dueDate" 
                        type="datetime-local"
                        value={formData.dueDate}
                        onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                        required
                      />
                    </div>
                  </div>
                </div>
              </TabsContent>
              <TabsContent value="essay" className="space-y-4">
                <div className="space-y-4 pt-4">
                  <div className="grid gap-4">
                    <div className="grid gap-2">
                      <Label htmlFor="title">Tiêu đề</Label>
                      <Input 
                        id="title" 
                        placeholder="Nhập tiêu đề bài tập"
                        value={formData.title}
                        onChange={(e) => setFormData({...formData, title: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="description">Mô tả</Label>
                      <Textarea 
                        id="description" 
                        placeholder="Nhập mô tả và yêu cầu của bài tập"
                        value={formData.description}
                        onChange={(e) => setFormData({...formData, description: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="class">Lớp học</Label>
                      <select 
                        className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background"
                        value={formData.classId}
                        onChange={(e) => setFormData({...formData, classId: e.target.value})}
                        required
                      >
                        <option value="">Chọn lớp học</option>
                        {classes.map((c) => (
                          <option key={c.id} value={c.id}>{c.name}</option>
                        ))}
                      </select>
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="maxPoints">Điểm tối đa</Label>
                      <Input 
                        id="maxPoints" 
                        type="number" 
                        min="0" 
                        max="100"
                        value={formData.maxPoints}
                        onChange={(e) => setFormData({...formData, maxPoints: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label htmlFor="dueDate">Hạn nộp</Label>
                      <Input 
                        id="dueDate" 
                        type="datetime-local"
                        value={formData.dueDate}
                        onChange={(e) => setFormData({...formData, dueDate: e.target.value})}
                        required
                      />
                    </div>
                    <div className="grid gap-2">
                      <Label>Tài liệu đính kèm (không bắt buộc)</Label>
                      <Input 
                        type="file" 
                        multiple
                        onChange={(e) => {
                          // TODO: Handle file upload
                        }}
                      />
                    </div>
                  </div>
                </div>
              </TabsContent>
            </Tabs>
            <DialogFooter className="mt-4">
              <Button variant="outline" type="button" onClick={() => setShowCreateDialog(false)}>
                Hủy
              </Button>
              <Button type="submit">Tạo bài tập</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Dialog xem mẫu file */}
      <Dialog open={showTemplateDialog} onOpenChange={setShowTemplateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Format file mẫu</DialogTitle>
            <DialogDescription>
              Để tạo bài tập trắc nghiệm tự động, file của bạn phải tuân theo format sau:
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="rounded-md bg-muted p-4">
              <pre className="text-sm whitespace-pre-wrap">
{`Câu 1: Nội dung câu hỏi
A. Đáp án A
B. Đáp án B
C. Đáp án C
D. Đáp án D
Đáp án đúng: A

Câu 2: Nội dung câu hỏi
A. Đáp án A
B. Đáp án B
C. Đáp án C
D. Đáp án D
Đáp án đúng: C

...`}
              </pre>
            </div>
            <p className="text-sm text-muted-foreground">
              - Mỗi câu hỏi bắt đầu bằng "Câu X:" (X là số thứ tự)<br />
              - Mỗi đáp án bắt đầu bằng chữ cái in hoa (A, B, C, D) và dấu chấm<br />
              - Đáp án đúng được chỉ định ở dòng cuối của mỗi câu hỏi<br />
              - Các câu hỏi cách nhau bởi một dòng trống
            </p>
          </div>
          <DialogFooter>
            <Button onClick={() => setShowTemplateDialog(false)}>Đóng</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Danh sách bài tập */}
      <div className="rounded-md border">
        <div className="divide-y">
          {assignments.map((assignment) => (
            <div key={assignment.id} className="p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-4">
                <div className={`p-2 rounded-full ${
                  assignment.type === 'multiple_choice'
                    ? 'bg-blue-100 text-blue-600'
                    : 'bg-purple-100 text-purple-600'
                }`}>
                  {assignment.type === 'multiple_choice' ? (
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
                      <path d="M9 11l3 3L22 4" />
                      <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                    </svg>
                  ) : (
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
                  )}
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2">
                    <h4 className="font-medium">{assignment.title}</h4>
                    <span className={`px-2 py-0.5 text-xs rounded-full ${
                      assignment.status === 'published'
                        ? 'bg-green-100 text-green-700'
                        : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {assignment.status === 'published' ? 'Đã xuất bản' : 'Bản nháp'}
                    </span>
                  </div>
                  <p className="text-sm text-muted-foreground mt-1">{assignment.subject} - {assignment.className}</p>
                  <div className="grid grid-cols-4 gap-4 mt-2 text-sm">
                    <div>
                      <p className="text-muted-foreground">Loại bài tập</p>
                      <p className="font-medium">
                        {assignment.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}
                      </p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Hạn nộp</p>
                      <p className="font-medium">{new Date(assignment.dueDate).toLocaleDateString('vi-VN')}</p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Số câu hỏi</p>
                      <p className="font-medium">
                        {assignment.type === 'multiple_choice' 
                          ? `${assignment.totalQuestions} câu`
                          : 'N/A'}
                      </p>
                    </div>
                    <div>
                      <p className="text-muted-foreground">Đã nộp</p>
                      <p className="font-medium">{assignment.submittedCount}</p>
                    </div>
                  </div>
                </div>
                <Button variant="ghost" size="sm" onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}`)}>
                  Chi tiết
                </Button>
              </div>
            </div>
          ))}

          {assignments.length === 0 && !isLoading && (
            <div className="text-center py-12">
              <p className="text-muted-foreground">Chưa có bài tập nào</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
} 