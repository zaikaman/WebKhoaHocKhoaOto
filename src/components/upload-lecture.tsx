"use client"

import { useState, useRef } from 'react'
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { uploadLectureFile } from '@/lib/supabase'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"

interface UploadLectureProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

export function UploadLecture({ classId, onUploadSuccess }: UploadLectureProps) {
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [isOpen, setIsOpen] = useState(false)
  const fileFormRef = useRef<HTMLFormElement>(null)
  const videoFormRef = useRef<HTMLFormElement>(null)

  async function handleFileUpload(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      
      const file = formData.get('file') as File
      const title = formData.get('title') as string

      if (!file || !title) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      const result = await uploadLectureFile(file, classId, title)
      
      toast({
        title: "Thành công",
        description: "Đã tải lên bài giảng"
      })

      if (fileFormRef.current) {
        fileFormRef.current.reset()
      }
      setIsOpen(false)
      await onUploadSuccess()

    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể tải lên file"
      })
    } finally {
      setIsLoading(false)
    }
  }

  async function handleVideoUpload(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      
      const title = formData.get('title') as string
      const videoUrl = formData.get('videoUrl') as string

      if (!title || !videoUrl) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      const result = await uploadLectureFile({
        title,
        classId,
        fileUrl: videoUrl,
        fileType: 'video',
        fileSize: 0
      })

      toast({
        title: "Thành công",
        description: "Đã lưu thông tin video"
      })

      if (videoFormRef.current) {
        videoFormRef.current.reset()
      }
      setIsOpen(false)
      await onUploadSuccess()

    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể lưu video"
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <Button onClick={() => setIsOpen(true)}>
      Thêm bài giảng
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Thêm bài giảng mới</DialogTitle>
            <DialogDescription>
              Tải lên bài giảng cho lớp học của bạn
            </DialogDescription>
          </DialogHeader>

          <Tabs defaultValue="file">
            <TabsList>
              <TabsTrigger value="file">Tài liệu</TabsTrigger>
              <TabsTrigger value="video">Video</TabsTrigger>
            </TabsList>

            <TabsContent value="file">
              <form ref={fileFormRef} onSubmit={handleFileUpload}>
                <div className="space-y-4">
                  <div>
                    <Label htmlFor="title">Tiêu đề</Label>
                    <Input id="title" name="title" required />
                  </div>
                  <div>
                    <Label htmlFor="file">File</Label>
                    <Input id="file" name="file" type="file" required />
                  </div>
                  <Button type="submit" disabled={isLoading}>
                    {isLoading ? "Đang tải lên..." : "Tải lên"}
                  </Button>
                </div>
              </form>
            </TabsContent>

            <TabsContent value="video">
              <form ref={videoFormRef} onSubmit={handleVideoUpload}>
                <div className="space-y-4">
                  <div>
                    <Label htmlFor="title">Tiêu đề</Label>
                    <Input id="title" name="title" required />
                  </div>
                  <div>
                    <Label htmlFor="videoUrl">Link video</Label>
                    <Input 
                      id="videoUrl" 
                      name="videoUrl" 
                      type="url" 
                      placeholder="Nhập link video (YouTube, Drive,...)"
                      required 
                    />
                  </div>
                  <Button type="submit" disabled={isLoading}>
                    {isLoading ? "Đang lưu..." : "Lưu"}
                  </Button>
                </div>
              </form>
            </TabsContent>
          </Tabs>
        </DialogContent>
      </Dialog>
    </Button>
  )
}