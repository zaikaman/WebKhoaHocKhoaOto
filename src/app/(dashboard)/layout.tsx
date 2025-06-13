"use client"

import { ReactNode, useEffect, useState } from "react"
import Link from "next/link"
import { useRouter, usePathname } from "next/navigation"
import { Button } from "@/components/ui/button"
import { signOut, getCurrentUser } from "@/lib/supabase"
import { useToast } from "@/components/ui/use-toast"
import { cn } from "@/lib/utils"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

export default function DashboardLayout({
  children,
}: {
  children: ReactNode
}) {
  const router = useRouter()
  const pathname = usePathname()
  const { toast } = useToast()
  const [role, setRole] = useState<'student' | 'teacher' | 'admin' | null>(null)
  const [isScrolled, setIsScrolled] = useState(false)

  useEffect(() => {
    checkAuth()
  }, [])

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 0) {
        setIsScrolled(true)
      } else {
        setIsScrolled(false)
      }
    }

    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
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
    <div className="min-h-screen overflow-x-hidden">
      {/* Fixed Navigation Header */}
      <header className={cn(
        "fixed top-0 left-0 right-0 z-50 transition-all duration-300",
        isScrolled 
          ? "bg-white/60 backdrop-blur-md shadow-sm border-b border-gray-100" 
          : "bg-white shadow-sm"
      )}>
        <div className="max-w-7xl mx-auto px-6 py-2 relative">
          <div className="flex items-center justify-between gap-4">
            {/* Logo and Brand */}
            <Link href="/dashboard" className="flex items-center space-x-2 flex-shrink-0">
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
            </Link>

            {/* Navigation Menu */}
            <nav className="flex items-center gap-4 overflow-x-auto flex-grow justify-center scrollbar-none">
              <Link
                href="/dashboard"
                className={cn(
                  "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                     "text-black font-medium",
                  "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                )}
              >
                Trang chủ
              </Link>

              {role === 'teacher' && (
                <>
                  <Link
                    href="/dashboard/teacher/classes"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                      "text-black font-medium",
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Lớp học của tôi
                  </Link>
                  <Link
                    href="/dashboard/teacher/lectures"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                       "text-black font-medium",
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Bài giảng
                  </Link>
                  <Link
                    href="/dashboard/teacher/assignments"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                      "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Bài tập
                  </Link>
                  <Link
                    href="/dashboard/teacher/exams/list"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                      "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Bài kiểm tra
                  </Link>
                  <Link
                    href="/dashboard/teacher/subjects"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                       "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Môn học
                  </Link>
                </>
              )}

              {role === 'student' && (
                <>
                  <Link
                    href="/dashboard/student/courses"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                     "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Lớp học
                  </Link>
                  <Link
                    href="/dashboard/assignments"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                      "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Bài tập
                  </Link>
                  <Link
                    href="/dashboard/student/exams"
                    className={cn(
                      "text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group",
                    "text-black font-medium" ,
                      "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
                    )}
                  >
                    Bài kiểm tra
                  </Link>
                </>
              )}
            </nav>

            {/* User Actions */}
            <div className="flex items-center gap-4 flex-shrink-0">
              <DropdownMenu modal={false}>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" className="whitespace-nowrap">
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
                </DropdownMenuTrigger>
                <DropdownMenuContent 
                  align="end" 
                  className="w-48" 
                  sideOffset={8}
                  avoidCollisions={false}
                >
                  <DropdownMenuItem 
                    onClick={() => router.push('/change-password')}
                    className="text-xs font-medium cursor-pointer !text-gray-700 hover:!text-gray-900"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="mr-2"
                    >
                      <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                      <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                    </svg>
                    Đổi mật khẩu
                  </DropdownMenuItem>
                  <DropdownMenuItem 
                    onClick={handleSignOut}
                    className="text-xs font-medium cursor-pointer !text-gray-700 hover:!text-gray-900"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="mr-2"
                    >
                      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                      <polyline points="16 17 21 12 16 7" />
                      <line x1="21" y1="12" x2="9" y2="12" />
                    </svg>
                    Đăng xuất
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </div>
        </div>
      </header>

      {/* Main content */}
      <main className="pt-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {children}
        </div>
      </main>
    </div>
  )
}
