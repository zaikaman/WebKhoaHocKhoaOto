import { Metadata } from "next"
import { Button } from "@/components/ui/button"
import Link from "next/link"
import Image from "next/image"

export const metadata: Metadata = {
  title: "Khóa học - Khoa Công nghệ Ô tô",
  description: "Danh sách các khóa học chuyên ngành Công nghệ Ô tô",
}

const courses = [
  {
    id: 1,
    title: "Nguyên lý động cơ ô tô",
    instructor: "TS. Nguyễn Văn A",
    description: "Tìm hiểu về cấu tạo và nguyên lý hoạt động của động cơ ô tô hiện đại.",
    progress: 60,
    totalLessons: 12,
    completedLessons: 7,
    image: "https://source.unsplash.com/random/800x600?car-engine",
  },
  {
    id: 2,
    title: "Hệ thống điện ô tô",
    instructor: "ThS. Trần Thị B",
    description: "Nghiên cứu về hệ thống điện và điện tử trong ô tô, từ cơ bản đến nâng cao.",
    progress: 30,
    totalLessons: 10,
    completedLessons: 3,
    image: "https://source.unsplash.com/random/800x600?car-electrical",
  },
  {
    id: 3,
    title: "Chẩn đoán và sửa chữa ô tô",
    instructor: "PGS.TS. Lê Văn C",
    description: "Phương pháp chẩn đoán và sửa chữa các hệ thống trên ô tô hiện đại.",
    progress: 80,
    totalLessons: 15,
    completedLessons: 12,
    image: "https://source.unsplash.com/random/800x600?car-repair",
  },
  {
    id: 4,
    title: "Công nghệ ô tô điện",
    instructor: "TS. Phạm Thị D",
    description: "Tìm hiểu về công nghệ ô tô điện và xu hướng phát triển trong tương lai.",
    progress: 40,
    totalLessons: 14,
    completedLessons: 6,
    image: "https://source.unsplash.com/random/800x600?electric-car",
  },
  {
    id: 5,
    title: "Hệ thống truyền động ô tô",
    instructor: "ThS. Hoàng Văn E",
    description: "Cấu tạo và nguyên lý hoạt động của hệ thống truyền động trên ô tô.",
    progress: 70,
    totalLessons: 12,
    completedLessons: 8,
    image: "https://source.unsplash.com/random/800x600?car-transmission",
  },
  {
    id: 6,
    title: "An toàn và tiện nghi ô tô",
    instructor: "TS. Vũ Thị F",
    description: "Các hệ thống an toàn và tiện nghi trên ô tô hiện đại.",
    progress: 50,
    totalLessons: 10,
    completedLessons: 5,
    image: "https://source.unsplash.com/random/800x600?car-safety",
  },
]

export default function CoursesPage() {
  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Khóa học chuyên ngành</h2>
          <p className="text-muted-foreground">
            Danh sách các môn học chuyên ngành Công nghệ Ô tô
          </p>
        </div>
        <div className="flex items-center gap-4">
          <Button variant="outline">
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
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
              <polyline points="7 10 12 15 17 10" />
              <line x1="12" x2="12" y1="15" y2="3" />
            </svg>
            Xuất danh sách
          </Button>
          <Button>
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
            Đăng ký môn học mới
          </Button>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {courses.map((course) => (
          <Link
            href={`/dashboard/courses/${course.id}`}
            key={course.id}
            className="group relative rounded-lg border bg-card text-card-foreground shadow-sm transition-all hover:shadow-md"
          >
            <div className="relative aspect-video overflow-hidden rounded-t-lg">
              <div className="absolute inset-0 bg-black/20 transition-opacity group-hover:opacity-0" />
              <Image
                src={course.image}
                alt={course.title}
                fill
                className="object-cover transition-transform group-hover:scale-105"
              />
            </div>
            <div className="p-6">
              <h3 className="text-lg font-semibold group-hover:text-primary transition-colors">
                {course.title}
              </h3>
              <p className="text-sm text-muted-foreground mt-1">
                Giảng viên: {course.instructor}
              </p>
              <p className="text-sm text-muted-foreground mt-2">
                {course.description}
              </p>
              <div className="mt-4">
                <div className="flex justify-between text-sm text-muted-foreground mb-2">
                  <span>Tiến độ</span>
                  <span>{course.progress}%</span>
                </div>
                <div className="h-2 bg-secondary rounded-full overflow-hidden">
                  <div
                    className="h-full bg-primary transition-all"
                    style={{ width: `${course.progress}%` }}
                  />
                </div>
                <p className="text-sm text-muted-foreground mt-2">
                  {course.completedLessons}/{course.totalLessons} bài học
                </p>
              </div>
              <div className="mt-4 flex justify-end">
                <Button variant="secondary" className="group-hover:bg-primary group-hover:text-primary-foreground transition-colors">
                  Tiếp tục học
                </Button>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
} 