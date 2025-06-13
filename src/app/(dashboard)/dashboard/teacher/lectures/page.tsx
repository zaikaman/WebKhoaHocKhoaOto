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
import { FileIcon } from "lucide-react"

type Lecture = {
  id: string
  title: string
  description: string
  file_url: string
  file_type: string
  file_size: number
  original_filename: string | null
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
            original_filename: l.original_filename,
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

      // Debug log
      console.log('Loaded lectures with original_filename:', allLectures.map(l => ({
        title: l.title,
        original_filename: l.original_filename
      })))

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

  function isYouTubeUrl(url: string): boolean {
    const youtubePattern = /^https?:\/\/(?:www\.)?youtube\.com\/.*$/;
    return youtubePattern.test(url);
  }

  function getYouTubeEmbedUrl(url: string): string {
    const videoId = url.split('v=')[1] || url.split('/').pop();
    return `https://www.youtube.com/embed/${videoId}`;
  }

  function formatFileSize(size: number): string {
    if (size < 1024) {
      return size + ' bytes';
    } else if (size < 1024 * 1024) {
      return (size / 1024).toFixed(2) + ' KB';
    } else {
      return (size / (1024 * 1024)).toFixed(2) + ' MB';
    }
  }
  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[200px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
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
                {lecture.file_url && (
                  <div className="flex items-center gap-2 text-sm text-muted-foreground">
                    <FileIcon className="h-4 w-4" />
                    <span>{lecture.file_url.split('|||').length} file</span>
                  </div>
                )}
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

            {selectedLecture?.file_url && (
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h3 className="text-lg font-semibold">Tài liệu bài giảng</h3>
                  <div className="flex items-center gap-2">
                    {selectedLecture.file_url.split('|||').map((url: string, index: number) => (
                      <Button
                        key={index}
                        variant={currentFileIndex === index ? "default" : "outline"}
                        size="sm"
                        onClick={() => setCurrentFileIndex(index)}
                      >
                        File {index + 1}
                      </Button>
                    ))}
                  </div>
                </div>
                <div className="bg-gray-50 rounded-lg p-4">
                  {selectedLecture.file_url.split('|||').map((url: string, index: number) => (
                    <div key={index} className={currentFileIndex === index ? 'block' : 'hidden'}>
                      {isYouTubeUrl(url) ? (
                        <div className="aspect-video">
                          <iframe
                            src={getYouTubeEmbedUrl(url)}
                            className="w-full h-full rounded-lg"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                          />
                        </div>
                      ) : (
                        <div className="flex items-center justify-between p-4 bg-white rounded-lg border">
                          <div className="flex items-center gap-3">
                            <FileIcon className="h-8 w-8 text-blue-500" />
                            <div>
                              <p className="font-medium">
                                {selectedLecture.original_filename?.split('|||')[index] || url.split('/').pop()}
                              </p>
                              <p className="text-sm text-muted-foreground">
                                {formatFileSize(selectedLecture.file_size / (selectedLecture.file_url.split('|||').length || 1))}
                              </p>
                            </div>
                          </div>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => window.open(url, '_blank')}
                          >
                            Tải xuống
                          </Button>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
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