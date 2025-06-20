"use client"

import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getCurrentUser, getTeacherClasses, getClassLectures, deleteLecture, incrementDownloadCount } from "@/lib/supabase"
import SearchFilter, { FilterOption } from "@/components/search-filter"
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
  const [filteredLectures, setFilteredLectures] = useState<Lecture[]>([])
  const [searchQuery, setSearchQuery] = useState("")
  const [filters, setFilters] = useState<Record<string, any>>({})
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null)
  const [currentFileIndex, setCurrentFileIndex] = useState(0)

  // Tạo filter options từ dữ liệu lectures
  const filterOptions: FilterOption[] = useMemo(() => {
    const subjects = [...new Set(lectures.map(l => l.class.subject.name).filter(Boolean))] as string[]
    const classNames = [...new Set(lectures.map(l => l.class.name).filter(Boolean))] as string[]
    const fileTypes = [...new Set(lectures.map(l => l.file_type).filter(Boolean))] as string[]
    
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
        key: 'fileType',
        label: 'Loại file',
        type: 'select',
        options: fileTypes.map(type => ({ value: type, label: type.toUpperCase() }))
      },
      {
        key: 'uploadDate',
        label: 'Ngày tải lên',
        type: 'daterange'
      },
      {
        key: 'fileSize',
        label: 'Kích thước file',
        type: 'select',
        options: [
          { value: '0-1', label: 'Dưới 1MB' },
          { value: '1-10', label: '1-10MB' },
          { value: '10-50', label: '10-50MB' },
          { value: '50+', label: 'Trên 50MB' }
        ]
      },
      {
        key: 'fileCount',
        label: 'Số lượng file',
        type: 'select',
        options: [
          { value: '1', label: '1 file' },
          { value: '2', label: '2 files' },
          { value: '3+', label: '3+ files' }
        ]
      },
      {
        key: 'contentType',
        label: 'Loại nội dung',
        type: 'select',
        options: [
          { value: 'video', label: 'Video (YouTube)' },
          { value: 'document', label: 'Tài liệu' },
          { value: 'mixed', label: 'Hỗn hợp' }
        ]
      },
      {
        key: 'timing',
        label: 'Thời gian',
        type: 'select',
        options: [
          { value: 'today', label: 'Hôm nay' },
          { value: 'this_week', label: 'Tuần này' },
          { value: 'this_month', label: 'Tháng này' },
          { value: 'older', label: 'Cũ hơn' }
        ]
      }
    ]
  }, [lectures])

  useEffect(() => {
    loadLectures()
  }, [])

  // Lọc lectures dựa trên search query và filters
  useEffect(() => {
    let filtered = lectures

    // Tìm kiếm theo text
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(lecture => 
        lecture.title.toLowerCase().includes(query) ||
        lecture.description.toLowerCase().includes(query) ||
        lecture.class.subject.name.toLowerCase().includes(query) ||
        lecture.class.name.toLowerCase().includes(query) ||
        lecture.original_filename?.toLowerCase().includes(query)
      )
    }

    // Áp dụng filters
    Object.entries(filters).forEach(([key, value]) => {
      if (!value || value === "" || (Array.isArray(value) && value.length === 0)) return

      switch (key) {
        case 'subject':
          filtered = filtered.filter(l => l.class.subject.name === value)
          break
        case 'className':
          filtered = filtered.filter(l => l.class.name === value)
          break
        case 'fileType':
          filtered = filtered.filter(l => l.file_type === value)
          break
        case 'uploadDate':
          if (Array.isArray(value) && (value[0] || value[1])) {
            const [startDate, endDate] = value
            filtered = filtered.filter(l => {
              const lectureDate = new Date(l.created_at)
              const start = startDate ? new Date(startDate) : null
              const end = endDate ? new Date(endDate) : null
              
              if (start && end) {
                return lectureDate >= start && lectureDate <= end
              } else if (start) {
                return lectureDate >= start
              } else if (end) {
                return lectureDate <= end
              }
              return true
            })
          }
          break
        case 'fileSize':
          filtered = filtered.filter(l => {
            const sizeMB = l.file_size / (1024 * 1024)
            switch (value) {
              case '0-1':
                return sizeMB < 1
              case '1-10':
                return sizeMB >= 1 && sizeMB <= 10
              case '10-50':
                return sizeMB > 10 && sizeMB <= 50
              case '50+':
                return sizeMB > 50
              default:
                return true
            }
          })
          break
        case 'fileCount':
          filtered = filtered.filter(l => {
            const fileCount = l.file_url.split('|||').length
            switch (value) {
              case '1':
                return fileCount === 1
              case '2':
                return fileCount === 2
              case '3+':
                return fileCount >= 3
              default:
                return true
            }
          })
          break
        case 'contentType':
          filtered = filtered.filter(l => {
            const urls = l.file_url.split('|||')
            const hasVideo = urls.some(url => isYouTubeUrl(url))
            const hasDocument = urls.some(url => !isYouTubeUrl(url))
            
            switch (value) {
              case 'video':
                return hasVideo && !hasDocument
              case 'document':
                return hasDocument && !hasVideo
              case 'mixed':
                return hasVideo && hasDocument
              default:
                return true
            }
          })
          break
        case 'timing':
          filtered = filtered.filter(l => {
            const now = new Date()
            const lectureDate = new Date(l.created_at)
            
            switch (value) {
              case 'today':
                return lectureDate.toDateString() === now.toDateString()
              case 'this_week':
                const weekStart = new Date(now.setDate(now.getDate() - now.getDay()))
                const weekEnd = new Date(weekStart)
                weekEnd.setDate(weekEnd.getDate() + 6)
                return lectureDate >= weekStart && lectureDate <= weekEnd
              case 'this_month':
                return lectureDate.getMonth() === now.getMonth() && lectureDate.getFullYear() === now.getFullYear()
              case 'older':
                const monthAgo = new Date()
                monthAgo.setMonth(monthAgo.getMonth() - 1)
                return lectureDate < monthAgo
              default:
                return true
            }
          })
          break
      }
    })

    setFilteredLectures(filtered)
  }, [lectures, searchQuery, filters])

  const handleSearch = (query: string, newFilters: Record<string, any>) => {
    setSearchQuery(query)
    setFilters(newFilters)
  }

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
      setFilteredLectures(allLectures)

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

  // Hàm xử lý download với tracking
  const handleDownload = async (lecture: Lecture, fileUrl: string, filename?: string) => {
    try {
      // Tăng download count
      const result = await incrementDownloadCount(lecture.id)
      if (result.success) {
        console.log('Download count updated:', result.newCount)
        // Reload lectures để cập nhật UI
        loadLectures()
      }
      
      // Tiến hành download
      window.open(fileUrl, '_blank')
      
      toast({
        title: "Thành công", 
        description: "File đã được mở để tải xuống"
      })
    } catch (error) {
      console.error('Error downloading:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải xuống file"
      })
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

        {/* Lecture Cards Skeleton */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {[...Array(6)].map((_, index) => (
            <div key={index} className="rounded-lg border bg-card text-card-foreground shadow-sm">
              <div className="p-6">
                <div className="flex items-start justify-between">
                  <div className="space-y-2">
                    <div className="h-6 w-48 bg-muted rounded animate-pulse" />
                    <div className="h-4 w-64 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="h-8 w-8 bg-muted rounded animate-pulse" />
                </div>

                <div className="mt-2">
                  <div className="h-4 w-full bg-muted rounded animate-pulse" />
                  <div className="h-4 w-3/4 bg-muted rounded animate-pulse mt-1" />
                </div>

                <div className="mt-4 space-y-2">
                  <div className="flex items-center">
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse mr-2" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse" />
                    <div className="h-4 w-24 bg-muted rounded animate-pulse" />
                    <div className="h-4 w-4 bg-muted rounded-full animate-pulse" />
                    <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    )
  }
  return (
    <div className="space-y-8 px-2 sm:px-4 md:px-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 sm:gap-0">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Bài giảng</h2>
          <p className="text-muted-foreground text-sm sm:text-base">Quản lý tất cả bài giảng của bạn</p>
          <div className="text-xs sm:text-sm text-muted-foreground mt-1">
            Hiển thị {filteredLectures.length} / {lectures.length} bài giảng
          </div>
        </div>
        <div className="flex flex-row xs:flex-row gap-2 w-full sm:w-auto">
          <Button variant="default" onClick={() => router.push("/dashboard/teacher/lectures/create")}
            className="w-full xs:w-auto">
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
            Tạo bài giảng
          </Button>
          {/* <Button onClick={() => router.back()} variant="outline"  className="w-full xs:w-auto">
            Quay lại
          </Button> */}
          <Button variant="outline" onClick={loadLectures} disabled={isLoading} className="w-full xs:w-auto">
            {isLoading ? "Đang tải..." : "Làm mới"}
          </Button>
        </div>
      </div>

      {/* Search and Filter */}
      <SearchFilter
        searchPlaceholder="Tìm kiếm bài giảng..."
        filterOptions={filterOptions}
        onSearch={handleSearch}
      />

      <div className="grid gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        {filteredLectures.map((lecture) => (
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
                    <span>{formatFileSize(lecture.file_size)}</span>
                  </div>
                )}
              </div>
            </div>
          </div>
        ))}

        {filteredLectures.length === 0 && !isLoading && (
          <div className="col-span-full text-center py-12">
            <p className="text-muted-foreground">
              {lectures.length === 0 ? "Chưa có bài giảng nào" : "Không tìm thấy bài giảng phù hợp"}
            </p>
          </div>
        )}
      </div>

      <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="max-w-full sm:max-w-[500px] px-2 sm:px-6 py-4 sm:py-8">
          <DialogHeader>
            <DialogTitle>{selectedLecture?.title}</DialogTitle>
            <DialogDescription>
              {selectedLecture?.class.name} - {selectedLecture?.class.subject.name}
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-6 py-4">
            <div className="bg-muted/50 p-3 sm:p-4 rounded-lg">
              <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                Mô tả
              </h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {selectedLecture?.description || "Chưa có mô tả"}
              </p>
            </div>

            {selectedLecture?.file_url && (
              <div className="space-y-4">
                <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
                  <h3 className="text-base sm:text-lg font-semibold">Tài liệu bài giảng</h3>
                  <div className="flex gap-2 overflow-x-auto pb-1">
                    {selectedLecture.file_url.split('|||').map((url: string, index: number) => (
                      <Button
                        key={index}
                        variant={currentFileIndex === index ? "default" : "outline"}
                        size="sm"
                        onClick={() => setCurrentFileIndex(index)}
                        className="whitespace-nowrap"
                      >
                        {index === 0 ? 'File tiếng Việt (vie)' : index === 1 ? 'File tiếng Anh (eng)' : `File ${index + 1}`}
                      </Button>
                    ))}
                  </div>
                </div>
                <div className="bg-gray-50 rounded-lg p-2 sm:p-4">
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
                        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 p-2 sm:p-4 bg-white rounded-lg border">
                          <div className="flex items-center gap-2 sm:gap-3">
                            <FileIcon className="h-6 w-6 sm:h-8 sm:w-8 text-blue-500" />
                            <div>
                              <p className="font-medium break-all">
                                {selectedLecture.original_filename?.split('|||')[index] || url.split('/').pop()}
                              </p>
                              <p className="text-xs sm:text-sm text-muted-foreground">
                                {index === 0 ? 'Tiếng Việt (vie)' : index === 1 ? 'Tiếng Anh (eng)' : `File ${index + 1}`}
                              </p>
                              <p className="text-xs sm:text-sm text-muted-foreground">
                                {formatFileSize(selectedLecture.file_size / (selectedLecture.file_url.split('|||').length || 1))}
                              </p>
                            </div>
                          </div>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleDownload(selectedLecture, url, selectedLecture.original_filename?.split('|||')[index] || url.split('/').pop())}
                            className="w-full sm:w-auto"
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