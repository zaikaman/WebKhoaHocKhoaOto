"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetailsById } from "@/lib/supabase"
import { FileIcon } from "lucide-react"

interface Lecture {
  id: string
  title: string
  description: string | null
  file_url: string | null
  file_type: string | null
  file_size: number | null
  original_filename: string | null
  created_at: string
}

interface ClassDetails {
  id: string
  code: string
  name: string
  semester: string
  academic_year: string
  status: string
  teacher: {
    id: string
    full_name: string
  }
  subjects: {
    id: string
    name: string
    code: string
    credits: number
  }
  lectures: Lecture[]
  assignments: {
    id: string
    title: string
    description: string | null
    due_date: string
  }[]
  exams: {
    id: string
    title: string
    description: string | null
    start_time: string
    end_time: string
    duration: number
    status: string
  }[]
}

export default function CourseDetailPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [classData, setClassData] = useState<ClassDetails | null>(null)
  const [activeLectureFileIndex, setActiveLectureFileIndex] = useState<{ [key: string]: number }>({})

  useEffect(() => {
    loadClassDetails()
  }, [])

  async function loadClassDetails() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      if (currentUser.profile.role !== 'student') {
        router.push('/dashboard')
        return
      }

      const data = await getClassDetailsById(params.id)
      setClassData(data)
    } catch (error) {
      console.error('Lỗi khi tải thông tin lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin lớp học"
      })
      router.push('/dashboard/student/courses')
    } finally {
      setIsLoading(false)
    }
  }

  function isYoutubeUrl(url: string) {
    return url.includes('youtube.com') || url.includes('youtu.be')
  }

  function getYoutubeEmbedUrl(url: string) {
    const videoId = url.includes('youtube.com') 
      ? url.split('v=')[1]
      : url.split('youtu.be/')[1]
    return `https://www.youtube.com/embed/${videoId}`
  }

  function formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!classData) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy thông tin lớp học</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push('/dashboard/student/courses')}
          >
            Quay lại
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">{classData.subjects.name}</h2>
          <p className="text-muted-foreground mt-2">
            Mã lớp: {classData.code} | Giảng viên: {classData.teacher.full_name}
          </p>
        </div>
        <Button variant="outline" onClick={() => router.push('/dashboard/student/courses')}>
          Quay lại
        </Button>
      </div>

      <Tabs defaultValue="info">
        <TabsList>
          <TabsTrigger value="info">Thông tin chung</TabsTrigger>
          <TabsTrigger value="lectures">Bài giảng</TabsTrigger>
          <TabsTrigger value="assignments">Bài tập</TabsTrigger>
          <TabsTrigger value="exams">Bài kiểm tra</TabsTrigger>
        </TabsList>

        <TabsContent value="info" className="space-y-6">
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
              <h3 className="font-semibold mb-2">Thông tin môn học</h3>
              <div className="space-y-2">
                <p>Mã môn: {classData.subjects.code}</p>
                <p>Tên môn: {classData.subjects.name}</p>
                <p>Số tín chỉ: {classData.subjects.credits}</p>
              </div>
            </div>
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
              <h3 className="font-semibold mb-2">Thông tin lớp học</h3>
              <div className="space-y-2">
                <p>Học kỳ: {classData.semester}</p>
                <p>Năm học: {classData.academic_year}</p>
                <p>Trạng thái: {classData.status === 'active' ? 'Đang diễn ra' : 'Đã kết thúc'}</p>
              </div>
            </div>
          </div>
        </TabsContent>

        <TabsContent value="lectures" className="space-y-6">
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {classData.lectures.map((lecture) => {
              const fileUrls = lecture.file_url?.split('|||') || []
              const fileTypes = lecture.file_type?.split('|||') || []
              const currentFileIdx = activeLectureFileIndex[lecture.id] !== undefined
                ? activeLectureFileIndex[lecture.id]
                : 0;
              const currentFileUrl = fileUrls[currentFileIdx];
              const currentFileType = fileTypes[currentFileIdx];

              return (
                <div 
                  key={lecture.id}
                  className="rounded-lg border bg-card text-card-foreground shadow-sm p-6 space-y-4"
                >
                  <div>
                    <h4 className="font-semibold">{lecture.title}</h4>
                    {lecture.description && (
                      <p className="text-sm text-muted-foreground mt-1 line-clamp-2">
                        {lecture.description}
                      </p>
                    )}
                  </div>

                  {fileUrls.length > 1 && (
                    <div className="flex items-center gap-2 mt-2">
                      {fileUrls.map((_, index) => (
                        <Button
                          key={index}
                          variant={currentFileIdx === index ? "default" : "outline"}
                          size="sm"
                          onClick={() => setActiveLectureFileIndex(prev => ({ ...prev, [lecture.id]: index }))}
                        >
                          File {index + 1}
                        </Button>
                      ))}
                    </div>
                  )}

                  {currentFileUrl ? (
                    <div className="mt-2">
                      {isYoutubeUrl(currentFileUrl) ? (
                        <div className="relative pt-[56.25%]">
                          <iframe
                            className="absolute top-0 left-0 w-full h-full rounded-lg"
                            src={getYoutubeEmbedUrl(currentFileUrl)}
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                          />
                        </div>
                      ) : currentFileType === 'application/pdf' ? (
                        <iframe
                          src={currentFileUrl}
                          className="w-full h-[400px] rounded-lg"
                        />
                      ) : (
                        <Button asChild variant="secondary" className="w-full hover:bg-primary hover:text-white transition-colors">
                          <a
                            href={currentFileUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            download
                            className="flex items-center gap-2"
                          >
                            <FileIcon className="h-4 w-4" />
                            Tải xuống tài liệu
                          </a>
                        </Button>
                      )}
                    </div>
                  ) : (fileUrls.length > 0 && (
                    <div className="text-sm text-muted-foreground mt-2">Không thể hiển thị file này.</div>
                  ))}
                  <div className="text-sm text-muted-foreground">
                    Ngày đăng: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                  </div>
                </div>
              )
            })}

            {classData.lectures.length === 0 && (
              <div className="col-span-full text-center py-12">
                <div className="text-muted-foreground">Chưa có bài giảng nào</div>
              </div>
            )}
          </div>
        </TabsContent>

        <TabsContent value="assignments" className="space-y-6">
          <div className="rounded-md border">
            <div className="p-4">
              <Button onClick={() => router.push('/dashboard/assignments')}>
                Đến trang Bài tập
              </Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">Tiêu đề</th>
                  <th className="py-3 px-4 text-left font-medium">Mô tả</th>
                  <th className="py-3 px-4 text-left font-medium">Hạn nộp</th>
                </tr>
              </thead>
              <tbody>
                {classData.assignments.map((assignment) => (
                  <tr key={assignment.id} className="border-b last:border-0">
                    <td className="py-3 px-4">{assignment.title}</td>
                    <td className="py-3 px-4">{assignment.description}</td>
                    <td className="py-3 px-4">
                      {new Date(assignment.due_date).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>

        <TabsContent value="exams" className="space-y-6">
          <div className="rounded-md border">
            <div className="p-4">
              <Button onClick={() => router.push('/dashboard/exams')}>
                Đến trang Bài kiểm tra
              </Button>
            </div>
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="py-3 px-4 text-left font-medium">Tiêu đề</th>
                  <th className="py-3 px-4 text-left font-medium">Mô tả</th>
                  <th className="py-3 px-4 text-left font-medium">Thời gian</th>
                  <th className="py-3 px-4 text-left font-medium">Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {classData.exams.map((exam) => (
                  <tr key={exam.id} className="border-b last:border-0">
                    <td className="py-3 px-4">{exam.title}</td>
                    <td className="py-3 px-4">{exam.description}</td>
                    <td className="py-3 px-4">
                      {new Date(exam.start_time).toLocaleDateString('vi-VN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                      })} - {new Date(exam.end_time).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}
                    </td>
                    <td className="py-3 px-4">{exam.status === 'active' ? 'Đang diễn ra' : 'Đã kết thúc'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  )
} 