"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import {
  createSubject,
  getCurrentUser,
  getSubjects,
  updateSubject,
} from "@/lib/supabase"
import type { Subject } from "@/lib/supabase"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"

export default function TeacherSubjectsPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [subjects, setSubjects] = useState<Subject[]>([])
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [selectedSubject, setSelectedSubject] = useState<Subject | null>(null)

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      
      if (!currentUser) {
        router.push('/login')
        return
      }

      if (currentUser.profile.role !== 'teacher') {
        router.push('/dashboard')
        return
      }

      const subjectsData = await getSubjects()
      setSubjects(subjectsData)
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải danh sách môn học"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleFormSubmit = async (
    event: React.FormEvent<HTMLFormElement>,
  ) => {
    event.preventDefault()
    setIsLoading(true)

    try {
      const formData = new FormData(event.currentTarget)
      const subjectData = {
        code: formData.get("code") as string,
        name: formData.get("name") as string,
        description: formData.get("description") as string,
        credits: parseInt(formData.get("credits") as string),
      }

      if (selectedSubject) {
        await updateSubject(selectedSubject.id, subjectData)
        toast({
          title: "Thành công",
          description: "Đã cập nhật môn học.",
        })
      } else {
        await createSubject(subjectData)
        toast({
          title: "Thành công",
          description: "Đã tạo môn học mới.",
        })
      }

      await loadData()
      setIsDialogOpen(false)
      setSelectedSubject(null)
    } catch (error: any) {
      console.error("Lỗi khi lưu môn học:", error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể lưu môn học.",
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="space-y-8">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <div className="h-8 w-48 bg-muted rounded animate-pulse mb-2" />
            <div className="h-4 w-64 bg-muted rounded animate-pulse" />
          </div>
          <div className="h-10 w-full sm:w-32 bg-muted rounded animate-pulse" />
        </div>

        {/* Subjects Table Skeleton */}
        <div className="rounded-md border overflow-x-auto">
          <table className="w-full min-w-[700px]">
            <thead className="bg-muted/50">
              <tr>
                <th className="py-3 px-4 text-left">
                  <div className="h-4 w-24 bg-muted rounded animate-pulse" />
                </th>
                <th className="py-3 px-4 text-left">
                  <div className="h-4 w-32 bg-muted rounded animate-pulse" />
                </th>
                <th className="py-3 px-4 text-left">
                  <div className="h-4 w-24 bg-muted rounded animate-pulse" />
                </th>
                <th className="py-3 px-4 text-left">
                  <div className="h-4 w-48 bg-muted rounded animate-pulse" />
                </th>
                <th className="py-3 px-4 text-left">
                  <div className="h-4 w-20 bg-muted rounded animate-pulse" />
                </th>
              </tr>
            </thead>
            <tbody>
              {[...Array(5)].map((_, index) => (
                <tr key={index} className="border-t">
                  <td className="py-3 px-4">
                    <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                  </td>
                  <td className="py-3 px-4">
                    <div className="h-4 w-48 bg-muted rounded animate-pulse" />
                  </td>
                  <td className="py-3 px-4">
                    <div className="h-4 w-8 bg-muted rounded animate-pulse" />
                  </td>
                  <td className="py-3 px-4">
                    <div className="h-4 w-64 bg-muted rounded animate-pulse" />
                  </td>
                  <td className="py-3 px-4">
                    <div className="h-8 w-24 bg-muted rounded animate-pulse" />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Quản lý môn học</h2>
          <p className="text-muted-foreground">
            Danh sách các môn học trong chương trình đào tạo
          </p>
        </div>
        <Button className="w-full sm:w-auto" onClick={() => {
          setSelectedSubject(null)
          setIsDialogOpen(true)
        }}>
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
            <path d="M5 12h14" />
            <path d="M12 5v14" />
          </svg>
          Thêm môn học
        </Button>
      </div>

      {/* Danh sách môn học */}
      <div className="rounded-md border overflow-x-auto">
        <table className="w-full min-w-[700px]">
          <thead className="bg-muted/50">
            <tr>
              <th className="py-3 px-4 text-left font-medium whitespace-nowrap">Mã môn học</th>
              <th className="py-3 px-4 text-left font-medium whitespace-nowrap">Tên môn học</th>
              <th className="py-3 px-4 text-left font-medium whitespace-nowrap">Số tín chỉ</th>
              <th className="py-3 px-4 text-left font-medium">Mô tả</th>
              <th className="py-3 px-4 text-left font-medium">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            {subjects.map((subject) => (
              <tr key={subject.id} className="border-t">
                <td className="py-3 px-4 whitespace-nowrap">{subject.code}</td>
                <td className="py-3 px-4 whitespace-nowrap">{subject.name}</td>
                <td className="py-3 px-4">{subject.credits}</td>
                <td className="py-3 px-4 min-w-[200px] break-words">{subject.description}</td>
                <td className="py-3 px-4">
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => {
                      setSelectedSubject(subject)
                      setIsDialogOpen(true)
                    }}
                    className="text-xs sm:text-sm flex-shrink-0 bg-black text-white hover:bg-black hover:text-white hover:opacity-100"
                  >
                    Chỉnh sửa
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Dialog tạo/chỉnh sửa môn học */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-md w-full">
          <DialogHeader>
            <DialogTitle>
              {selectedSubject ? "Chỉnh sửa môn học" : "Thêm môn học mới"}
            </DialogTitle>
            <DialogDescription>
              {selectedSubject
                ? "Cập nhật thông tin môn học"
                : "Nhập thông tin để thêm môn học mới"}
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleFormSubmit} className="space-y-4 pt-4">
            <div className="flex items-center gap-4">
              <p className="w-28">Mã môn học:</p>
              <Input
                id="code"
                name="code"
                defaultValue={selectedSubject?.code}
                required
                className="flex-1"
              />
            </div>

            <div className="flex items-center gap-4 mt-4">
              <p className="w-28">Tên môn học:</p>
              <Input
                id="name"
                name="name"
                defaultValue={selectedSubject?.name}
                required
                className="flex-1"
              />
            </div>

            <div className="flex items-center gap-4 mt-4">
              <p className="w-28">Số tín chỉ:</p>
              <Input
                id="credits"
                name="credits"
                type="number"
                min="1"
                max="10"
                defaultValue={selectedSubject?.credits}
                required
                className="flex-1"
              />
            </div>

            <div className="flex items-start gap-4 mt-4">
              <p className="w-28 pt-1">Mô tả:</p>
              <Textarea
                id="description"
                name="description"
                defaultValue={selectedSubject?.description || ''}
                rows={3}
                className="flex-1"
              />
            </div>

            <DialogFooter className="flex flex-col sm:flex-row gap-2 sm:gap-4 pt-4">
              <Button
                type="button"
                variant="outline"
                className="w-full sm:w-auto"
                onClick={() => setIsDialogOpen(false)}
              >
                Hủy
              </Button>
              <Button
                type="submit"
                disabled={isLoading}
                className="w-full sm:w-auto"
              >
                {selectedSubject ? "Cập nhật" : "Thêm mới"}
              </Button>
            </DialogFooter>

          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
}