import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  // Kiểm tra nếu đang truy cập route admin
  if (request.nextUrl.pathname.startsWith('/admin')) {
    // Bỏ qua trang đăng nhập
    if (request.nextUrl.pathname === '/admin/login') {
      return NextResponse.next()
    }

    // Kiểm tra cookie xác thực
    const isAuthenticated = request.cookies.get('adminAuthenticated')?.value === 'true'

    if (!isAuthenticated) {
      // Chuyển hướng về trang đăng nhập nếu chưa xác thực
      return NextResponse.redirect(new URL('/admin/login', request.url))
    }
  }

  if (request.nextUrl.pathname.startsWith('/TeacherDashboard')) {
    const session = request.cookies.get('session')
    const userRole = session?.value ? JSON.parse(session.value).role : null
    
    if (!session || userRole !== 'teacher') {
      return NextResponse.redirect(new URL('/login', request.url))
    }
  }

  return NextResponse.next()
}

export const config = {
  matcher: '/admin/:path*',
} 