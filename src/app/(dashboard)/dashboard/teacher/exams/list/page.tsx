"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { getCurrentUser, getTeacherClasses, getClassExams, deleteExam, supabase } from "@/lib/supabase"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

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
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [isEditTitleDialogOpen, setIsEditTitleDialogOpen] = useState(false)
  const [currentExamId, setCurrentExamId] = useState<string | null>(null)
  const [editTitle, setEditTitle] = useState('')
  const [editStartTime, setEditStartTime] = useState('')
  const [editEndTime, setEditEndTime] = useState('')
  const [editDuration, setEditDuration] = useState('')

  useEffect(() => {
    loadExams()
  }, [])

  async function loadExams() {
    try {
      setIsLoading(true)
      
      // Lấy thông tin người dùng hiện tại
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      // Lấy danh sách lớp học
      const classes = await getTeacherClasses(currentUser.profile.id)
      
      // Lấy bài kiểm tra từ tất cả các lớp
      const allExams: Exam[] = []
      for (const classItem of classes) {
        const exams = await getClassExams(classItem.id)
        allExams.push(...exams.map(e => ({
          id: e.id,
          title: e.title,
          subject: classItem.subject.name,
          className: classItem.name,
          start_time: e.start_time,
          end_time: e.end_time,
          duration: e.duration,
          totalStudents: 0, // TODO: Implement later
          submittedCount: 0, // TODO: Implement later
          averageScore: null, // TODO: Implement later
          status: e.status
        })))
      }

      // Sắp xếp theo thời gian mới nhất
      allExams.sort((a, b) => new Date(b.start_time).getTime() - new Date(a.start_time).getTime())
      setExams(allExams)

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
        
        // Format datetime-local string (YYYY-MM-DDTHH:mm)
        setEditStartTime(new Date(exam.start_time).toLocaleString('sv').replace(' ', 'T').slice(0, 16))
        setEditEndTime(new Date(exam.end_time).toLocaleString('sv').replace(' ', 'T').slice(0, 16))
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
      // Chuyển đổi thời gian local thành UTC
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

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Bài kiểm tra</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài kiểm tra của bạn</p>
        </div>
        <div className="flex items-center gap-2">
          <Button onClick={() => router.push('/dashboard/teacher/exams')}>
            Tạo bài kiểm tra
          </Button>
          <Button onClick={() => router.back()}>
            Quay lại
          </Button>
          <Button variant="outline" onClick={loadExams} disabled={isLoading}>
            {isLoading ? "Đang tải..." : "Làm mới"}
          </Button>
        </div>
      </div>

      <div className="rounded-xl border shadow">
        <div className="divide-y">
          {exams.map((exam) => (
            <div key={exam.id} className="p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-4">
                <div className={`p-2 rounded-full ${
                  exam.status === 'completed'
                    ? 'bg-green-100 text-green-600'
                    : exam.status === 'in-progress'
                    ? 'bg-blue-100 text-blue-600'
                    : 'bg-orange-100 text-orange-600'
                }`}>
                  {exam.status === 'completed' ? (
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M20 6 9 17l-5-5" />
                    </svg>
                  ) : exam.status === 'in-progress' ? (
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M12 2v4" />
                      <path d="M12 18v4" />
                      <path d="M4.93 4.93l2.83 2.83" />
                      <path d="M16.24 16.24l2.83 2.83" />
                      <path d="M2 12h4" />
                      <path d="M18 12h4" />
                      <path d="M4.93 19.07l2.83-2.83" />
                      <path d="M16.24 7.76l2.83-2.83" />
                    </svg>
                  ) : (
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M12 8v4l3 3" />
                      <circle cx="12" cy="12" r="10" />
                    </svg>
                  )}
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2">
                    <h4 className="font-medium">{exam.title}</h4>
                    <span className={`px-2 py-0.5 text-xs rounded-full ${
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
                        {new Date(exam.start_time).toLocaleString('vi-VN', { 
                          year: 'numeric',
                          month: '2-digit',
                          day: '2-digit',
                          hour: '2-digit',
                          minute: '2-digit',
                          hour12: true
                        })} - {new Date(exam.end_time).toLocaleString('vi-VN', {
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
                <Button variant="ghost" size="sm" onClick={() => handleEdit(exam.id)}>
                  Chỉnh sửa
                </Button>
                <Button variant="destructive" size="sm" onClick={() => handleDeleteExam(exam.id)}>
                  Xóa
                </Button>
              </div>
            </div>
          ))}

          {exams.length === 0 && !isLoading && (
            <div className="text-center py-12">
              <p className="text-muted-foreground">Chưa có bài kiểm tra nào</p>
            </div>
          )}
        </div>
      </div>

      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Chọn hành động chỉnh sửa</DialogTitle>
          </DialogHeader>
          <DialogFooter>
            <Button onClick={() => handleEditChoice('info')}>Chỉnh sửa thông tin</Button>
            <Button onClick={() => handleEditChoice('question')}>Chỉnh sửa câu hỏi</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isEditTitleDialogOpen} onOpenChange={setIsEditTitleDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Chỉnh sửa thông tin bài kiểm tra</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="edit-title">Tiêu đề</Label>
              <Input
                id="edit-title"
                value={editTitle}
                onChange={(e) => setEditTitle(e.target.value)}
                placeholder="Nhập tiêu đề"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-start-time">Thời gian bắt đầu</Label>
              <Input
                id="edit-start-time"
                type="datetime-local"
                value={editStartTime}
                onChange={(e) => setEditStartTime(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-end-time">Thời gian kết thúc</Label>
              <Input
                id="edit-end-time"
                type="datetime-local"
                value={editEndTime}
                onChange={(e) => setEditEndTime(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-duration">Thời gian làm bài (phút)</Label>
              <Input
                id="edit-duration"
                type="number"
                min="1"
                value={editDuration}
                onChange={(e) => setEditDuration(e.target.value)}
                placeholder="Nhập thời gian làm bài"
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsEditTitleDialogOpen(false)}>
              Hủy
            </Button>
            <Button onClick={handleUpdateInfo} disabled={isLoading}>
              {isLoading ? "Đang cập nhật..." : "Cập nhật"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 
