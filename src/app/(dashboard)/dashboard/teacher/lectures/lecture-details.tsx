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
import { deleteLecture, deleteLectureFile, supabase } from '@/lib/supabase'
import type { Lecture } from '@/lib/supabase'
import { Paperclip, Download, Trash2 } from 'lucide-react'

interface LectureDetailProps {
  lecture: Lecture
  onDelete: () => void
}

export function LectureDetail({ lecture, onDelete }: LectureDetailProps) {
  const { toast } = useToast()
  const [isOpen, setIsOpen] = useState(false)
  const [isDeleting, setIsDeleting] = useState(false)

  async function handleDelete() {
    if (!lecture.lecture_files) {
        return
    }
    try {
      setIsDeleting(true)
      // First, delete all associated files from storage
      const deletePromises = lecture.lecture_files.map(file => deleteLectureFile(file.file_path));
      await Promise.all(deletePromises);

      // Then, delete the lecture record itself (which should cascade and delete lecture_files rows)
      await deleteLecture(lecture.id)
      
      setIsOpen(false)
      onDelete()
      toast({
        title: "Thành công",
        description: "Đã xóa bài giảng và các file liên quan."
      })
    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể xóa bài giảng."
      })
    } finally {
      setIsDeleting(false)
    }
  }

  const getPublicUrl = (filePath: string) => {
    const { data } = supabase.storage.from('lectures').getPublicUrl(filePath);
    return data.publicUrl;
  }

  const handleDownload = (filePath: string, fileName: string) => {
    const publicUrl = getPublicUrl(filePath);
    const link = document.createElement('a');
    link.href = publicUrl;
    link.download = fileName;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const getFileTypeLabel = (type: string) => {
    switch (type) {
      case 'VIE': return 'Tiếng Việt';
      case 'ENG': return 'Tiếng Anh';
      case 'SIM': return 'Mô phỏng';
      default: return 'Không xác định';
    }
  }

  

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <Button variant="ghost" size="sm" onClick={() => setIsOpen(true)}>
        Chi tiết
      </Button>

      <DialogContent className="max-w-lg">
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

          <div className="bg-muted/50 p-4 rounded-lg">
             <h4 className="text-sm font-semibold uppercase tracking-wide text-primary mb-3">
              Tài liệu đính kèm
            </h4>
            <div className="space-y-3">
            {lecture.lecture_files && lecture.lecture_files.length > 0 ? (
                lecture.lecture_files.map(file => (
                <div key={file.id} className="flex items-center justify-between p-3 bg-white border rounded-lg">
                    <div className="flex items-center gap-3">
                        <Paperclip className="w-5 h-5 text-gray-500" />
                        <div>
                            <p className="text-sm font-medium text-gray-800">{file.original_filename}</p>
                            <p className="text-xs text-gray-500">
                                Loại: {getFileTypeLabel(file.file_type)}
                            </p>
                        </div>
                    </div>
                    <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => handleDownload(file.file_path, file.original_filename)}
                    >
                        <Download size={14} className="mr-1.5"/>
                        Tải về
                    </Button>
                </div>
                ))
            ) : (
                <p className="text-sm text-muted-foreground text-center py-2">Không có tài liệu nào.</p>
            )}
            </div>
          </div>
        </div>

        <DialogFooter className="gap-2 sm:gap-0">
          <Button
            variant="destructive"
            onClick={handleDelete}
            disabled={isDeleting}
            className="w-full sm:w-auto flex items-center gap-1.5"
          >
            <Trash2 size={14} />
            {isDeleting ? "Đang xóa..." : "Xóa bài giảng"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}