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
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet"
import { Menu, X, Download } from "lucide-react"

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
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false)

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

  const handleDownload = () => {
    const link = document.createElement('a');
    link.href = '/SAFlashPlayer.rar';
    link.setAttribute('download', 'SAFlashPlayer.rar');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
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

  const NavLink = ({ href, children, onClick }: { href: string; children: React.ReactNode; onClick?: () => void }) => (
    <Link
      href={href}
      onClick={onClick}
      className={cn(
        "text-sm sm:text-[15px] px-3 py-2 rounded transition-colors whitespace-nowrap relative group block",
        "text-black font-medium",
        "after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-black after:transition-all after:duration-300 hover:after:w-full"
      )}
    >
      {children}
    </Link>
  )

  const navigationItems = (
    <>
      <NavLink href="/dashboard" onClick={() => setIsMobileMenuOpen(false)}>
        Trang chủ
      </NavLink>

      {role === 'teacher' && (
        <>
          <NavLink href="/dashboard/teacher/classes" onClick={() => setIsMobileMenuOpen(false)}>
            Lớp học của tôi
          </NavLink>
          <NavLink href="/dashboard/teacher/lectures" onClick={() => setIsMobileMenuOpen(false)}>
            Bài giảng
          </NavLink>
          <NavLink href="/dashboard/teacher/assignments" onClick={() => setIsMobileMenuOpen(false)}>
            Bài tập
          </NavLink>
          <NavLink href="/dashboard/teacher/exams/list" onClick={() => setIsMobileMenuOpen(false)}>
            Bài kiểm tra
          </NavLink>
          <NavLink href="/dashboard/teacher/subjects" onClick={() => setIsMobileMenuOpen(false)}>
            Môn học
          </NavLink>
        </>
      )}

      {role === 'student' && (
        <>
          <NavLink href="/dashboard/student/courses" onClick={() => setIsMobileMenuOpen(false)}>
            Lớp học
          </NavLink>
          <NavLink href="/dashboard/assignments" onClick={() => setIsMobileMenuOpen(false)}>
            Bài tập
          </NavLink>
          <NavLink href="/dashboard/student/exams" onClick={() => setIsMobileMenuOpen(false)}>
            Bài kiểm tra
          </NavLink>
        </>
      )}
    </>
  )

  return (
    <div className="min-h-screen overflow-x-hidden">
      {/* Fixed Navigation Header */}
      <header className={cn(
        "fixed top-0 left-0 right-0 z-50 transition-all duration-300",
        isScrolled 
          ? "bg-white/95 backdrop-blur-md shadow-sm border-b border-gray-100" 
          : "bg-white shadow-sm"
      )}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 py-3 sm:py-2 relative">
          <div className="flex items-center justify-between gap-2 sm:gap-4">
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
                className="h-5 w-5 sm:h-6 sm:w-6"
              >
                <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3" />
              </svg>
              <span className="text-base sm:text-lg font-bold"></span>
            </Link>

            {/* Desktop Navigation Menu */}
            <nav className="hidden lg:flex items-center gap-4 overflow-x-auto flex-grow justify-center scrollbar-none">
              {navigationItems}
            </nav>

            {/* User Actions and Mobile Menu */}
            <div className="flex items-center gap-2 sm:gap-4 flex-shrink-0">
              {/* Mobile Menu */}
              <Sheet open={isMobileMenuOpen} onOpenChange={setIsMobileMenuOpen}>
                <SheetTrigger asChild>
                  <Button variant="ghost" size="sm" className="lg:hidden p-2">
                    <Menu className="h-5 w-5" />
                    <span className="sr-only">Mở menu</span>
                  </Button>
                </SheetTrigger>
                <SheetContent side="left" className="w-[300px] sm:w-[400px]">
                  <SheetHeader>
                    <SheetTitle className="text-left">- Menu -</SheetTitle>
                  </SheetHeader>
                  <nav className="flex flex-col gap-2 mt-8">
                    {navigationItems}
                  </nav>
                </SheetContent>
              </Sheet>

              {/* Download Button
              <Button variant="ghost" size="sm" className="gap-2 px-2 sm:px-3" onClick={handleDownload}>
                <Download className="h-4 w-4 sm:h-5 sm:w-5" />
                <span className="hidden sm:inline text-sm">Tải mô phỏng</span>
              </Button> */}

              {/* User Dropdown */}
              <DropdownMenu modal={false}>
                <DropdownMenuTrigger asChild>
                  <Button variant="ghost" size="sm" className="gap-2 px-2 sm:px-3">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="h-4 w-4 sm:h-5 sm:w-5"
                    >
                      <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                      <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span className="hidden sm:inline text-sm">Tài khoản</span>
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
                    className="text-sm font-medium cursor-pointer !text-gray-700 hover:!text-gray-900"
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
                    className="text-sm font-medium cursor-pointer !text-gray-700 hover:!text-gray-900"
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
      <main className="pt-16 sm:pt-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
          {children}
        </div>
      </main>
    </div>
  )
}
