"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/components/ui/use-toast"
import { supabase } from "@/lib/supabase"
import { getCurrentUser } from "@/lib/supabase"

export default function ChangePasswordPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [currentPassword, setCurrentPassword] = useState("")
  const [newPassword, setNewPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Kiểm tra xác thực khi trang được tải
  useEffect(() => {
    checkAuth()
  }, [])

  async function checkAuth() {
    try {
      const currentUser = await getCurrentUser()
      if (!currentUser) {
        router.push('/login')
      }
    } catch (error) {
      console.error('Lỗi khi kiểm tra xác thực:', error)
      router.push('/login')
    }
  }

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault()
    
    // Kiểm tra mật khẩu mới và xác nhận mật khẩu
    if (newPassword !== confirmPassword) {
      setError("Mật khẩu mới và xác nhận mật khẩu không khớp")
      return
    }
    
    // Kiểm tra độ dài mật khẩu
    if (newPassword.length < 6) {
      setError("Mật khẩu mới phải có ít nhất 6 ký tự")
      return
    }
    
    setIsLoading(true)
    setError(null)
    
    try {
      // Lấy thông tin user hiện tại
      const { data: { user } } = await supabase.auth.getUser()
      
      if (!user) {
        throw new Error("Không tìm thấy thông tin người dùng")
      }
      
      // Thay đổi mật khẩu
      const { error } = await supabase.auth.updateUser({ 
        password: newPassword 
      })
      
      if (error) throw error
      
      // Thông báo thành công và quay lại trang dashboard
      toast({
        title: "Thành công",
        description: "Mật khẩu đã được thay đổi"
      })
      
      // Reset form và chuyển hướng sau 2 giây
      setCurrentPassword("")
      setNewPassword("")
      setConfirmPassword("")
      
      setTimeout(() => {
        router.push('/dashboard')
      }, 2000)
      
    } catch (error: any) {
      setError(error.message || "Có lỗi xảy ra khi đổi mật khẩu")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow">
        <div className="text-center">
          <h1 className="text-2xl font-bold">Đổi mật khẩu</h1>
          <p className="mt-2 text-gray-600">Nhập mật khẩu mới của bạn</p>
        </div>

        {error && (
          <div className="bg-red-50 p-4 rounded-md text-red-600 text-sm">
            {error}
          </div>
        )}

        <form onSubmit={handleChangePassword} className="space-y-6">
          <div className="form-field">
            <Input
              id="currentPassword"
              type="password"
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              required
              className="form-input peer"
              placeholder="Mật khẩu hiện tại"
            />
            <Label htmlFor="currentPassword" className="form-label">Mật khẩu hiện tại</Label>
          </div>
          
          <div className="form-field">
            <Input
              id="newPassword"
              type="password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              className="form-input peer"
              placeholder="Mật khẩu mới"
            />
            <Label htmlFor="newPassword" className="form-label">Mật khẩu mới</Label>
          </div>
          
          <div className="form-field">
            <Input
              id="confirmPassword"
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              className="form-input peer"
              placeholder="Xác nhận mật khẩu mới"
            />
            <Label htmlFor="confirmPassword" className="form-label">Xác nhận mật khẩu mới</Label>
          </div>
          
          <div className="flex items-center justify-between pt-4">
            <Button
              type="button"
              variant="outline"
              onClick={() => router.back()}
              disabled={isLoading}
            >
              Quay lại
            </Button>
            <Button type="submit" disabled={isLoading}>
              {isLoading ? "Đang xử lý..." : "Đổi mật khẩu"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
} 