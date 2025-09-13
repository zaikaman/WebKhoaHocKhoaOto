"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetailsById, supabase } from "@/lib/supabase"
import { FileIcon, Download } from "lucide-react"
import type { ClassDetails as SupabaseClassDetails, Lecture as SupabaseLecture, LectureFile } from "@/lib/supabase"

// Use the types from supabase lib and extend if necessary
interface Lecture extends SupabaseLecture {}
interface ClassDetails extends Omit<SupabaseClassDetails, 'lectures'> {
  lectures: Lecture[];
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
      setClassData(data as ClassDetails)
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

  const getPublicUrl = (filePath: string) => {
    const { data } = supabase.storage.from('lectures').getPublicUrl(filePath);
    return data.publicUrl;
  }

  const handleDownload = (file: LectureFile) => {
    try {
      const publicUrl = getPublicUrl(file.file_path);
      const link = document.createElement('a');
      link.href = publicUrl;
      link.download = file.original_filename || 'download';
      link.target = '_blank';
      link.rel = 'noopener noreferrer';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      toast({ title: "Thành công", description: "Tài liệu đang được tải xuống." });
    } catch (error) {
      console.error('Error downloading:', error);
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải xuống file" });
    }
  };

  const getFileTypeLabel = (type: string) => {
    switch (type) {
      case 'VIE': return 'Tiếng Việt';
      case 'ENG': return 'Tiếng Anh';
      case 'SIM': return 'Mô phỏng';
      default: return 'Tài liệu';
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[200px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!classData) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy thông tin lớp học</h2>
          <Button className="mt-4" onClick={() => router.push('/dashboard/student/courses')}>Quay lại</Button>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6 sm:space-y-8 px-2 sm:px-4 md:px-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 sm:gap-0">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Môn học : {classData.subjects.name}</h2>
          <p className="text-xs sm:text-sm text-muted-foreground mt-2">
            Mã lớp: {classData.code} | Giảng viên: {classData.teacher.full_name}
          </p>
        </div>
        <Button variant="outline" onClick={() => router.push('/dashboard/student/courses')} className="text-xs sm:text-sm px-3 sm:px-4 py-1.5 sm:py-2">
          Quay lại
        </Button>
      </div>

      <Tabs defaultValue="lectures">
        <TabsList>
          <TabsTrigger value="info">Thông tin</TabsTrigger>
          <TabsTrigger value="lectures">Bài giảng</TabsTrigger>
          <TabsTrigger value="assignments">Bài tập</TabsTrigger>
          <TabsTrigger value="exams">Bài kiểm tra</TabsTrigger>
        </TabsList>

        <TabsContent value="info" className="space-y-6">
            {/* Info Tab Content Here */}
        </TabsContent>

        <TabsContent value="lectures" className="space-y-4">
            {classData.lectures.length > 0 ? (
                classData.lectures.map((lecture) => (
                    <div key={lecture.id} className="rounded-lg border bg-card text-card-foreground shadow-sm p-4 sm:p-6">
                        <h4 className="font-semibold text-base sm:text-lg">{lecture.title}</h4>
                        {lecture.description && (
                            <p className="text-sm text-muted-foreground mt-1 mb-4 line-clamp-3">{lecture.description}</p>
                        )}
                        <div className="space-y-2 mt-3 pt-3 border-t">
                            {lecture.lecture_files && lecture.lecture_files.length > 0 ? (
                                lecture.lecture_files.map(file => (
                                    <div key={file.id} className="flex items-center justify-between p-2 bg-muted/50 rounded-md">
                                        <div className="flex items-center gap-3">
                                            <FileIcon className="h-5 w-5 text-primary" />
                                            <div>
                                                <p className="text-sm font-medium">{file.original_filename}</p>
                                                <p className="text-xs text-muted-foreground">{getFileTypeLabel(file.file_type)}</p>
                                            </div>
                                        </div>
                                        <Button variant="secondary" size="sm" onClick={() => handleDownload(file)}>
                                            <Download className="h-4 w-4 mr-2" />
                                            Tải về
                                        </Button>
                                    </div>
                                ))
                            ) : (
                                <p className="text-sm text-muted-foreground text-center py-2">Không có file đính kèm.</p>
                            )}
                        </div>
                        <div className="text-xs text-muted-foreground pt-3 mt-3 border-t">
                            Ngày đăng: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                        </div>
                    </div>
                ))
            ) : (
                <div className="col-span-full text-center py-8 sm:py-12">
                    <div className="text-sm sm:text-base text-muted-foreground">Chưa có bài giảng nào.</div>
                </div>
            )}
        </TabsContent>

        <TabsContent value="assignments">
            {/* Assignments Tab Content Here */}
        </TabsContent>

        <TabsContent value="exams">
            {/* Exams Tab Content Here */}
        </TabsContent>
      </Tabs>
    </div>
  )
}