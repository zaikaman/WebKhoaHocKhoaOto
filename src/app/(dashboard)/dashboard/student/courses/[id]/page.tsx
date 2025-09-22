"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetailsById, supabase } from "@/lib/supabase"
import { FileIcon, Download, Eye } from "lucide-react"
import type { ClassDetails as SupabaseClassDetails, Lecture as SupabaseLecture, LectureFile } from "@/lib/supabase"
import { Viewer, Worker } from '@react-pdf-viewer/core';
import { defaultLayoutPlugin } from '@react-pdf-viewer/default-layout';
import '@react-pdf-viewer/core/lib/styles/index.css';
import '@react-pdf-viewer/default-layout/lib/styles/index.css';

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
  const [viewingFile, setViewingFile] = useState<{ url: string; type: string; name: string; } | null>(null)
  const defaultLayoutPluginInstance = defaultLayoutPlugin({});


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

  const handleViewFile = (file: LectureFile) => {
    if (!file.file_path || !file.original_filename) {
        toast({ variant: "destructive", title: "Lỗi", description: "File không hợp lệ hoặc không có tên." });
        return;
    }
    const publicUrl = getPublicUrl(file.file_path);
    const fileExtension = file.original_filename.split('.').pop()?.toLowerCase();
    let viewUrl = publicUrl;

    if (fileExtension === 'docx') {
      viewUrl = `https://view.officeapps.live.com/op/embed.aspx?src=${encodeURIComponent(publicUrl)}`;
    } else if (fileExtension !== 'pdf' && fileExtension !== 'html') {
      toast({ variant: "default", title: "Không hỗ trợ", description: "Định dạng file này không hỗ trợ xem trực tiếp." });
      return;
    }

    setViewingFile({ url: viewUrl, type: fileExtension, name: file.original_filename });
  };

  const getFileTypeLabel = (type: string) => {
    switch (type) {
      case 'VIE': return 'Tiếng Việt';
      case 'ENG': return 'Tiếng Anh';
      case 'SIM': return 'Mô phỏng';
      default: return 'Tài liệu';
    }
  }

  const getYouTubeEmbedUrl = (url: string) => {
    if (!url) return null;
    let videoId = null;
    try {
      const urlObj = new URL(url);
      if (urlObj.hostname === 'youtu.be') {
        videoId = urlObj.pathname.slice(1);
      } else if (urlObj.hostname.includes('youtube.com')) {
        videoId = urlObj.searchParams.get('v');
      }
    } catch (e) {
      // Not a valid URL, maybe it's just the ID
      if (url.length === 11) {
        videoId = url;
      }
    }
    
    if (videoId && videoId.length === 11) {
      return `https://www.youtube.com/embed/${videoId}`;
    }
    return null; // Return null if no valid ID was found
  };

  if (isLoading) {
    return (
      <div className="space-y-6 sm:space-y-8 px-2 sm:px-4 md:px-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 sm:gap-0">
          <div>
            <div className="h-8 w-48 bg-muted rounded animate-pulse mb-2" />
            <div className="h-4 w-64 bg-muted rounded animate-pulse" />
          </div>
          <div className="h-9 w-24 bg-muted rounded animate-pulse" />
        </div>
        <div className="space-y-4">
          <div className="flex space-x-4 border-b">
            <div className="h-10 w-24 bg-muted rounded-t-md animate-pulse" />
            <div className="h-10 w-24 bg-muted rounded-t-md animate-pulse" />
            <div className="h-10 w-24 bg-muted rounded-t-md animate-pulse" />
            <div className="h-10 w-24 bg-muted rounded-t-md animate-pulse" />
          </div>
          <div className="space-y-4">
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-4 sm:p-6">
              <div className="h-6 w-1/2 bg-muted rounded animate-pulse mb-4" />
              <div className="h-4 w-full bg-muted rounded animate-pulse mb-2" />
              <div className="h-4 w-3/4 bg-muted rounded animate-pulse" />
            </div>
            <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-4 sm:p-6">
              <div className="h-6 w-1/2 bg-muted rounded animate-pulse mb-4" />
              <div className="h-4 w-full bg-muted rounded animate-pulse mb-2" />
              <div className="h-4 w-3/4 bg-muted rounded animate-pulse" />
            </div>
          </div>
        </div>
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

  const supportedViewExtensions = ['pdf', 'html', 'docx'];

  return (
    <>
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
              <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                  <h3 className="text-lg font-semibold mb-4">Thông tin chi tiết</h3>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                      <div>
                          <p className="text-sm text-muted-foreground">Học kỳ</p>
                          <p className="font-medium">{classData.semester}</p>
                      </div>
                      <div>
                          <p className="text-sm text-muted-foreground">Năm học</p>
                          <p className="font-medium">{classData.academic_year}</p>
                      </div>
                      <div>
                          <p className="text-sm text-muted-foreground">Sĩ số</p>
                          <p className="font-medium">{(classData.enrollments as any)[0]?.count || 0} sinh viên</p>
                      </div>
                  </div>
              </div>
          </TabsContent>

          <TabsContent value="lectures" className="space-y-4">
            {viewingFile ? (
              <div className="space-y-4">
                <Button variant="outline" onClick={() => setViewingFile(null)}>
                  Quay lại danh sách bài giảng
                </Button>
                <div className="rounded-lg border bg-card text-card-foreground shadow-sm">
                  <div className="p-4 border-b">
                    <h3 className="text-lg font-semibold">{viewingFile.name}</h3>
                  </div>
                  <div className="w-full h-[80vh] p-4">
                    {viewingFile.type === 'pdf' ? (
                      <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.11.174/build/pdf.worker.min.js">
                        <Viewer
                          fileUrl={viewingFile.url}
                          plugins={[defaultLayoutPluginInstance]}
                        />
                      </Worker>
                    ) : (
                      <iframe
                        src={viewingFile.url}
                        title={viewingFile.name}
                        width="100%"
                        height="100%"
                        frameBorder="0"
                        className="rounded-md"
                      />
                    )}
                  </div>
                </div>
              </div>
            ) : (
              classData.lectures.length > 0 ? (
                  classData.lectures.map((lecture) => {
                      const videoUrl = getYouTubeEmbedUrl(lecture.video_url || '');
                      return (
                          <div key={lecture.id} className="rounded-lg border bg-card text-card-foreground shadow-sm p-4 sm:p-6">
                              <h4 className="font-semibold text-base sm:text-lg">{lecture.title}</h4>
                              {lecture.description && (
                                  <p className="text-sm text-muted-foreground mt-1 mb-4 line-clamp-3">{lecture.description}</p>
                              )}

                              {videoUrl && (
                                  <div className="aspect-video mt-4">
                                      <iframe
                                          width="100%"
                                          height="100%"
                                          src={videoUrl}
                                          title="YouTube video player"
                                          frameBorder="0"
                                          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                          allowFullScreen
                                          className="rounded-lg"
                                      ></iframe>
                                  </div>
                              )}

                              {(lecture.lecture_files && lecture.lecture_files.length > 0) &&
                                  <div className="space-y-2 mt-3 pt-3 border-t">
                                      {lecture.lecture_files.map(file => {
                                        const fileExtension = file.original_filename ? file.original_filename.split('.').pop()?.toLowerCase() : "";
                                        const canView = supportedViewExtensions.includes(fileExtension || '');
                                        return (
                                          <div key={file.id} className="flex items-center justify-between p-2 bg-muted/50 rounded-md">
                                              <div className="flex items-center gap-3">
                                                  <FileIcon className="h-5 w-5 text-primary" />
                                                  <div>
                                                      <p className="text-sm font-medium">{file.original_filename}</p>
                                                      <p className="text-xs text-muted-foreground">{getFileTypeLabel(file.file_type)}</p>
                                                  </div>
                                              </div>
                                              <div className="flex items-center gap-2">
                                                {canView && (
                                                  <Button variant="outline" size="sm" onClick={() => handleViewFile(file)}>
                                                      <Eye className="h-4 w-4 mr-2" />
                                                      Xem
                                                  </Button>
                                                )}

                                              </div>
                                          </div>
                                        )
                                      })}
                                  </div>
                              }

                              {!videoUrl && (!lecture.lecture_files || lecture.lecture_files.length === 0) &&
                                  <div className="space-y-2 mt-3 pt-3 border-t">
                                      <p className="text-sm text-muted-foreground text-center py-2">Không có tài liệu nào.</p>
                                  </div>
                              }
                              
                              <div className="text-xs text-muted-foreground pt-3 mt-3 border-t">
                                  Ngày đăng: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                              </div>
                          </div>
                      )
                  })
              ) : (
                  <div className="col-span-full text-center py-8 sm:py-12">
                      <div className="text-sm sm:text-base text-muted-foreground">Chưa có bài giảng nào.</div>
                  </div>
              )
            )}
          </TabsContent>

          <TabsContent value="assignments">
              <div className="space-y-4">
                  {classData.assignments && classData.assignments.length > 0 ? (
                  classData.assignments.map((assignment) => {
                    const dueDate = new Date(assignment.due_date);
                    const now = new Date();
                    const diffTime = dueDate.getTime() - now.getTime();
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    const isDueSoon = diffDays <= 3 && diffDays >= 0;

                    return (
                      <div key={assignment.id} className={`rounded-lg border bg-card text-card-foreground shadow-sm p-4 flex items-center justify-between ${isDueSoon ? 'bg-yellow-50' : ''}`}>
                        <div>
                            <h4 className="font-semibold">{assignment.title}</h4>
                            <p className="text-sm text-muted-foreground">{assignment.description}</p>
                            <p className={`text-sm ${isDueSoon ? 'text-red-500 font-bold' : 'text-muted-foreground'}`}>Hạn nộp: {new Date(assignment.due_date).toLocaleString('vi-VN')}</p>
                        </div>
                        <Button onClick={() => router.push(`/dashboard/student/assignments/${assignment.id}`)}>Làm bài</Button>
                      </div>
                    )
                  })
                  ) : (
                  <div className="text-center py-8 text-muted-foreground">
                      Chưa có bài tập nào.
                  </div>
                  )}
              </div>
          </TabsContent>

          <TabsContent value="exams">
              <div className="space-y-4">
                  {classData.exams && classData.exams.length > 0 ? (
                  classData.exams.map((exam) => (
                      <div key={exam.id} className="rounded-lg border bg-card text-card-foreground shadow-sm p-4 flex items-center justify-between">
                      <div>
                          <h4 className="font-semibold">{exam.title}</h4>
                          <p className="text-sm text-muted-foreground">{exam.description}</p>
                          <p className="text-sm text-muted-foreground">Bắt đầu: {new Date(exam.start_time).toLocaleString('vi-VN')}</p>
                          <p className="text-sm text-muted-foreground">Kết thúc: {new Date(exam.end_time).toLocaleString('vi-VN')}</p>
                          <p className="text-sm text-muted-foreground">Thời gian: {exam.duration} phút</p>
                      </div>
                      <Button 
                          onClick={() => router.push(`/dashboard/student/exams/${exam.id}`)}
                          disabled={new Date(exam.start_time) > new Date() || new Date(exam.end_time) < new Date()}
                      >
                          Vào thi
                      </Button>
                      </div>
                  ))
                  ) : (
                  <div className="text-center py-8 text-muted-foreground">
                      Chưa có bài kiểm tra nào.
                  </div>
                  )}
              </div>
          </TabsContent>
        </Tabs>
      </div>
    </>
  )
}
