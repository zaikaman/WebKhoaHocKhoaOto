"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassLectures, deleteLecture } from "@/lib/supabase"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

type Lecture = {
  id: string
  title: string
  description: string
  subject: string
  uploadDate: string
  downloadCount: number
  fileUrl: string
  className: string
  file_type: string
  file_size: number
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
          className: classItem.name,
          file_type: l.file_type,
          file_size: l.file_size
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
          <div key={lecture.id} 
            className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-md"
          >
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div>
                  <h4 className="font-semibold line-clamp-2">{lecture.title}</h4>
                  <p className="text-sm text-muted-foreground">{lecture.subject} - {lecture.className}</p>
                </div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="icon">
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
                        className="w-4 h-4"
                      >
                        <circle cx="12" cy="12" r="1" />
                        <circle cx="19" cy="12" r="1" />
                        <circle cx="5" cy="12" r="1" />
                      </svg>
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => {
                      setSelectedLecture(lecture)
                      setIsDetailDialogOpen(true)
                    }}>
                      Xem chi tiết
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => 
                      router.push(`/dashboard/teacher/lectures/${lecture.id}/edit`)
                    }>
                      Chỉnh sửa
                    </DropdownMenuItem>
                    <DropdownMenuItem
                      className="text-red-600"
                      onClick={() => handleDeleteLecture(lecture.id)}
                    >
                      Xóa
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>

              <p className="mt-2 text-sm text-muted-foreground line-clamp-2">
                {lecture.description}
              </p>

              <div className="mt-4 space-y-2">
                <div className="flex items-center text-sm text-muted-foreground">
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
                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
                    <line x1="16" x2="16" y1="2" y2="6" />
                    <line x1="8" x2="8" y1="2" y2="6" />
                    <line x1="3" x2="21" y1="10" y2="10" />
                  </svg>
                  {new Date(lecture.uploadDate).toLocaleDateString('vi-VN')}
                </div>
                {/* <div className="flex items-center text-sm text-muted-foreground">
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
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="7 10 12 15 17 10" />
                    <line x1="12" x2="12" y1="15" y2="3" />
                  </svg>
                  {lecture.downloadCount} lượt tải
                </div> */}
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
        <DialogContent className="max-w-[500px]">
          <DialogHeader>
            <DialogTitle>{selectedLecture?.title}</DialogTitle>
            <DialogDescription>
              {selectedLecture?.subject} - {selectedLecture?.className}
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-6 py-4">
            <div className="bg-muted/50 p-4 rounded-lg">
              <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                Mô tả
              </h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {selectedLecture?.description || "Chưa có mô tả"}
              </p>
            </div>

            <div className="bg-muted/50 p-4 rounded-lg">
              <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                Thông tin bài giảng
              </h4>
              <div className="grid grid-cols-2 gap-3 text-sm">
                <div>
                  <p className="text-muted-foreground">Loại bài giảng</p>
                  <p className="font-medium break-all">
                    {selectedLecture?.file_type === 'video' ? 'Link video' :
                     selectedLecture?.file_type === 'application/pdf' ? 'PDF' :
                     selectedLecture?.file_type === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ? 'DOCX' :
                     selectedLecture?.file_type === 'application/vnd.openxmlformats-officedocument.presentationml.presentation' ? 'PPTX' :
                     selectedLecture?.file_type}
                  </p>
                </div>
                {selectedLecture?.file_type !== 'video' && (
                  <div>
                    <p className="text-muted-foreground">Kích thước</p>
                    <p className="font-medium">{selectedLecture?.file_size}KB</p>
                  </div>
                )}
                <div>
                  <p className="text-muted-foreground">Ngày tải lên</p>
                  <p className="font-medium">
                    {selectedLecture && new Date(selectedLecture.uploadDate).toLocaleDateString('vi-VN')}
                  </p>
                </div>
              </div>
            </div>

            {selectedLecture?.fileUrl && (
              <div className="flex items-center justify-between bg-muted/50 p-4 rounded-lg">
                <div className="flex-1 mr-4">
                  <h4 className="text-sm font-semibold uppercase tracking-wide text-primary">
                    {selectedLecture.file_type === 'video' ? 'Link video' : 'Tải xuống'}
                  </h4>
                  {selectedLecture.file_type === 'video' ? (
                    <input 
                      type="text"
                      readOnly
                      value={selectedLecture.fileUrl}
                      className="w-full text-sm text-muted-foreground mt-1 bg-transparent border-none focus:outline-none overflow-x-auto"
                    />
                  ) : (
                    <p className="text-sm text-muted-foreground mt-1">
                      Nhấn nút bên để tải file
                    </p>
                  )}
                </div>
                {selectedLecture.file_type === 'video' ? (
                  <Button 
                    variant="outline" 
                    className="hover:bg-primary hover:text-white transition-colors"
                    onClick={() => {
                      navigator.clipboard.writeText(selectedLecture.fileUrl);
                      toast({
                        title: "Đã sao chép",
                        description: "Đã sao chép link video vào clipboard"
                      });
                    }}
                  >
                    Sao chép
                  </Button>
                ) : (
                  <Button asChild variant="outline" className="hover:bg-primary hover:text-white transition-colors">
                    <a
                      href={selectedLecture.fileUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-2"
                    >
                      Tải xuống
                    </a>
                  </Button>
                )}
              </div>
            )}
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDetailDialogOpen(false)}>
              Đóng
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 