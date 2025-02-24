<<<<<<< HEAD
"use client"

import { useEffect, useState } from "react"
import { useRouter, useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetailsById, ClassDetails } from "@/lib/supabase"

export default function CourseDetailsPage() {
  const router = useRouter()
  const params = useParams()
  const courseId = params.courseId as string
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [courseDetails, setCourseDetails] = useState<ClassDetails | null>(null)

  useEffect(() => {
    loadCourseDetails()
  }, [courseId])

  async function loadCourseDetails() {
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

      const data = await getClassDetailsById(courseId)

      if (data) {
        setCourseDetails(data)
      } else {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Không tìm thấy thông tin lớp học"
        })
        router.push('/dashboard/student/courses')
      }
    } catch (error) {
      console.error('Lỗi khi tải thông tin lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin lớp học"
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!courseDetails) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <h3 className="text-xl font-semibold">Không tìm thấy thông tin lớp học</h3>
        <Button onClick={() => router.back()} className="mt-4">
          Quay lại
        </Button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      

      <div className="flex items-start justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">{courseDetails.name}</h2>
          <div className="mt-2 space-y-1">
            <p className="text-muted-foreground">Mã lớp: {courseDetails.code}</p>
            <p className="text-muted-foreground">Giảng viên: {courseDetails.teacher.full_name}</p>
            <p className="text-muted-foreground">
              {courseDetails.semester} - {courseDetails.academic_year}
            </p>
          </div>
        </div>
        <Button
          variant="outline"
          onClick={() => router.push('/dashboard/student/courses')}
          className="flex items-center h-10"
        >
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
            <path d="m15 18-6-6 6-6"/>
          </svg>
          Quay lại
        </Button>
      </div>

      <Tabs defaultValue="lectures" className="space-y-4">
        <TabsList>
          <TabsTrigger value="lectures">Bài giảng</TabsTrigger>
          <TabsTrigger value="assignments">Bài tập</TabsTrigger>
          <TabsTrigger value="exams">Kiểm tra</TabsTrigger>
        </TabsList>

        <TabsContent value="lectures" className="space-y-4">
          {courseDetails.lectures.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài giảng nào
            </div>
          ) : (
            <div className="grid gap-4">
              {courseDetails.lectures.map((lecture: any) => (
                <div key={lecture.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{lecture.title}</h4>
                    <p className="text-sm text-muted-foreground">{lecture.description}</p>
                    <p className="text-sm text-muted-foreground">
                      Ngày tạo: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                    </p>
                  </div>
                  <Button variant="outline" asChild>
                    <a href={lecture.file_url} target="_blank" rel="noopener noreferrer">
                      Xem bài giảng
                    </a>
                  </Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="assignments" className="space-y-4">
          {courseDetails.assignments.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài tập nào
            </div>
          ) : (
            <div className="grid gap-4">
              {courseDetails.assignments.map((assignment: any) => (
                <div key={assignment.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{assignment.title}</h4>
                    <p className="text-sm text-muted-foreground">{assignment.description}</p>
                    <p className="text-sm text-muted-foreground">
                      Hạn nộp: {new Date(assignment.due_date).toLocaleDateString('vi-VN')}
                    </p>
                  </div>
                  <Button variant="outline">Làm bài</Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="exams" className="space-y-4">
          {courseDetails.exams.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài kiểm tra nào
            </div>
          ) : (
            <div className="grid gap-4">
              {courseDetails.exams.map((exam: any) => (
                <div key={exam.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{exam.title}</h4>
                    <p className="text-sm text-muted-foreground">{exam.description}</p>
                    <p className="text-sm text-muted-foreground">
                      Thời gian: {new Date(exam.start_time).toLocaleString('vi-VN')} - 
                      {new Date(exam.end_time).toLocaleString('vi-VN')}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      Thời lượng: {exam.duration} phút
                    </p>
                  </div>
                  <Button variant="outline">Vào thi</Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>
      </Tabs>
    </div>
  )
}
=======
"use client"

import { useEffect, useState } from "react"
import { useRouter, useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { getCurrentUser, getClassDetails } from "@/lib/supabase"

interface Course {
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
}

interface Assignment {
  id: string
  title: string
  description: string
  due_date: string
  status: string
}

interface Lecture {
  id: string
  title: string
  description: string
  file_url: string
  created_at: string
}

interface Exam {
  id: string
  title: string
  description: string
  start_time: string
  end_time: string
  duration: number
  status: string
}

export default function CourseDetailsPage() {
  const router = useRouter()
  const params = useParams()
  const courseId = params.courseId as string
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [course, setCourse] = useState<Course | null>(null)
  const [assignments, setAssignments] = useState<Assignment[]>([])
  const [lectures, setLectures] = useState<Lecture[]>([])
  const [exams, setExams] = useState<Exam[]>([])

  useEffect(() => {
    loadCourseDetails()
  }, [courseId])

  async function loadCourseDetails() {
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

      const courseData = await getClassDetails(courseId)
      if (courseData && courseData[0]) {
        const classDetails = courseData[0]
        setCourse({
          id: classDetails.id,
          code: classDetails.code,
          name: classDetails.name,
          semester: classDetails.semester,
          academic_year: classDetails.academic_year,
          status: classDetails.status,
          teacher: classDetails.teacher,
          subjects: classDetails.subjects
        })
        
        setLectures(classDetails.lectures || [])
        setAssignments(classDetails.assignments || [])
        setExams(classDetails.exams || [])
      } else {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Không tìm thấy thông tin lớp học"
        })
        router.push('/dashboard/student/courses')
      }
      
    } catch (error) {
      console.error('Lỗi khi tải thông tin lớp học:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin lớp học"
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!course) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[400px]">
        <h3 className="text-xl font-semibold">Không tìm thấy thông tin lớp học</h3>
        <Button onClick={() => router.back()} className="mt-4">
          Quay lại
        </Button>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">{course.name}</h2>
        <div className="mt-2 space-y-1">
          <p className="text-muted-foreground">Mã lớp: {course.code}</p>
          <p className="text-muted-foreground">Giảng viên: {course.teacher.full_name}</p>
          <p className="text-muted-foreground">
            {course.semester} - {course.academic_year}
          </p>
        </div>
      </div>

      <Tabs defaultValue="lectures" className="space-y-4">
        <TabsList>
          <TabsTrigger value="lectures">Bài giảng</TabsTrigger>
          <TabsTrigger value="assignments">Bài tập</TabsTrigger>
          <TabsTrigger value="exams">Kiểm tra</TabsTrigger>
        </TabsList>

        <TabsContent value="lectures" className="space-y-4">
          {lectures.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài giảng nào
            </div>
          ) : (
            <div className="grid gap-4">
              {lectures.map((lecture) => (
                <div key={lecture.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{lecture.title}</h4>
                    <p className="text-sm text-muted-foreground">{lecture.description}</p>
                  </div>
                  <Button variant="outline">Xem bài giảng</Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="assignments" className="space-y-4">
          {assignments.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài tập nào
            </div>
          ) : (
            <div className="grid gap-4">
              {assignments.map((assignment) => (
                <div key={assignment.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{assignment.title}</h4>
                    <p className="text-sm text-muted-foreground">Hạn nộp: {assignment.due_date}</p>
                  </div>
                  <Button variant="outline">Làm bài</Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>

        <TabsContent value="exams" className="space-y-4">
          {exams.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              Chưa có bài kiểm tra nào
            </div>
          ) : (
            <div className="grid gap-4">
              {exams.map((exam) => (
                <div key={exam.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div>
                    <h4 className="font-semibold">{exam.title}</h4>
                    <p className="text-sm text-muted-foreground">
                      Thời gian: {exam.start_time} - {exam.end_time}
                    </p>
                  </div>
                  <Button variant="outline">Vào thi</Button>
                </div>
              ))}
            </div>
          )}
        </TabsContent>
      </Tabs>
    </div>
  )
}
>>>>>>> d1f66ae66c6a5b7f9833d678796267b1c3dff360
