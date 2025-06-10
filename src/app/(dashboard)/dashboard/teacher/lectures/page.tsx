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
  file_url: string
  file_type: string
  file_size: number
  second_file: {
    url: string
    type: string
    size: number
  } | null
  created_at: string
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

export default function TeacherLecturesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null)
  const [currentFileIndex, setCurrentFileIndex] = useState(0)

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
        allLectures.push(...lectures.map(l => {
          const secondFile = parseSecondFileInfo(l.description || '')
          return {
            id: l.id,
            title: l.title,
            description: l.description?.split('\n\nFile thứ hai:')[0] || '',
            file_url: l.file_url,
            file_type: l.file_type,
            file_size: l.file_size,
            second_file: secondFile,
            created_at: l.created_at,
            class: {
              name: classItem.name,
              subject: {
                name: classItem.subject.name
              }
            }
          }
        }))
      }

      // Sắp xếp theo thời gian mới nhất
      allLectures.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
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
      await deleteLecture(lectureId)
      toast({
        title: "Thành công",
        description: "Đã xóa bài giảng"
      })
      loadLectures()
    } catch (error) {
      console.error('Lỗi khi xóa bài giảng:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa bài giảng"
      })
    }
  }

  // Thêm hàm helper để parse thông tin file thứ hai từ description
  function parseSecondFileInfo(description: string) {
    const secondFileMatch = description.match(/File thứ hai:\nURL: (.*?)\nLoại: (.*?)\nKích thước: (\d+) bytes/)
    if (secondFileMatch) {
      return {
        url: secondFileMatch[1],
        type: secondFileMatch[2],
        size: parseInt(secondFileMatch[3])
      }
    }
    return null
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
                  <p className="text-sm text-muted-foreground">
                    {lecture.class.name} - {lecture.class.subject.name}
                  </p>
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
                      setCurrentFileIndex(0)
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
                  {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                </div>
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
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="7 10 12 15 17 10" />
                    <line x1="12" x2="12" y1="15" y2="3" />
                  </svg>
                  {lecture.second_file ? '2 file' : '1 file'}
                </div>
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
              {selectedLecture?.class.name} - {selectedLecture?.class.subject.name}
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
              <div className="flex items-center justify-between mb-4">
                <h4 className="text-sm font-semibold uppercase tracking-wide text-primary">
                  File bài giảng
                </h4>
                {selectedLecture?.second_file && (
                  <div className="flex items-center space-x-2">
                    <Button
                      variant={currentFileIndex === 0 ? "default" : "outline"}
                      size="sm"
                      onClick={() => setCurrentFileIndex(0)}
                    >
                      File 1
                    </Button>
                    <Button
                      variant={currentFileIndex === 1 ? "default" : "outline"}
                      size="sm"
                      onClick={() => setCurrentFileIndex(1)}
                    >
                      File 2
                    </Button>
                  </div>
                )}
              </div>

              <div className="space-y-4">
                <div>
                  <p className="text-muted-foreground">Loại file</p>
                  <p className="font-medium break-all">
                    {currentFileIndex === 0 ? selectedLecture?.file_type : selectedLecture?.second_file?.type}
                  </p>
                </div>
                <div>
                  <p className="text-muted-foreground">Kích thước</p>
                  <p className="font-medium">
                    {currentFileIndex === 0 ? selectedLecture?.file_size : selectedLecture?.second_file?.size} KB
                  </p>
                </div>
                <div className="flex items-center justify-between bg-background p-3 rounded-lg">
                  <div className="flex-1 mr-4">
                    <input
                      type="text"
                      readOnly
                      value={currentFileIndex === 0 ? selectedLecture?.file_url : selectedLecture?.second_file?.url}
                      className="w-full text-sm text-muted-foreground bg-transparent border-none focus:outline-none overflow-x-auto"
                    />
                  </div>
                  <div className="flex items-center space-x-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        const url = currentFileIndex === 0 ? selectedLecture?.file_url : selectedLecture?.second_file?.url;
                        if (url) {
                          navigator.clipboard.writeText(url);
                          toast({
                            title: "Đã sao chép",
                            description: "Link bài giảng đã được sao chép vào clipboard"
                          });
                        }
                      }}
                    >
                      Sao chép
                    </Button>
                    <Button asChild variant="outline">
                      <a
                        href={currentFileIndex === 0 ? selectedLecture?.file_url : selectedLecture?.second_file?.url || '#'}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        Tải xuống
                      </a>
                    </Button>
                  </div>
                </div>
              </div>
            </div>
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