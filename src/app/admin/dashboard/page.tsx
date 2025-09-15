"use client"

import { useState, useEffect, useRef } from "react"
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
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs"
import Papa from "papaparse"

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
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)

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

      const lastName = formData.get("lastName") as string;
      const firstName = formData.get("firstName") as string;
      const accountData = {
        student_id: formData.get("username") as string,
        full_name: `${lastName} ${firstName}`,
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
          // Check for foreign key violation (user enrolled in a class)
          if (error.code === '23503') {
            throw new Error("Không thể xóa người dùng vì họ vẫn đang được ghi danh trong một lớp học.");
          }
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

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files.length > 0) {
      setSelectedFile(event.target.files[0])
    }
  }

  const handleImport = () => {
    if (!selectedFile) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Vui lòng chọn một file để nhập.",
      })
      return
    }

    setIsLoading(true)
    Papa.parse(selectedFile, {
      header: true,
      skipEmptyLines: true,
      complete: async (results) => {
        try {
          const users = results.data.map((row: any) => ({
            student_id: row.student_id?.trim(),
            last_name: row.last_name?.trim(),
            first_name: row.first_name?.trim(),
            role: row.role?.trim(),
            class_code: row.class_code?.trim(),
            password: row.password?.trim(),
          })).filter(u => u.student_id && u.last_name && u.first_name && u.role)

          if (users.length === 0) {
            throw new Error("File không có dữ liệu hợp lệ.")
          }

          const response = await fetch('/api/users/import', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ users }),
          })

          const data = await response.json()

          if (!response.ok) {
            let errorMessage = data.message || "Nhập tài khoản thất bại."
            if (data.errors) {
                const errorDetails = data.errors.map((e: any) => `${e.user}: ${e.error}`).join("\n")
                errorMessage += `\nChi tiết:\n${errorDetails}`
            }
            throw new Error(errorMessage)
          }
          
          toast({
            title: "Thành công",
            description: data.message,
          })

          await loadAccounts()
          setIsDialogOpen(false)
          setSelectedFile(null)
          if(fileInputRef.current) fileInputRef.current.value = ""

        } catch (error: any) {
          toast({
            variant: "destructive",
            title: "Lỗi nhập file",
            description: error.message,
          })
        } finally {
          setIsLoading(false)
        }
      },
      error: (error: any) => {
        toast({
          variant: "destructive",
          title: "Lỗi xử lý file",
          description: error.message,
        })
        setIsLoading(false)
      },
    })
  }

  return (
    <div className="container mx-auto px-2 py-4 sm:px-4">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-2 sm:gap-0">
        <h1 className="text-xl sm:text-2xl font-bold w-full text-center sm:w-auto sm:text-left">
          Quản lý tài khoản
        </h1>
        <div className="flex space-x-2 sm:space-x-4 w-full sm:w-auto">
          <Button className="w-full sm:w-auto" onClick={() => {
            setSelectedAccount(null)
            setIsDialogOpen(true)
          }}>
            Thêm tài khoản
          </Button>
          <Button className="w-full sm:w-auto" variant="outline" onClick={handleLogout}>
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

      <div className="bg-white rounded-lg shadow overflow-x-auto">
        <table className="min-w-[600px] w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th scope="col" className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Mã số
              </th>
              <th scope="col" className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Họ tên
              </th>
              <th scope="col" className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Vai trò
              </th>
              <th scope="col" className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Lớp
              </th>
              <th scope="col" className="px-4 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Thao tác
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {displayedAccounts.map((account) => (
              <tr key={account.id} className="hover:bg-gray-50">
                <td className="px-4 sm:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.student_id}
                </td>
                <td className="px-4 sm:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.full_name}
                </td>
                <td className="px-4 sm:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${ 
                    account.role === 'student' 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-blue-100 text-blue-800'
                  }`}>
                    {account.role === 'student' ? 'Sinh viên' : 'Giảng viên'}
                  </span>
                </td>
                <td className="px-4 sm:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {account.class_code || '-'}
                </td>
                <td className="px-4 sm:px-6 py-4 whitespace-nowrap text-sm font-medium flex flex-col sm:flex-row gap-2 sm:space-x-2">
                  <Button
                    variant="outline"
                    size="sm"
                    className="w-full sm:w-auto"
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
                    className="w-full sm:w-auto"
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
                    className="w-full sm:w-auto"
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
      <div className="mt-4 flex flex-col sm:flex-row justify-center items-center space-y-2 sm:space-y-0 sm:space-x-2">
        <Button
          variant="outline"
          onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
          disabled={currentPage === 1}
          className="w-full sm:w-auto"
        >
          Trước
        </Button>
        <span className="px-4 py-2 rounded-md bg-gray-100 text-center w-full sm:w-auto">
          Trang {currentPage} / {totalPages}
        </span>
        <Button
          variant="outline"
          onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
          disabled={currentPage === totalPages}
          className="w-full sm:w-auto"
        >
          Sau
        </Button>
      </div>

      {/* Dialog thêm/sửa tài khoản */} 
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-xs sm:max-w-lg w-full">
          <DialogHeader>
            <DialogTitle>{selectedAccount ? "Chỉnh sửa tài khoản" : "Thêm tài khoản"}</DialogTitle>
            <DialogDescription>
              {selectedAccount ? "Cập nhật thông tin tài khoản người dùng." : "Chọn phương thức để thêm tài khoản mới."}
            </DialogDescription>
          </DialogHeader>
          <Tabs defaultValue="single" className="w-full">
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="single">Thêm một tài khoản</TabsTrigger>
              <TabsTrigger value="import">Nhập từ file</TabsTrigger>
            </TabsList>
            <TabsContent value="single">
              <form onSubmit={handleSubmit} className="space-y-4 pt-4">
                <div className="form-field">
                  <input id="username" name="username" defaultValue={selectedAccount?.student_id} className="form-input peer" required placeholder="Mã số" />
                  <label className="form-label" htmlFor="username">Mã số</label>
                </div>
                <div className="form-field">
                  <input id="lastName" name="lastName" defaultValue={selectedAccount?.full_name?.split(' ').slice(0, -1).join(' ')} className="form-input peer" required placeholder="Họ và tên đệm" />
                  <label className="form-label" htmlFor="lastName">Họ và tên đệm</label>
                </div>
                <div className="form-field">
                  <input id="firstName" name="firstName" defaultValue={selectedAccount?.full_name?.split(' ').slice(-1).join(' ')} className="form-input peer" required placeholder="Tên" />
                  <label className="form-label" htmlFor="firstName">Tên</label>
                </div>
                <div className="form-field">
                  <label className="absolute -top-3 left-3 text-sm text-blue-500" htmlFor="role">Vai trò</label>
                  <select id="role" name="role" defaultValue={selectedAccount?.role || "student"} className="w-full px-3 py-2 border rounded-md" required>
                    <option value="student">Sinh viên</option>
                    <option value="teacher">Giảng viên</option>
                  </select>
                </div>
                <div className="form-field">
                  <input id="class" name="class" defaultValue={selectedAccount?.class_code} className="form-input peer" placeholder="Lớp" />
                  <label className="form-label" htmlFor="class">Lớp</label>
                </div>
                <DialogFooter className="flex flex-col sm:flex-row gap-2 sm:gap-0 sm:space-x-2 pt-4">
                  <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)} className="w-full sm:w-auto">Hủy</Button>
                  <Button type="submit" disabled={isLoading} className="w-full sm:w-auto">{selectedAccount ? "Cập nhật" : "Thêm mới"}</Button>
                </DialogFooter>
              </form>
            </TabsContent>
            <TabsContent value="import">
                <div className="space-y-4 pt-4">
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Tải file mẫu</label>
                        <p className="text-sm text-muted-foreground">
                            Tải file CSV mẫu để điền thông tin tài khoản.
                        </p>
                        <a href="/mau_danh_sach_tai_khoan.csv" download>
                            <Button variant="outline" className="w-full">Tải mẫu</Button>
                        </a>
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium" htmlFor="file-upload">Chọn file</label>
                        <input 
                            id="file-upload" 
                            type="file" 
                            accept=".csv" 
                            ref={fileInputRef}
                            onChange={handleFileChange}
                            className="w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-violet-50 file:text-violet-700 hover:file:bg-violet-100"
                        />
                    </div>
                    <DialogFooter className="flex flex-col sm:flex-row gap-2 sm:gap-0 sm:space-x-2 pt-4">
                        <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)} className="w-full sm:w-auto">Hủy</Button>
                        <Button onClick={handleImport} disabled={isLoading || !selectedFile} className="w-full sm:w-auto">
                            {isLoading ? "Đang xử lý..." : "Nhập tài khoản"}
                        </Button>
                    </DialogFooter>
                </div>
            </TabsContent>
          </Tabs>
        </DialogContent>
      </Dialog>

      {/* Dialog xác nhận xóa */} 
      <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
        <DialogContent className="max-w-xs sm:max-w-md w-full">
          <DialogHeader>
            <DialogTitle>Xác nhận xóa tài khoản</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter className="flex flex-col sm:flex-row gap-2 sm:gap-0 sm:space-x-2">
            <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)} className="w-full sm:w-auto">
              Hủy
            </Button>
            <Button variant="destructive" onClick={handleDelete} disabled={isLoading} className="w-full sm:w-auto">
              Xóa
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Dialog xác nhận reset mật khẩu */} 
      <Dialog open={isResetDialogOpen} onOpenChange={setIsResetDialogOpen}>
        <DialogContent className="max-w-xs sm:max-w-md w-full">
          <DialogHeader>
            <DialogTitle>Xác nhận reset mật khẩu</DialogTitle>
            <DialogDescription>
              Bạn có chắc chắn muốn reset mật khẩu cho tài khoản {selectedAccount?.student_id}?
              Mật khẩu mới sẽ là: password123
            </DialogDescription>
          </DialogHeader>
          <DialogFooter className="flex flex-col sm:flex-row gap-2 sm:gap-0 sm:space-x-2">
            <Button type="button" variant="outline" onClick={() => setIsResetDialogOpen(false)} className="w-full sm:w-auto">
              Hủy
            </Button>
            <Button type="button" onClick={handleResetPassword} disabled={isLoading} className="w-full sm:w-auto">
              Xác nhận
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}