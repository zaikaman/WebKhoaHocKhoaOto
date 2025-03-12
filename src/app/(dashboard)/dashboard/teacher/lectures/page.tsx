"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassLectures, deleteLecture } from "@/lib/supabase"
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"

type Lecture = {
  id: string
  title: string
  description: string
  subject: string
  uploadDate: string
  downloadCount: number
  fileUrl: string
  className: string
}

export default function TeacherLecturesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null)

  useEffect(() => {
    loadLectures()
  }, [])

  async function loadLectures() {
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
      
      // Lấy bài giảng từ tất cả các lớp
      const allLectures: Lecture[] = []
      for (const classItem of classes) {
        const lectures = await getClassLectures(classItem.id)
        allLectures.push(...lectures.map(l => ({
          id: l.id,
          title: l.title,
          description: l.description || '',
          subject: classItem.subject.name,
          uploadDate: l.created_at,
          downloadCount: l.download_count,
          fileUrl: l.file_url,
          className: classItem.name
        })))
      }

      // Sắp xếp theo thời gian mới nhất
      allLectures.sort((a, b) => new Date(b.uploadDate).getTime() - new Date(a.uploadDate).getTime())
      setLectures(allLectures)

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách bài giảng"
      })
    } finally {
      setIsLoading(false)
    }
  }

  async function handleDeleteLecture(lectureId: string) {
    try {
      const { error } = await deleteLecture(lectureId);
      if (error) throw error;
      setLectures(lectures.filter(l => l.id !== lectureId));
      toast({
        title: "Thành công",
        description: "Bài giảng đã được xóa thành công"
      });
    } catch (error) {
      console.error('Lỗi khi xóa bài giảng:', error);
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa bài giảng"
      });
    }
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Bài giảng</h2>
          <p className="text-muted-foreground">Quản lý tất cả bài giảng của bạn</p>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="default" onClick={() => router.push("/dashboard/teacher/lectures/create")}>
            Tạo bài giảng
          </Button>
          <Button onClick={() => router.back()}>
            Quay lại
          </Button>
          <Button variant="outline" onClick={loadLectures} disabled={isLoading}>
            {isLoading ? "Đang tải..." : "Làm mới"}
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {lectures.map((lecture) => (
          <div key={lecture.id} className="rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg">
            <div className="p-6">
              <div className="space-y-1">
                <h4 className="font-semibold line-clamp-2">{lecture.title}</h4>
                <p className="text-sm text-muted-foreground">{lecture.subject} - {lecture.className}</p>
              </div>
              <p className="mt-2 text-sm text-muted-foreground line-clamp-2">
                {lecture.description}
              </p>
              <div className="mt-4 flex items-center justify-between text-sm text-muted-foreground">
                <p>Ngày tải lên: {new Date(lecture.uploadDate).toLocaleDateString('vi-VN')}</p>
                <p>{lecture.downloadCount} lượt tải</p>
              </div>
              <div className="mt-2 flex items-center gap-2">
                <Button size="sm" onClick={() => {
                  setSelectedLecture(lecture);
                  setIsDetailDialogOpen(true);
                }}>
                  Xem chi tiết
                </Button>
                <Button size="sm" onClick={() => router.push(`/dashboard/teacher/lectures/${lecture.id}/edit`)}>
                  Chỉnh sửa
                </Button>
                <Button size="sm" variant="destructive" onClick={() => handleDeleteLecture(lecture.id)}>
                  Xóa
                </Button>
              </div>
            </div>
          </div>
        ))}

        {lectures.length === 0 && !isLoading && (
          <div className="col-span-full text-center py-12">
            <p className="text-muted-foreground">Chưa có bài giảng nào</p>
          </div>
        )}
      </div>

      <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="max-w-[500px] p-4">
          <DialogHeader>
            <DialogTitle>{selectedLecture?.title}</DialogTitle>
            <p className="text-sm text-muted-foreground">{selectedLecture?.subject} - {selectedLecture?.className}</p>
          </DialogHeader>
          <div className="mt-4">
            <p>{selectedLecture?.description}</p>
            <p className="mt-2 text-sm text-muted-foreground">
              Ngày tải lên: {selectedLecture ? new Date(selectedLecture.uploadDate).toLocaleDateString('vi-VN') : ''}
            </p>
            <p className="text-sm text-muted-foreground">{selectedLecture?.downloadCount} lượt tải</p>
            {selectedLecture?.fileUrl && (
              <p className="mt-2"><a href={selectedLecture.fileUrl} target="_blank" rel="noreferrer" className="text-blue-500 underline">Xem file bài giảng</a></p>
            )}
          </div>
          <DialogFooter className="flex justify-end pt-4">
            <Button onClick={() => setIsDetailDialogOpen(false)}>Đóng</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 