import { Metadata } from "next"
import Link from "next/link"
import { Button } from "@/components/ui/button"

export const metadata: Metadata = {
  title: "Đăng nhập - Khoa Công nghệ Ô tô",
  description: "Đăng nhập vào hệ thống quản lý học tập Khoa Công nghệ Ô tô",
}

export default function LoginPage() {
  return (
    <div className="container relative min-h-screen flex-col items-center justify-center grid lg:max-w-none lg:grid-cols-2 lg:px-0">
      <div className="relative hidden h-full flex-col bg-muted p-10 text-white lg:flex dark:border-r">
        <div className="absolute inset-0 bg-primary" style={{
          backgroundImage: 'url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1000&auto=format&fit=crop")',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          opacity: '0.2'
        }} />
        <div className="absolute inset-0 bg-gradient-to-t from-primary via-primary/90" />
        <div className="relative z-20 flex items-center text-lg font-medium">
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
            className="mr-2 h-6 w-6"
          >
            <path d="M7 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" />
            <path d="M17 17m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" />
            <path d="M5 17h-2v-6l2 -5h9l4 5h1a2 2 0 0 1 2 2v4h-2m-4 0h-6m-6 -6h15m-6 0v-5" />
          </svg>
          Khoa Công nghệ Ô tô
        </div>
        <div className="relative z-20 mt-auto">
          <blockquote className="space-y-2">
            <p className="text-lg">
              "Đào tạo kỹ sư công nghệ ô tô chất lượng cao, đáp ứng nhu cầu của ngành công nghiệp ô tô hiện đại."
            </p>
            <footer className="text-sm">Khoa Công nghệ Ô tô</footer>
          </blockquote>
        </div>
      </div>
      <div className="lg:p-8">
        <div className="mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[350px]">
          <div className="flex flex-col space-y-2 text-center">
            <h1 className="text-2xl font-semibold tracking-tight">
              Đăng nhập
            </h1>
            <p className="text-sm text-muted-foreground">
              Nhập thông tin đăng nhập của bạn
            </p>
          </div>
          <div className="grid gap-6">
            <form>
              <div className="grid gap-4">
                <div className="grid gap-2">
                  <label className="text-sm font-medium" htmlFor="studentId">
                    Mã số sinh viên
                  </label>
                  <input
                    id="studentId"
                    placeholder="Nhập mã số sinh viên"
                    type="text"
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                  />
                </div>
                <div className="grid gap-2">
                  <label className="text-sm font-medium" htmlFor="password">
                    Mật khẩu
                  </label>
                  <input
                    id="password"
                    type="password"
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                  />
                </div>
                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="remember"
                    className="h-4 w-4 rounded border border-input"
                  />
                  <label
                    htmlFor="remember"
                    className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                  >
                    Ghi nhớ đăng nhập
                  </label>
                </div>
                <Button className="w-full">
                  Đăng nhập
                </Button>
              </div>
            </form>
          </div>
          <p className="px-8 text-center text-sm text-muted-foreground">
            Chưa có tài khoản?{" "}
            <Link
              href="/register"
              className="underline underline-offset-4 hover:text-primary"
            >
              Đăng ký
            </Link>
          </p>
          <p className="px-8 text-center text-sm text-muted-foreground">
            <Link
              href="/forgot-password"
              className="underline underline-offset-4 hover:text-primary"
            >
              Quên mật khẩu?
            </Link>
          </p>
        </div>
      </div>
    </div>
  )
} 