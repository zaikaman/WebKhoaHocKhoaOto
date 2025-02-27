"use client"

import { useState, useRef } from 'react'
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { uploadLectureFile } from '@/lib/supabase'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"
import { FileUpIcon, LinkIcon } from "lucide-react"
import { createLecture } from '@/lib/supabase'

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
      const description = formData.get('description') as string

      if (!file || !title) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      // Upload file trước
      const fileUrl = await uploadLectureFile(file)
      
      // Sau đó tạo bản ghi lecture
      const result = await createLecture({
        class_id: classId,
        title,
        description,
        file_url: fileUrl,
        file_type: file.type,
        file_size: file.size
      })
      
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
      const description = formData.get('description') as string

      if (!title || !videoUrl) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      // Tạo bản ghi lecture với video URL
      const result = await createLecture({
        class_id: classId,
        title,
        description,
        file_url: videoUrl,
        file_type: 'video',
        file_size: 0
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
    <>
      <Button onClick={() => setIsOpen(true)} className="flex items-center gap-2">
        <FileUpIcon size={16} />
        Thêm bài giảng
      </Button>
      
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold">Thêm bài giảng mới</DialogTitle>
            <DialogDescription>
              Tải lên bài giảng cho lớp học của bạn
            </DialogDescription>
          </DialogHeader>

          <Tabs defaultValue="file" className="mt-4">
            <TabsList className="grid grid-cols-2 mb-4">
              <TabsTrigger value="file" className="flex items-center gap-2">
                <FileUpIcon size={16} />
                Tài liệu
              </TabsTrigger>
              <TabsTrigger value="video" className="flex items-center gap-2">
                <LinkIcon size={16} />
                Link
              </TabsTrigger>
            </TabsList>

            <TabsContent value="file">
              <form ref={fileFormRef} onSubmit={handleFileUpload} className="space-y-4">
              <div className="space-y-4 p-4 bg-white rounded-xl shadow-md">
            {/* Tiêu đề */}
            <div className="space-y-1">
              <Label htmlFor="title" >
                Tiêu đề
              </Label>
              <Input
                id="title"
                name="title"
                placeholder="Nhập tiêu đề bài giảng"
                required
                className="mt-1 w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
              />
            </div>

            {/* Mô tả */}
            <div className="space-y-1">
              <Label htmlFor="description" >
                Mô tả
              </Label>
              <Textarea
                id="description"
                name="description"
                placeholder="Nhập mô tả về nội dung bài giảng"
                rows={3}
                className="mt-1 w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
              />
            </div>

            {/* Upload File */}
            <div className="space-y-1">
              <Label htmlFor="file" >
                File
              </Label>
              <Input
                id="file"
                name="file"
                type="file"
                className="cursor-pointer w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
                required
              />
            </div>
          </div>

                
                <Button type="submit" disabled={isLoading} className="w-full">
                  {isLoading ? "Đang tải lên..." : "Tải lên"}
                </Button>
              </form>
            </TabsContent>

            <TabsContent value="video">
              <form ref={videoFormRef} onSubmit={handleVideoUpload} className="space-y-4">
                <div className="space-y-4 p-4 bg-white rounded-xl shadow-md">
                <div className="space-y-1">
    <Label htmlFor="title" >
      Tiêu đề
    </Label>
    <Input
      id="title"
      name="title"
      placeholder="Nhập tiêu đề video"
      required
      className="w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
    />
  </div>

  {/* Mô tả */}
  <div className="space-y-1">
    <Label htmlFor="description" >
      Mô tả
    </Label>
    <Textarea
      id="description"
      name="description"
      placeholder="Nhập mô tả về nội dung video"
      rows={3}
      className="w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
    />
  </div>

  {/* Link video */}
  <div className="space-y-1">
    <Label htmlFor="videoUrl" >
      Link video
    </Label>
    <Input
      id="videoUrl"
      name="videoUrl"
      type="url"
      placeholder="Nhập link video (YouTube, Drive,...)"
      required
      className="w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
    />
  </div> </div>
 
                
                <Button type="submit" disabled={isLoading} className="w-full">
                  {isLoading ? "Đang lưu..." : "Lưu"}
                </Button>
              </form>
            </TabsContent>
          </Tabs>
        </DialogContent>
      </Dialog>
    </>
  )
}