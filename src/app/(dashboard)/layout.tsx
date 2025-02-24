"use client"

import { ReactNode, useEffect, useState } from "react"
import Link from "next/link"
import { useRouter, usePathname } from "next/navigation"
import { Button } from "@/components/ui/button"
import { signOut, getCurrentUser } from "@/lib/supabase"
import { useToast } from "@/components/ui/use-toast"
import { cn } from "@/lib/utils"

export default function DashboardLayout({
  children,
}: {
  children: ReactNode
}) {
  const router = useRouter()
  const pathname = usePathname()
  const { toast } = useToast()
  const [role, setRole] = useState<'student' | 'teacher' | 'admin' | null>(null)

  useEffect(() => {
    checkAuth()
  }, [])

  async function checkAuth() {
    try {
      const currentUser = await getCurrentUser()
      if (!currentUser) {
        router.push('/login')
        return
      }
      setRole(currentUser.profile.role)
    } catch (error) {
      console.error('Lỗi khi kiểm tra xác thực:', error)
      router.push('/login')
    }
  }

  const handleSignOut = async () => {
    try {
      await signOut()
      toast({
        title: "Đăng xuất thành công",
        description: "Hẹn gặp lại bạn!"
      })
      router.push('/login')
    } catch (error) {
      console.error('Lỗi khi đăng xuất:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể đăng xuất. Vui lòng thử lại."
      })
    }
  }

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
              href="/dashboard"
              className={cn(
                "block px-4 py-2 rounded transition-colors",
                pathname === "/dashboard" 
                  ? "bg-gray-800 text-white" 
                  : "hover:bg-gray-800"
              )}
            >
              <div className="flex items-center">
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
                  <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                  <polyline points="9 22 9 12 15 12 15 22" />
                </svg>
                Trang chủ
              </div>
            </Link>

            {role === 'teacher' && (
              <>
                <Link
                  href="/dashboard/teacher/classes"
                  className={cn(
                    "block px-4 py-2 rounded transition-colors",
                    pathname === "/dashboard/teacher/classes" 
                      ? "bg-gray-800 text-white" 
                      : "hover:bg-gray-800"
                  )}
                >
                  <div className="flex items-center">
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
                      <path d="M18 6h-5c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h5c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                      <path d="M9 6H4c-1.1 0-2 .9-2 2v8c0 1.1.9 2 2 2h5c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2z" />
                    </svg>
                    Lớp học của tôi
                  </div>
                </Link>

                <Link
                  href="/dashboard/teacher/subjects"
                  className={cn(
                    "block px-4 py-2 rounded transition-colors",
                    pathname === "/dashboard/teacher/subjects" 
                      ? "bg-gray-800 text-white" 
                      : "hover:bg-gray-800"
                  )}
                >
                  <div className="flex items-center">
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
                      <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20" />
                    </svg>
                    Môn học
                  </div>
                </Link>
              </>
            )}

            {role === 'student' && (
              <>
                <Link
                  href="/dashboard/student/courses"
                  className={cn(
                    "block px-4 py-2 rounded transition-colors",
                    pathname === "/dashboard/courses" 
                      ? "bg-gray-800 text-white" 
                      : "hover:bg-gray-800"
                  )}
                >
                  <div className="flex items-center">
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
                      <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20" />
                    </svg>
                  Lớp học
                  </div>
                </Link>

                <Link
                  href="/dashboard/assignments"
                  className={cn(
                    "block px-4 py-2 rounded transition-colors",
                    pathname === "/dashboard/assignments" 
                      ? "bg-gray-800 text-white" 
                      : "hover:bg-gray-800"
                  )}
                >
                  <div className="flex items-center">
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
                      <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                      <path d="M15 2H9a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1Z" />
                    </svg>
                    Bài tập
                  </div>
                </Link>

                <Link
                  href="/dashboard/grades"
                  className={cn(
                    "block px-4 py-2 rounded transition-colors",
                    pathname === "/dashboard/grades" 
                      ? "bg-gray-800 text-white" 
                      : "hover:bg-gray-800"
                  )}
                >
                  <div className="flex items-center">
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
                      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                      <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    Điểm số
                  </div>
                </Link>
              </>
            )}
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
              <Button variant="outline" onClick={handleSignOut}>Đăng xuất</Button>
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