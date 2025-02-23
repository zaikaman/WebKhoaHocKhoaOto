import { ReactNode } from "react"
import Link from "next/link"
import { Button } from "@/components/ui/button"

export default function DashboardLayout({
  children,
}: {
  children: ReactNode
}) {

  return (
    <div className="min-h-screen flex">
      {/* Sidebar */}
      <aside className="w-64 bg-gray-900 text-white">
        <div className="p-4">
          <div className="flex items-center space-x-2 mb-8">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="h-6 w-6"
            >
              <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3" />
            </svg>
            <span className="text-lg font-bold">E-Learning</span>
          </div>
          <nav className="space-y-2">
            <Link
              href="/TeacherDashboard"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Trang chủ
            </Link>
            <Link
              href="/dashboard/courses"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Lớp học
            </Link>
            <Link
              href="/dashboard/assignments"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Bài tập
            </Link>
            <Link
              href="/dashboard/assignments"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Bài giảng
            </Link>
            <Link
              href="/dashboard/assignments"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Bài kiểm tra
            </Link>
            <Link
              href="/dashboard/grades"
              className="block px-4 py-2 rounded hover:bg-gray-800 transition-colors"
            >
              Thống kê điểm số
            </Link>
          </nav>
        </div>
      </aside>

      {/* Main content */}
      <div className="flex-1">
        {/* Header */}
        <header className="bg-white shadow">
          <div className="flex items-center justify-between px-6 py-4">
            <h1 className="text-xl font-semibold">Dashboard</h1>
            <div className="flex items-center space-x-4">
              <Button variant="ghost">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  className="h-5 w-5"
                >
                  <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                  <circle cx="12" cy="7" r="4" />
                </svg>
                <span className="ml-2">Tài khoản</span>
              </Button>
              <Button variant="outline">Đăng xuất</Button>
            </div>
          </div>
        </header>

        {/* Page content */}
        <main className="p-6">
          {children}
        </main>
      </div>
    </div>
  )
} 