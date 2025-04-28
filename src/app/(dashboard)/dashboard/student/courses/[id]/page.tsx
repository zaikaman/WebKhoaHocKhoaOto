"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetailsById } from "@/lib/supabase"

interface Lecture {
  id: string
  title: string
  description: string | null
  file_url: string | null
  file_type: string
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
            {classData.lectures.map((lecture) => (
              <div 
                key={lecture.id}
                className="rounded-lg border bg-card text-card-foreground shadow-sm"
              >
                <div className="p-6 space-y-4">
                  <div>
                    <h4 className="font-semibold">{lecture.title}</h4>
                    {lecture.description && (
                      <p className="text-sm text-muted-foreground mt-1">
                        {lecture.description}
                      </p>
                    )}
                  </div>
                  {lecture.file_url && (
                    <div>
                      {isYoutubeUrl(lecture.file_url) ? (
                        <div className="relative pt-[56.25%]">
                          <iframe
                            className="absolute top-0 left-0 w-full h-full rounded-lg"
                            src={getYoutubeEmbedUrl(lecture.file_url)}
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                          />
                        </div>
                      ) : lecture.file_type === 'application/pdf' ? (
                        <iframe
                          src={lecture.file_url}
                          className="w-full h-[400px] rounded-lg"
                        />
                      ) : (
                        <Button asChild variant="secondary" className="w-full hover:bg-primary hover:text-white transition-colors">
                          <a
                            href={lecture.file_url}
                            target="_blank"
                            rel="noopener noreferrer"
                            download
                            className="flex items-center gap-2"
                          >
                            Tải xuống tài liệu
                          </a>
                        </Button>
                      )}
                    </div>
                  )}
                  <div className="text-sm text-muted-foreground">
                    Ngày đăng: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                  </div>
                </div>
              </div>
            ))}

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
                  <tr key={assignment.id} className="border-t">
                    <td className="py-3 px-4">{assignment.title}</td>
                    <td className="py-3 px-4">{assignment.description || 'Không có mô tả'}</td>
                    <td className="py-3 px-4">{new Date(assignment.due_date).toLocaleDateString('vi-VN')}</td>
                  </tr>
                ))}

                {classData.assignments.length === 0 && (
                  <tr>
                    <td colSpan={3} className="py-8 text-center text-muted-foreground">
                      Chưa có bài tập nào
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </TabsContent>

        <TabsContent value="exams" className="space-y-6">
          <div className="rounded-md border">
            <div className="p-4">
              <Button onClick={() => router.push('/dashboard/student/exams')}>
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
                  <tr key={exam.id} className="border-t">
                    <td className="py-3 px-4">{exam.title}</td>
                    <td className="py-3 px-4">{exam.description?.replace(/<\/?p>/g, '') || 'Không có mô tả'}</td>
                    <td className="py-3 px-4">
                      {new Date(exam.start_time).toLocaleString('vi-VN')}
                    </td>
                    <td className="py-3 px-4">
                      <span className={`px-2.5 py-0.5 rounded-full text-xs font-medium ${
                        exam.status === 'upcoming'
                          ? 'bg-yellow-100 text-yellow-800'
                          : exam.status === 'in-progress'
                          ? 'bg-green-100 text-green-800'
                          : 'bg-gray-100 text-gray-800'
                      }`}>
                        {exam.status === 'upcoming'
                          ? 'Sắp diễn ra'
                          : exam.status === 'in-progress'
                          ? 'Đang diễn ra'
                          : 'Đã kết thúc'}
                      </span>
                    </td>
                  </tr>
                ))}

                {classData.exams.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      Chưa có bài kiểm tra nào
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  )
} 