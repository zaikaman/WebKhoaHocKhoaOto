"use client"

import { useState } from "react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { signIn } from "@/lib/supabase"
import { useToast } from "@/components/ui/use-toast"

export default function LoginPage() {
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()
  const { toast } = useToast()

  async function onSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setIsLoading(true)

    const formData = new FormData(event.currentTarget)
    const username = formData.get("username") as string
    const password = formData.get("password") as string

    try {
      const { user, profile } = await signIn(username, password)

      // Đăng nhập thành công
      toast({
        title: "Đăng nhập thành công",
        description: `Chào mừng ${profile.full_name || profile.username} quay trở lại!`,
      })


    router.push("/dashboard") 

    } catch (error) {
      // Xử lý lỗi đăng nhập
      toast({
        variant: "destructive",
        title: "Đăng nhập thất bại",
        description: "Mã số hoặc mật khẩu không chính xác. Vui lòng thử lại.",
      })
    } finally {
      setIsLoading(false)
    }
  }

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
          Khoa Cơ khí động lực
        </div>
        <div className="relative z-20 mt-auto">
          <blockquote className="space-y-2">
            <p className="text-lg">
              &quot;Đào tạo kỹ sư cơ khí động lực chất lượng cao, đáp ứng nhu cầu của ngành công nghiệp ô tô hiện đại.&quot;
            </p>
            <footer className="text-sm">Khoa Cơ khí động lực</footer>
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
            <form onSubmit={onSubmit}>
              <div className="grid gap-4">
                <div className="grid gap-2">
                  <label className="text-sm font-medium" htmlFor="username">
                    Mã số sinh viên/giảng viên
                  </label>
                  <input
                    id="username"
                    name="username"
                    placeholder="Nhập mã số sinh viên/giảng viên"
                    type="text"
                    autoCapitalize="none"
                    autoComplete="username"
                    autoCorrect="off"
                    disabled={isLoading}
                    required
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                  />
                </div>
                <div className="grid gap-2">
                  <label className="text-sm font-medium" htmlFor="password">
                    Mật khẩu
                  </label>
                  <input
                    id="password"
                    name="password"
                    type="password"
                    autoComplete="current-password"
                    disabled={isLoading}
                    required
                    className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                  />
                </div>
          
                <Button type="submit" disabled={isLoading} className="w-full">
                  {isLoading && (
                    <svg
                      className="mr-2 h-4 w-4 animate-spin"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      />
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      />
                    </svg>
                  )}
                  {isLoading ? "Đang đăng nhập..." : "Đăng nhập"}
                </Button>
              </div>
            </form>
          </div>
          <div className="space-y-4">
            <p className="px-8 text-center text-sm text-muted-foreground">
              Liên hệ với quản trị viên khoa để được cấp tài khoản truy cập hệ thống.
            </p>
            <p className="px-8 text-center text-sm text-muted-foreground">
              <a
                href="#"
                className="underline underline-offset-4 hover:text-primary"
                onClick={e => {
                  e.preventDefault();
                  toast({
                    title: "Quên mật khẩu",
                    description: "Hãy liên hệ với quản trị viên để được reset mật khẩu.",
                  });
                }}
              >
                Quên mật khẩu?
              </a>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
} 
