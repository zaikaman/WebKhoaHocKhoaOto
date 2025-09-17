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
import { FileIcon, Paperclip, Download, Plus, RefreshCw, MoreHorizontal, Calendar, Users } from "lucide-react"
import { LectureListSkeleton } from "../components/LectureListSkeleton";

type Lecture = {
  id: string
  title: string
  description: string | null
  video_url: string | null
  created_at: string
  lecture_files: any[]
  class: {
    id: string;
    name: string
    subject: {
      name: string
    }
  }
}

type GroupedLecture = {
  title: string;
  description: string | null;
  createdAt: string;
  classes: Array<{
    id: string;
    lectureId: string;
    className: string;
    subjectName: string;
    video_url: string | null;
    description: string | null;
    created_at: string;
    lecture_files: any[];
  }>;
  totalFiles: number;
}

export default function TeacherLecturesPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [groupedLectures, setGroupedLectures] = useState<GroupedLecture[]>([])
  const [filteredLectures, setFilteredLectures] = useState<GroupedLecture[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedGroup, setSelectedGroup] = useState<GroupedLecture | null>(null)

  useEffect(() => {
    loadLectures()
  }, [])

  useEffect(() => {
    let filtered = groupedLectures
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(group => 
        group.title.toLowerCase().includes(query) ||
        (group.description && group.description.toLowerCase().includes(query)) ||
        group.classes.some(c => c.className.toLowerCase().includes(query) || c.subjectName.toLowerCase().includes(query))
      )
    }
    setFilteredLectures(filtered)
  }, [groupedLectures, searchQuery])

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

      const grouped = allLectures.reduce((acc, lecture) => {
        const { title, description, created_at, class: classInfo, id, video_url, lecture_files } = lecture;
        if (!acc[title]) {
          acc[title] = {
            title,
            description,
            createdAt: created_at,
            classes: [],
            totalFiles: 0,
          };
        }
        acc[title].classes.push({
          id: classInfo.id,
          lectureId: id,
          className: classInfo.name,
          subjectName: classInfo.subject.name,
          video_url,
          description,
          created_at,
          lecture_files,
        });
        acc[title].totalFiles += lecture_files.length;
        
        // Sort classes by creation date, newest first
        acc[title].classes.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
        // Update group's created date to the newest one
        if (new Date(created_at) > new Date(acc[title].createdAt)) {
            acc[title].createdAt = created_at;
        }

        return acc;
      }, {} as Record<string, GroupedLecture>);

      const groupedArray = Object.values(grouped).sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
      setGroupedLectures(groupedArray);
      setFilteredLectures(groupedArray);

      toast({ title: "Đã làm mới", description: "Dữ liệu bài giảng đã được cập nhật." })
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
      loadLectures() // Reload all data
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

  const getYouTubeEmbedUrl = (url: string | null) => {
    if (!url) return null;
    let videoId = '';
    const regex = new RegExp('(?:https?://)?(?:www\.)?(?:youtube\.com/(?:[^/\n\s]+/\S+/|(?:v|e(?:mbed)?)/|\S*?[?&]v=)|youtu\.be/)([a-zA-Z0-9_-]{11})');
    const match = url.match(regex);
    if (match) {
      videoId = match[1];
    } else {
      if (url.length === 11) {
        videoId = url;
      } else {
        return null;
      }
    }
    return `https://www.youtube.com/embed/${videoId}`;
  };

  if (isLoading) {
    return <LectureListSkeleton />;
  }

  return (
    <div className="space-y-8 px-2 sm:px-4 md:px-8 py-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài giảng</h2>
          <p className="text-muted-foreground text-sm sm:text-base">Quản lý tất cả bài giảng của bạn</p>
        </div>
        <div className="flex gap-2">
            <Button variant="outline" onClick={loadLectures}>
                <RefreshCw className="w-4 h-4 mr-2" />
                Làm mới
            </Button>
            <Button onClick={() => router.push("/dashboard/teacher/lectures/create")}>
                <Plus className="w-4 h-4 mr-2" />
                Tạo bài giảng mới
            </Button>
        </div>
      </div>

      <SearchFilter
        searchPlaceholder="Tìm kiếm theo tiêu đề, môn học, lớp..."
        onSearch={(query) => handleSearch(query)}
      />

      <div className="grid gap-6 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        {filteredLectures.map((group) => (
          <div key={group.title} className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-lg">
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div className="flex-1 pr-8">
                  <h4 className="font-semibold line-clamp-2 text-lg">{group.title}</h4>
                  <p className="text-sm text-muted-foreground line-clamp-1">
                    {group.classes.map(c => c.subjectName).join(', ')}
                  </p>
                </div>
                <Button variant="ghost" size="icon" className="-mt-2 -mr-2" onClick={() => { setSelectedGroup(group); setIsDetailDialogOpen(true); }}>
                    <MoreHorizontal className="w-5 h-5" />
                </Button>
              </div>

              <p className="mt-3 text-sm text-muted-foreground line-clamp-2 h-10">{group.description}</p>

              <div className="mt-4 pt-4 border-t">
                 <div className="flex items-center text-sm text-muted-foreground">
                    <Calendar className="w-4 h-4 mr-2" />
                    Ngày tạo mới nhất: {new Date(group.createdAt).toLocaleDateString('vi-VN')}
                </div>
                <div className="flex items-center gap-2 text-sm text-muted-foreground mt-2">
                    <Users className="h-4 w-4" />
                    <span>{group.classes.length} lớp học</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-muted-foreground mt-2">
                    <FileIcon className="h-4 w-4" />
                    <span>{group.totalFiles} tệp đính kèm</span>
                </div>
              </div>
            </div>
          </div>
        ))}

        {filteredLectures.length === 0 && !isLoading && (
          <div className="col-span-full text-center py-16 text-muted-foreground">
            <p>{groupedLectures.length === 0 ? "Chưa có bài giảng nào được tạo." : "Không tìm thấy bài giảng phù hợp với tìm kiếm của bạn."}</p>
          </div>
        )}
      </div>

      {selectedGroup && <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="max-w-2xl">
            <DialogHeader>
                <DialogTitle className="text-2xl font-bold text-primary">{selectedGroup.title}</DialogTitle>
                <DialogDescription>Chi tiết bài giảng cho từng lớp</DialogDescription>
            </DialogHeader>
            <div className="space-y-6 py-4 max-h-[70vh] overflow-y-auto pr-2">
              {selectedGroup.classes.map(lecture => (
                <div key={lecture.lectureId} className="bg-muted/50 p-4 rounded-lg">
                  <div className="flex justify-between items-start">
                    <div>
                      <h4 className="text-base font-semibold text-primary">{lecture.className} - {lecture.subjectName}</h4>
                      <p className="text-sm text-muted-foreground">Ngày tạo: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}</p>
                    </div>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon">
                            <MoreHorizontal className="w-5 h-5" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => router.push(`/dashboard/teacher/lectures/${lecture.lectureId}/edit`)}>Chỉnh sửa</DropdownMenuItem>
                        <DropdownMenuItem className="text-red-600" onClick={() => handleDeleteLecture(lecture.lectureId)}>Xóa</DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>

                  {getYouTubeEmbedUrl(lecture.video_url) && (
                    <div className="aspect-video mt-4">
                      <iframe
                        width="100%"
                        height="100%"
                        src={getYouTubeEmbedUrl(lecture.video_url)!}
                        title="YouTube video player"
                        frameBorder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowFullScreen
                      ></iframe>
                    </div>
                  )}
                  <div className="mt-4">
                      <p className="text-sm text-muted-foreground leading-relaxed whitespace-pre-wrap">{lecture.description || "Chưa có mô tả"}</p>
                  </div>
                  
                  {lecture.lecture_files && lecture.lecture_files.length > 0 && (
                    <div className="mt-4">
                        <h5 className="text-sm font-semibold uppercase tracking-wider text-primary mb-3">Tài liệu</h5>
                        <div className="space-y-3">
                            {lecture.lecture_files.map(file => (
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
                            ))}
                        </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
            <DialogFooter>
                <Button variant="outline" onClick={() => setIsDetailDialogOpen(false)}>Đóng</Button>
            </DialogFooter>
        </DialogContent>
      </Dialog>}
    </div>
  )
}
