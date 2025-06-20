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
import { deleteLecture, deleteLectureFile, incrementDownloadCount } from '@/lib/supabase'
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
      await deleteLectureFile(lecture.file_url)
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

  // Hàm xử lý download với tracking
  const handleDownload = async () => {
    try {
      // Tăng download count
      const result = await incrementDownloadCount(lecture.id)
      if (result.success) {
        console.log('Download count updated:', result.newCount)
      }
      
      // Xử lý multiple URLs nếu có
      let fileUrl = lecture.file_url
      if (fileUrl.includes('|||')) {
        fileUrl = fileUrl.split('|||')[0].trim()
      }
      
      // Tiến hành download
      const link = document.createElement('a')
      link.href = fileUrl
      link.download = lecture.original_filename || lecture.title
      link.target = '_blank'
      link.rel = 'noopener noreferrer'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      
      toast({
        title: "Thành công",
        description: "File đã được tải xuống"
      })
    } catch (error) {
      console.error('Error downloading:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải xuống file"
      })
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
                    <p className="font-medium">Link</p>
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
              <div className="bg-muted/50 p-4 rounded-lg space-y-6">
                {(() => {
                  // Tách file_url, file_type, original_filename
                  const urls = lecture.file_url?.split('|||') || []
                  const types = lecture.file_type?.split('|||') || []
                  const names = lecture.original_filename?.split('|||') || []
                  const sizes = typeof lecture.file_size === 'number' ? [lecture.file_size] : (String(lecture.file_size).split('|||').map((s: string) => parseInt(s)) || [])
                  const langLabels = ['File tiếng Việt (vie)', 'File tiếng Anh (eng)']
                  return urls.filter(Boolean).map((url, idx) => (
                    <div key={idx} className="mb-4 border rounded-lg p-4 bg-white shadow-sm">
                      <div className="flex items-center gap-2 mb-2">
                        <span className={`font-semibold text-base ${idx === 0 ? 'text-blue-700' : 'text-green-700'}`}>{langLabels[idx]}</span>
                      </div>
                      <div className="grid grid-cols-2 gap-3 text-sm mb-2">
                        <div className="col-span-2">
                          <p className="text-muted-foreground">Tên file gốc</p>
                          <p className="font-medium break-all">{names[idx] || url.split('/').pop()}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Loại file</p>
                          <p className="font-medium break-all">{types[idx]}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Kích thước</p>
                          <p className="font-medium">{sizes[idx] ? (sizes[idx]/1024).toFixed(2) : '0'} MB</p>
                        </div>
                      </div>
                      <Button variant="outline" size="sm" onClick={() => {
                        const link = document.createElement('a')
                        link.href = url
                        link.download = names[idx] || url.split('/').pop() || 'file'
                        link.target = '_blank'
                        link.rel = 'noopener noreferrer'
                        document.body.appendChild(link)
                        link.click()
                        document.body.removeChild(link)
                      }}>Tải về {langLabels[idx]}</Button>
                    </div>
                  ))
                })()}
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