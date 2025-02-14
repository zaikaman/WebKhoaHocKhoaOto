import { Metadata } from "next"
import { Button } from "@/components/ui/button"

export const metadata: Metadata = {
  title: "Dashboard",
  description: "Trang tổng quan hệ thống quản lý học tập",
}

export default function DashboardPage() {
  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Xin chào, [Tên người dùng]</h2>
      </div>

      {/* Stats */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Khóa học đang học</h3>
          </div>
          <div className="text-2xl font-bold">5</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Bài tập đang chờ</h3>
          </div>
          <div className="text-2xl font-bold">12</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Điểm trung bình</h3>
          </div>
          <div className="text-2xl font-bold">8.5</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Thành tích</h3>
          </div>
          <div className="text-2xl font-bold">Giỏi</div>
        </div>
      </div>

      {/* Recent courses */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Khóa học gần đây</h3>
          <Button variant="outline">Xem tất cả</Button>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {[1, 2, 3].map((course) => (
            <div key={course} className="rounded-lg border bg-card text-card-foreground shadow-sm">
              <div className="p-6">
                <h4 className="text-lg font-semibold">Tên khóa học {course}</h4>
                <p className="text-sm text-gray-500 mt-2">
                  Mô tả ngắn về khóa học và nội dung chính sẽ được học.
                </p>
                <div className="mt-4 flex items-center justify-between">
                  <span className="text-sm text-gray-500">Tiến độ: 60%</span>
                  <Button variant="secondary" size="sm">
                    Tiếp tục học
                  </Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Upcoming assignments */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Bài tập sắp đến hạn</h3>
          <Button variant="outline">Xem tất cả</Button>
        </div>
        <div className="rounded-lg border">
          <div className="p-4">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-2">Tên bài tập</th>
                  <th className="text-left py-2">Môn học</th>
                  <th className="text-left py-2">Hạn nộp</th>
                  <th className="text-left py-2">Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {[1, 2, 3].map((assignment) => (
                  <tr key={assignment} className="border-b last:border-0">
                    <td className="py-3">Bài tập {assignment}</td>
                    <td className="py-3">Môn học {assignment}</td>
                    <td className="py-3">20/03/2024</td>
                    <td className="py-3">
                      <span className="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                        Chưa nộp
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
} 