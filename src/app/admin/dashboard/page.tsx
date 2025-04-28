"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { supabase, adminSupabase } from "@/lib/supabase"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"

// Types
type Role = "student" | "teacher"
type Account = {
  id: string
  student_id: string
  full_name: string
  role: Role
  status: "active" | "inactive"
  class_code?: string
}

// Hàm tạo UUID
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

export default function AdminDashboardPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [accounts, setAccounts] = useState<Account[]>([])
  const [searchTerm, setSearchTerm] = useState("")
  const [currentPage, setCurrentPage] = useState(1)
  const [selectedAccount, setSelectedAccount] = useState<Account | null>(null)
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false)
  const [isResetDialogOpen, setIsResetDialogOpen] = useState(false)

  // Tải danh sách tài khoản
  useEffect(() => {
    loadAccounts()
  }, [])

  async function loadAccounts() {
    try {
      setIsLoading(true)
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) throw error
      setAccounts(data)
    } catch (error) {
      console.error('Lỗi khi tải danh sách tài khoản:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách tài khoản"
      })
    } finally {
      setIsLoading(false)
    }
  }

  // Phân trang
  const itemsPerPage = 5
  const totalPages = Math.ceil(accounts.length / itemsPerPage)
  const startIndex = (currentPage - 1) * itemsPerPage
  const endIndex = startIndex + itemsPerPage

  // Lọc và tìm kiếm
  const filteredAccounts = accounts.filter(account => 
    account.student_id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    account.full_name.toLowerCase().includes(searchTerm.toLowerCase())
  )

  // Danh sách hiển thị theo trang
  const displayedAccounts = filteredAccounts.slice(startIndex, endIndex)

  // Hàm đăng xuất
  const handleLogout = () => {
    document.cookie = "adminAuthenticated=false; path=/;"
    router.push("/admin/login")
  }

  // Hàm xử lý form
  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    const formData = new FormData(event.currentTarget)
    
    try {
      setIsLoading(true)

      const accountData = {
        student_id: formData.get("username") as string,
        full_name: formData.get("fullName") as string,
        role: formData.get("role") as Role,
        status: "active" as const,
        class_code: formData.get("class") as string,
      }

      if (selectedAccount) {
        // Cập nhật tài khoản
        const { data, error } = await supabase
          .from('profiles')
          .update({
            ...accountData,
            updated_at: new Date().toISOString()
          })
          .eq('id', selectedAccount.id)
          .select()

        if (error) {
          console.error('Chi tiết lỗi:', {
            message: error.message,
            details: error.details,
            hint: error.hint,
            code: error.code
          })
          throw new Error(`Lỗi khi cập nhật: ${error.message}`)
        }

        toast({ 
          title: "Thành công",
          description: "Cập nhật tài khoản thành công"
        })
      } else {
        try {
          // Tạo auth user với signUp
          const email = `${accountData.student_id}@gmail.com`
          const password = "password123" // Mật khẩu mặc định

          const { data: authData, error: authError } = await supabase.auth.signUp({
            email,
            password,
            options: {
              data: {
                role: accountData.role
              }
            }
          })

          if (authError) {
            console.error('Chi tiết lỗi auth:', authError)
            throw new Error(`Lỗi khi tạo tài khoản: ${authError.message}`)
          }

          if (!authData.user) {
            throw new Error('Không thể tạo tài khoản auth')
          }

          // Cập nhật thông tin trong bảng profiles
          const { error: updateError } = await supabase
            .from('profiles')
            .update({
              student_id: accountData.student_id,
              full_name: accountData.full_name,
              role: accountData.role,
              class_code: accountData.class_code,
              status: accountData.status,
              updated_at: new Date().toISOString()
            })
            .eq('id', authData.user.id)

          if (updateError) {
            console.error('Chi tiết lỗi cập nhật:', {
              message: updateError.message,
              details: updateError.details,
              hint: updateError.hint,
              code: updateError.code
            })
            throw new Error(`Lỗi khi cập nhật thông tin: ${updateError.message}`)
          }

          toast({ 
            title: "Thành công",
            description: "Thêm tài khoản mới thành công"
          })
        } catch (error) {
          console.error('Lỗi khi tạo tài khoản:', error)
          throw error
        }
      }

      // Tải lại danh sách
      await loadAccounts()
      setIsDialogOpen(false)
      setSelectedAccount(null)
    } catch (error) {
      console.error('Lỗi khi thêm/cập nhật tài khoản:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error instanceof Error ? error.message : "Có lỗi xảy ra, vui lòng thử lại"
      })
    } finally {
      setIsLoading(false)
    }
  }

  // Hàm xóa tài khoản
  const handleDelete = async () => {
    if (selectedAccount) {
      try {
        setIsLoading(true)
        const { error } = await supabase
          .from('profiles')
          .delete()
          .eq('id', selectedAccount.id)

        if (error) {
          console.error('Chi tiết lỗi:', {
            message: error.message,
            details: error.details,
            hint: error.hint,
            code: error.code
          })
          throw new Error(`Lỗi khi xóa: ${error.message}`)
        }

        toast({ 
          title: "Thành công",
          description: "Xóa tài khoản thành công"
        })
        await loadAccounts()
        setIsDeleteDialogOpen(false)
        setSelectedAccount(null)
      } catch (error) {
        console.error('Lỗi khi xóa tài khoản:', error)
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: error instanceof Error ? error.message : "Có lỗi xảy ra khi xóa tài khoản"
        })
      } finally {
        setIsLoading(false)
      }
    }
  }

  // Hàm reset mật khẩu
  const handleResetPassword = async () => {
    if (selectedAccount) {
      try {
        setIsLoading(true)
        const newPassword = "password123" // Mật khẩu mặc định mới

        // Reset mật khẩu trực tiếp bằng service role
        const { error } = await adminSupabase.auth.admin.updateUserById(
          selectedAccount.id,
          { password: newPassword }
        )

        if (error) {
          console.error('Chi tiết lỗi:', error)
          throw new Error(`Lỗi khi reset mật khẩu: ${error.message}`)
        }

        toast({ 
          title: "Thành công",
          description: "Reset mật khẩu thành công. Mật khẩu mới là: password123"
        })
        setIsResetDialogOpen(false)
        setSelectedAccount(null)
      } catch (error) {
        console.error('Lỗi khi reset mật khẩu:', error)
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: error instanceof Error ? error.message : "Có lỗi xảy ra khi reset mật khẩu"
        })
      } finally {
        setIsLoading(false)
      }
    }
  }

  return (
    <div className="container mx-auto p-4">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Quản lý tài khoản</h1>
        <div className="space-x-4">
          <Button onClick={() => {
            setSelectedAccount(null)
            setIsDialogOpen(true)
          }}>
            Thêm tài khoản
          </Button>
          <Button variant="outline" onClick={handleLogout}>
            Đăng xuất
          </Button>
        </div>
      </div>

      <div className="mb-4">
        <input
          type="text"
          placeholder="Tìm kiếm theo mã số hoặc họ tên..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full p-2 border rounded-md"
        />
      </div>

      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Mã số
              </th>
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Họ tên
              </th>
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Vai trò
              </th>
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Lớp
              </th>
              <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Thao tác
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {displayedAccounts.map((account) => (
              <tr key={account.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.student_id}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.full_name}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                    account.role === 'student' 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-blue-100 text-blue-800'
                  }`}>
                    {account.role === 'student' ? 'Sinh viên' : 'Giảng viên'}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.class_code || '-'}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => {
                      setSelectedAccount(account)
                      setIsDialogOpen(true)
                    }}
                  >
                    Sửa
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => {
                      setSelectedAccount(account)
                      setIsResetDialogOpen(true)
                    }}
                  >
                    Reset MK
                  </Button>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => {
                      setSelectedAccount(account)
                      setIsDeleteDialogOpen(true)
                    }}
                  >
                    Xóa
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Phân trang */}
      <div className="mt-4 flex justify-center space-x-2">
        <Button
          variant="outline"
          onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
          disabled={currentPage === 1}
        >
          Trước
        </Button>
        <span className="px-4 py-2 rounded-md bg-gray-100">
          Trang {currentPage} / {totalPages}
        </span>
        <Button
          variant="outline"
          onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
          disabled={currentPage === totalPages}
        >
          Sau
        </Button>
      </div>

      {/* Dialog thêm/sửa tài khoản */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{selectedAccount ? "Chỉnh sửa tài khoản" : "Thêm tài khoản mới"}</DialogTitle>
            <DialogDescription>
              {selectedAccount 
                ? "Cập nhật thông tin tài khoản người dùng" 
                : "Nhập thông tin để tạo tài khoản mới"}
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="username">
                Mã số
              </label>
              <input
                id="username"
                name="username"
                defaultValue={selectedAccount?.student_id}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="fullName">
                Họ và tên
              </label>
              <input
                id="fullName"
                name="fullName"
                defaultValue={selectedAccount?.full_name}
                className="w-full px-3 py-2 border rounded-md"
                required
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="role">
                Vai trò
              </label>
              <select
                id="role"
                name="role"
                defaultValue={selectedAccount?.role || "student"}
                className="w-full px-3 py-2 border rounded-md"
                required
              >
                <option value="student">Sinh viên</option>
                <option value="teacher">Giảng viên</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium" htmlFor="class">
                Lớp
              </label>
              <input
                id="class"
                name="class"
                defaultValue={selectedAccount?.class_code}
                className="w-full px-3 py-2 border rounded-md"
              />
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                Hủy
              </Button>
              <Button type="submit" disabled={isLoading}>
                {selectedAccount ? "Cập nhật" : "Thêm mới"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Dialog xác nhận xóa */}
      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận xóa tài khoản</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)}>
              Hủy
            </Button>
            <Button variant="destructive" onClick={handleDelete} disabled={isLoading}>
              Xóa
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Dialog xác nhận reset mật khẩu */}
      <Dialog open={isResetDialogOpen} onOpenChange={setIsResetDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xác nhận reset mật khẩu</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn reset mật khẩu cho tài khoản {selectedAccount?.student_id}?
              Mật khẩu mới sẽ là: password123
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setIsResetDialogOpen(false)}>
              Hủy
            </Button>
            <Button type="button" onClick={handleResetPassword} disabled={isLoading}>
              Xác nhận
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 