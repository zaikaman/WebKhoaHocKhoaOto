import { useState } from 'react'
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog"
import { deleteLecture } from '@/lib/supabase'
import type { Lecture } from '@/lib/supabase'

interface LectureDetailProps {
  lecture: Lecture
  onDelete: () => void
}

export function LectureDetail({ lecture, onDelete }: LectureDetailProps) {
  const { toast } = useToast()
  const [isOpen, setIsOpen] = useState(false)
  const [isDeleting, setIsDeleting] = useState(false)

  async function handleDelete() {
    try {
      setIsDeleting(true)
      await deleteLecture(lecture.id)
      setIsOpen(false)
      onDelete()
      toast({
        title: "Thành công",
        description: "Đã xóa bài giảng"
      })
    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể xóa bài giảng"
      })
    } finally {
      setIsDeleting(false)
    }
  }

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <Button variant="ghost" size="sm" onClick={() => setIsOpen(true)}>
        Chi tiết
      </Button>

      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle className="text-xl font-semibold text-primary">
            {lecture.title}
          </DialogTitle>
          <DialogDescription className="text-muted-foreground">
            Chi tiết bài giảng
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-6 py-4">
          <div className="bg-muted/50 p-4 rounded-lg">
            <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
              Mô tả
            </h4>
            <p className="text-sm text-muted-foreground leading-relaxed">
              {lecture.description || "Chưa có mô tả"}
            </p>
          </div>

          {lecture.file_type === 'video' ? (
            // Giao diện cho Link bài giảng
            <div className="space-y-4">
              <div className="bg-muted/50 p-4 rounded-lg">
                <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                  Link bài giảng
                </h4>
                <div className="text-sm">
                  <p className="text-muted-foreground mb-2">Link video:</p>
                  <div className="flex items-center gap-2">
                    <input 
                      type="text"
                      value={lecture.file_url}
                      readOnly
                      className="flex-1 p-2 rounded border bg-background text-sm"
                    />
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => {
                        navigator.clipboard.writeText(lecture.file_url)
                        toast({
                          title: "Đã sao chép",
                          description: "Link đã được sao chép vào clipboard"
                        })
                      }}
                    >
                      Sao chép
                    </Button>
                  </div>
                </div>
              </div>

              <div className="bg-muted/50 p-4 rounded-lg">
                <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                  Thông tin
                </h4>
                <div className="grid grid-cols-2 gap-3 text-sm">
                  <div>
                    <p className="text-muted-foreground">Loại</p>
                    <p className="font-medium">Link video</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Ngày tạo</p>
                    <p className="font-medium">
                      {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            // Giao diện cho File bài giảng
            <>
              <div className="bg-muted/50 p-4 rounded-lg">
                <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-2">
                  Thông tin file
                </h4>
                <div className="grid grid-cols-2 gap-3 text-sm">
                  <div>
                    <p className="text-muted-foreground">Loại file</p>
                    <p className="font-medium">{lecture.file_type}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Kích thước</p>
                    <p className="font-medium">{lecture.file_size}KB</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Lượt tải</p>
                    <p className="font-medium">{lecture.download_count}</p>
                  </div>
                  <div>
                    <p className="text-muted-foreground">Ngày tạo</p>
                    <p className="font-medium">
                      {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                    </p>
                  </div>
                </div>
              </div>

              <div className="flex justify-between items-center bg-muted/50 p-4 rounded-lg">
                <div>
                  <h4 className="text-sm font-semibold uppercase tracking-wide text-primary">
                    Tải xuống
                  </h4>
                  <p className="text-sm text-muted-foreground mt-1">
                    Nhấn nút bên để tải file
                  </p>
                </div>
                <Button asChild variant="outline" className="hover:bg-primary hover:text-white transition-colors">
                  <a
                    href={lecture.file_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="flex items-center gap-2"
                  >
                    Tải xuống
                  </a>
                </Button>
              </div>
            </>
          )}
        </div>

        <DialogFooter className="gap-2 sm:gap-0">
          <Button
            variant="destructive"
            onClick={handleDelete}
            disabled={isDeleting}
            className="w-full sm:w-auto"
          >
            {isDeleting ? "Đang xóa..." : "Xóa bài giảng"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}