"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassLectures, deleteLecture, deleteLectureFile, supabase } from "@/lib/supabase"
import SearchFilter from "@/components/search-filter"
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
import { FileIcon, Paperclip, Download } from "lucide-react"

type Lecture = {
  id: string
  title: string
  description: string | null
  created_at: string
  lecture_files: any[]
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
  const [filteredLectures, setFilteredLectures] = useState<Lecture[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null)

  useEffect(() => {
    loadLectures()
  }, [])

  useEffect(() => {
    let filtered = lectures
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(lecture => 
        lecture.title.toLowerCase().includes(query) ||
        (lecture.description && lecture.description.toLowerCase().includes(query)) ||
        lecture.class.name.toLowerCase().includes(query) ||
        lecture.class.subject.name.toLowerCase().includes(query) ||
        (lecture.lecture_files && lecture.lecture_files.some(file => file.original_filename.toLowerCase().includes(query)))
      )
    }
    setFilteredLectures(filtered)
  }, [lectures, searchQuery])

  const handleSearch = (query: string) => {
    setSearchQuery(query)
  }

  async function loadLectures() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }

      const classes = await getTeacherClasses(currentUser.profile.id)
      const allLectures: Lecture[] = []
      for (const classItem of classes) {
        const lecturesData = await getClassLectures(classItem.id)
        const lecturesWithClass = lecturesData.map(l => ({...l, class: classItem }))
        allLectures.push(...lecturesWithClass)
      }

      allLectures.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      setLectures(allLectures)
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải danh sách bài giảng" })
    } finally {
      setIsLoading(false)
    }
  }

  async function handleDeleteLecture(lectureId: string) {
    try {
      const lectureToDelete = lectures.find(l => l.id === lectureId);
      if (lectureToDelete && lectureToDelete.lecture_files) {
          const deletePromises = lectureToDelete.lecture_files.map(file => deleteLectureFile(file.file_path));
          await Promise.all(deletePromises);
      }
      await deleteLecture(lectureId)
      toast({ title: "Thành công", description: "Đã xóa bài giảng" })
      loadLectures()
    } catch (error) {
      console.error('Lỗi khi xóa bài giảng:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể xóa bài giảng" })
    }
  }

  const getPublicUrl = (filePath: string) => {
    const { data } = supabase.storage.from('lectures').getPublicUrl(filePath);
    return data.publicUrl;
  }

  const handleDownload = (filePath: string, fileName: string) => {
    const publicUrl = getPublicUrl(filePath);
    const link = document.createElement('a');
    link.href = publicUrl;
    link.download = fileName;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const getFileTypeLabel = (type: string) => {
    switch (type) {
      case 'VIE': return 'Tiếng Việt';
      case 'ENG': return 'Tiếng Anh';
      case 'SIM': return 'Mô phỏng';
      default: return 'Không xác định';
    }
  }

  if (isLoading) {
    return <div className="p-8 text-center">Đang tải dữ liệu bài giảng...</div>
  }

  return (
    <div className="space-y-8 px-2 sm:px-4 md:px-8 py-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài giảng</h2>
          <p className="text-muted-foreground text-sm sm:text-base">Quản lý tất cả bài giảng của bạn</p>
        </div>
        <div className="flex gap-2">
            <Button onClick={() => router.push("/dashboard/teacher/lectures/create")}>Tạo bài giảng mới</Button>
            <Button variant="outline" onClick={loadLectures}>Làm mới</Button>
        </div>
      </div>

      <SearchFilter
        searchPlaceholder="Tìm kiếm theo tiêu đề, môn học, lớp, tên file..."
        onSearch={(query) => handleSearch(query)}
      />

      <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        {filteredLectures.map((lecture) => (
          <div key={lecture.id} className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-lg">
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div className="flex-1 pr-8">
                  <h4 className="font-semibold line-clamp-2 text-lg">{lecture.title}</h4>
                  <p className="text-sm text-muted-foreground">{lecture.class.name} - {lecture.class.subject.name}</p>
                </div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="icon" className="-mt-2 -mr-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="w-5 h-5"><circle cx="12" cy="12" r="1" /><circle cx="19" cy="12" r="1" /><circle cx="5" cy="12" r="1" /></svg>
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuItem onClick={() => { setSelectedLecture(lecture); setIsDetailDialogOpen(true); }}>Xem chi tiết</DropdownMenuItem>
                    <DropdownMenuItem onClick={() => router.push(`/dashboard/teacher/lectures/${lecture.id}/edit`)}>Chỉnh sửa</DropdownMenuItem>
                    <DropdownMenuItem className="text-red-600" onClick={() => handleDeleteLecture(lecture.id)}>Xóa</DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>

              <p className="mt-3 text-sm text-muted-foreground line-clamp-2 h-10">{lecture.description}</p>

              <div className="mt-4 pt-4 border-t">
                 <div className="flex items-center text-sm text-muted-foreground">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="w-4 h-4 mr-2"><rect width="18" height="18" x="3" y="4" rx="2" ry="2" /><line x1="16" x2="16" y1="2" y2="6" /><line x1="8" x2="8" y1="2" y2="6" /><line x1="3" x2="21" y1="10" y2="10" /></svg>
                    {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                </div>
                <div className="flex items-center gap-2 text-sm text-muted-foreground mt-2">
                    <FileIcon className="h-4 w-4" />
                    <span>{lecture.lecture_files?.length || 0} tệp đính kèm</span>
                </div>
              </div>
            </div>
          </div>
        ))}

        {filteredLectures.length === 0 && !isLoading && (
          <div className="col-span-full text-center py-16 text-muted-foreground">
            <p>{lectures.length === 0 ? "Chưa có bài giảng nào được tạo." : "Không tìm thấy bài giảng phù hợp với tìm kiếm của bạn."}</p>
          </div>
        )}
      </div>

      {selectedLecture && <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="max-w-lg">
            <DialogHeader>
                <DialogTitle className="text-2xl font-bold text-primary">{selectedLecture.title}</DialogTitle>
                <DialogDescription>{selectedLecture.class.name} - {selectedLecture.class.subject.name}</DialogDescription>
            </DialogHeader>
            <div className="space-y-6 py-4 max-h-[70vh] overflow-y-auto pr-2">
                <div className="bg-muted/50 p-4 rounded-lg">
                    <h4 className="text-base font-semibold uppercase tracking-wider text-primary mb-2">Mô tả</h4>
                    <p className="text-sm text-muted-foreground leading-relaxed whitespace-pre-wrap">{selectedLecture.description || "Chưa có mô tả"}</p>
                </div>
                <div className="bg-muted/50 p-4 rounded-lg">
                    <h4 className="text-base font-semibold uppercase tracking-wider text-primary mb-3">Tài liệu đính kèm</h4>
                    <div className="space-y-3">
                        {selectedLecture.lecture_files && selectedLecture.lecture_files.length > 0 ? (
                            selectedLecture.lecture_files.map(file => (
                                <div key={file.id} className="flex items-center justify-between p-3 bg-white border rounded-lg shadow-sm">
                                    <div className="flex items-center gap-4 flex-1 min-w-0">
                                        <Paperclip className="w-6 h-6 text-gray-500 flex-shrink-0" />
                                        <div className="flex-1 min-w-0">
                                            <p className="text-sm font-medium text-gray-800 truncate">{file.original_filename}</p>
                                            <p className="text-xs text-gray-500">Loại: {getFileTypeLabel(file.file_type)}</p>
                                        </div>
                                    </div>
                                    <Button variant="outline" size="sm" onClick={() => handleDownload(file.file_path, file.original_filename)} className="ml-4 flex-shrink-0">
                                        <Download size={14} className="mr-1.5"/>
                                        Tải về
                                    </Button>
                                </div>
                            ))
                        ) : (
                            <p className="text-sm text-muted-foreground text-center py-4">Không có tài liệu nào.</p>
                        )}
                    </div>
                </div>
            </div>
            <DialogFooter>
                <Button variant="outline" onClick={() => setIsDetailDialogOpen(false)}>Đóng</Button>
            </DialogFooter>
        </DialogContent>
      </Dialog>}
    </div>
  )
}