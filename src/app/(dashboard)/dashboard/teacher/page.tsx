"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { 
  getCurrentUser,
  getTeacherStats,
  getTeacherClasses,
  getClassAssignments,
  getClassExams,
  getClassLectures,
  supabase
} from "@/lib/supabase"
import type { Lecture as SupabaseLecture, LectureFile } from "@/lib/supabase"
import { Book, Users, BookOpen, ClipboardList, Download, FileCheck, BookCheck } from "lucide-react"
import { DashboardSkeleton } from "./components/DashboardSkeleton";

// Types
type Stats = {
  totalClasses: number | null
  totalStudents: number | null
  totalLectures: number | null
  totalExams: number | null
  totalAssignmentSubmissions: number | null
  totalExamSubmissions: number | null
}

type UpcomingEvent = {
  id: string
  title: string
  date: string
  type: 'assignment' | 'exam'
}

interface RecentLecture extends SupabaseLecture {
    subject: string;
}

type Exam = {
  id: string
  title: string
  subject: string
  date: string
  duration: number
  status: 'upcoming' | 'in-progress' | 'completed'
}

export default function TeacherDashboardPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [teacherName, setTeacherName] = useState('')
  const [stats, setStats] = useState<Stats>({ 
    totalClasses: null, 
    totalStudents: null, 
    totalLectures: null, 
    totalExams: null,
    totalAssignmentSubmissions: null,
    totalExamSubmissions: null
  })
  const [upcomingEvents, setUpcomingEvents] = useState<UpcomingEvent[]>([])
  const [recentLectures, setRecentLectures] = useState<RecentLecture[]>([])
  const [recentExams, setRecentExams] = useState<Exam[]>([])

  useEffect(() => {
    loadDashboardData()
  }, [])

  const getPublicUrl = (filePath: string) => {
    const { data } = supabase.storage.from('lectures').getPublicUrl(filePath);
    return data.publicUrl;
  }

  const handleDownloadLecture = (file: LectureFile) => {
    try {
        if (!file || !file.file_path) {
            throw new Error("File không hợp lệ");
        }
        const publicUrl = getPublicUrl(file.file_path);
        const link = document.createElement('a');
        link.href = publicUrl;
        link.download = file.original_filename || 'download';
        link.target = '_blank';
        link.rel = 'noopener noreferrer';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    } catch (error: any) {
        toast({ variant: "destructive", title: "Lỗi", description: error.message });
    }
  }

  async function loadDashboardData() {
    setIsLoading(true);
    try {
      const currentUser = await getCurrentUser();
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login');
        return;
      }
      setTeacherName(currentUser.profile.full_name || 'Giảng viên');

      const [teacherStats, classes] = await Promise.all([
        getTeacherStats(currentUser.profile.id),
        getTeacherClasses(currentUser.profile.id)
      ]);

      const assignmentPromises = classes.map(c => getClassAssignments(c.id));
      const examPromises = classes.map(c => getClassExams(c.id));
      const lecturePromises = classes.map(c => getClassLectures(c.id).then(lectures => lectures.map(l => ({...l, subject: c.subject.name}))));

      const [allAssignments, allExams, allLectures] = await Promise.all([
          Promise.all(assignmentPromises).then(res => res.flat()),
          Promise.all(examPromises).then(res => res.flat()),
          Promise.all(lecturePromises).then(res => res.flat()),
      ]);

      let totalAssignmentSubmissions = 0;
      if (allAssignments.length > 0) {
        const { count } = await supabase
          .from('assignment_submissions')
          .select('id', { count: 'exact', head: true })
          .in('assignment_id', allAssignments.map(a => a.id));
        totalAssignmentSubmissions = count ?? 0;
      }

      let totalExamSubmissions = 0;
      if (allExams.length > 0) {
        const { count } = await supabase
          .from('exam_submissions')
          .select('id', { count: 'exact', head: true })
          .in('exam_id', allExams.map(e => e.id));
        totalExamSubmissions = count ?? 0;
      }

      setStats({
        totalClasses: teacherStats.totalClasses,
        totalStudents: teacherStats.totalStudents,
        totalLectures: teacherStats.totalLectures,
        totalExams: teacherStats.totalExams,
        totalAssignmentSubmissions,
        totalExamSubmissions,
      });

      const now = new Date();
      const nextWeek = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
      
      const upcomingAssignments = allAssignments
        .filter(a => new Date(a.due_date) > now && new Date(a.due_date) < nextWeek)
        .map(a => ({ id: a.id, title: a.title, date: a.due_date, type: 'assignment' as const }));

      const upcomingExams = allExams
        .filter(e => new Date(e.start_time) > now && new Date(e.start_time) < nextWeek)
        .map(e => ({ id: e.id, title: e.title, date: e.start_time, type: 'exam' as const }));

      const sortedEvents = [...upcomingAssignments, ...upcomingExams].sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
      setUpcomingEvents(sortedEvents.slice(0, 5));

      const sortedLectures = allLectures.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
      setRecentLectures(sortedLectures.slice(0, 3));

      const sortedExams = allExams.map(e => {
          const classInfo = classes.find(c => c.id === e.class_id);
          return { 
              id: e.id, 
              title: e.title, 
              subject: classInfo?.subject.name || '', 
              date: e.start_time, 
              duration: e.duration, 
              status: e.status 
          };
      }).sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
      setRecentExams(sortedExams.slice(0, 3));

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error);
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải dữ liệu dashboard" });
    } finally {
      setIsLoading(false);
    }
  }

  if (isLoading) {
      return <DashboardSkeleton />
  }

  return (
    <div className="space-y-6 sm:space-y-8">
      <div>
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Xin chào, {teacherName}</h2>
      </div>

      <div className="grid gap-3 sm:gap-4 grid-cols-2 md:grid-cols-3 lg:grid-cols-6">
        <StatCard title="Lớp học" value={stats.totalClasses} icon={Book} color="blue" />
        <StatCard title="Sinh viên" value={stats.totalStudents} icon={Users} color="yellow" />
        <StatCard title="Bài giảng" value={stats.totalLectures} icon={BookOpen} color="green" />
        <StatCard title="Bài kiểm tra" value={stats.totalExams} icon={ClipboardList} color="red" />
        <StatCard title="Bài tập đã nộp" value={stats.totalAssignmentSubmissions} icon={BookCheck} color="purple" />
        <StatCard title="Bài thi đã nộp" value={stats.totalExamSubmissions} icon={FileCheck} color="indigo" />
      </div>

      <div>
        <h3 className="text-lg sm:text-xl font-semibold mb-3 sm:mb-4">Sự kiện sắp tới</h3>
        <div className="rounded-lg sm:rounded-xl border shadow">
            {upcomingEvents.length === 0 ? <p className="p-4 text-center text-muted-foreground">Không có sự kiện nào trong 7 ngày tới.</p> : <div className="divide-y">{upcomingEvents.map(e => <EventCard key={e.id} event={e} />)}</div>}
        </div>
      </div> 

      <div>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-3 sm:mb-4">
          <h3 className="text-lg sm:text-xl font-semibold">Bài giảng gần đây</h3>
          <Button variant="outline" size="sm" onClick={() => router.push('/dashboard/teacher/lectures')} className="w-full sm:w-auto">Xem tất cả</Button>
        </div>
        <div className="grid gap-3 sm:gap-4 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
          {recentLectures.length === 0 ? <div className="col-span-full p-4 text-center text-muted-foreground">Chưa có bài giảng nào.</div> : recentLectures.map((lecture) => <LectureCard key={lecture.id} lecture={lecture} onDownload={handleDownloadLecture} />)}
        </div>
      </div>

      <div>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between mb-3 sm:mb-4">
          <h3 className="text-lg sm:text-xl font-semibold">Bài kiểm tra gần đây</h3>
          <Button variant="outline" size="sm" onClick={() => router.push('/dashboard/teacher/exams/list')} className="w-full sm:w-auto">Xem tất cả</Button>
        </div>
        <div className="rounded-lg sm:rounded-xl border shadow">
            {recentExams.length === 0 ? <p className="p-4 text-center text-muted-foreground">Chưa có bài kiểm tra nào.</p> : <div className="divide-y">{recentExams.map((exam) => <ExamCard key={exam.id} exam={exam} />)}</div>}
        </div>
      </div>
    </div>
  )
}

// Sub-components for cleaner rendering
const StatCard = ({ title, value, icon: Icon, color }: { title: string, value: number | null, icon: React.ElementType, color: string }) => {
    const colorClasses: { [key: string]: string } = {
        blue: 'bg-blue-100 text-blue-600',
        yellow: 'bg-yellow-100 text-yellow-600',
        green: 'bg-green-100 text-green-600',
        red: 'bg-red-100 text-red-600',
        purple: 'bg-purple-100 text-purple-600',
        indigo: 'bg-indigo-100 text-indigo-600',
    };
    const iconBgClass = colorClasses[color] || 'bg-muted';
    const iconColorClass = color ? colorClasses[color].split(' ')[1] : 'text-muted-foreground';

    return (
        <div className="rounded-lg sm:rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg p-4 sm:p-6">
            <div className="flex items-center gap-4">
                <div className={`p-3 rounded-full ${iconBgClass}`}>
                    <Icon className={`w-6 h-6 ${iconColorClass}`} />
                </div>
                <div>
                    <p className="text-sm font-medium text-muted-foreground truncate">{title}</p>
                    <h3 className="text-2xl sm:text-3xl font-bold">{value ?? 0}</h3>
                </div>
            </div>
        </div>
    );
};

const EventCard = ({ event }: { event: UpcomingEvent }) => (
    <div className="p-3 sm:p-4 hover:bg-muted/50 transition-colors flex items-center gap-4">
        <div className="flex-1 min-w-0">
            <h4 className="font-medium text-sm sm:text-base truncate">{event.title}</h4>
            <p className="text-xs sm:text-sm text-muted-foreground mt-1">Hạn chót: {new Date(event.date).toLocaleString('vi-VN')}</p>
        </div>
        <Button variant="secondary" size="sm" asChild><a href={`/dashboard/teacher/${event.type}s`}>Chi tiết</a></Button>
    </div>
);

const LectureCard = ({ lecture, onDownload }: { lecture: RecentLecture, onDownload: (file: LectureFile) => void }) => (
    <div className="rounded-lg sm:rounded-xl border bg-card text-card-foreground shadow transition-all hover:shadow-lg p-4 sm:p-6 flex flex-col">
        <div className="flex-1">
            <h4 className="font-semibold text-base line-clamp-2">{lecture.title}</h4>
            <p className="text-sm text-muted-foreground truncate">{lecture.subject}</p>
            <p className="mt-2 text-sm text-muted-foreground line-clamp-2 h-10">{lecture.description}</p>
        </div>
        <div className="mt-3 pt-3 border-t">
            {lecture.lecture_files?.map(file => (
                <div key={file.id} className="flex items-center justify-between text-sm py-1">
                    <span className="truncate pr-2">{file.original_filename}</span>
                    <Button variant="ghost" size="icon" onClick={() => onDownload(file)}><Download className="w-4 h-4" /></Button>
                </div>
            ))}
        </div>
    </div>
);

const ExamCard = ({ exam }: { exam: Exam }) => (
    <div className="p-3 sm:p-4 hover:bg-muted/50 transition-colors flex items-center gap-4">
        <div className="flex-1 min-w-0">
            <h4 className="font-medium text-sm sm:text-base truncate">{exam.title}</h4>
            <p className="text-xs sm:text-sm text-muted-foreground mt-1">Môn: {exam.subject} | Bắt đầu: {new Date(exam.date).toLocaleString('vi-VN')}</p>
        </div>
        <Button variant="secondary" size="sm" asChild><a href={`/dashboard/teacher/exams/${exam.id}`}>Chi tiết</a></Button>
    </div>
);
