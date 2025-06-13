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
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const fileFormRef = useRef<HTMLFormElement>(null)
  const videoFormRef = useRef<HTMLFormElement>(null)

  // Thêm hàm xử lý khi file thay đổi
  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0] || null
    if (file) {
      // Kiểm tra kích thước file (ví dụ: giới hạn 100MB)
      if (file.size > 100 * 1024 * 1024) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "File không được vượt quá 100MB"
        })
        return
      }
      setSelectedFile(file)
    }
  }

  // Thêm hàm xóa file đã chọn
  const handleRemoveFile = () => {
    setSelectedFile(null)
    if (fileFormRef.current) {
      fileFormRef.current.reset()
    }
  }

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
        file_url: fileUrl.url,
        file_type: file.type,
        file_size: file.size,
        original_filename: fileUrl.original_filename
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

      // Kiểm tra URL có phải từ YouTube không
      if (!videoUrl.includes('youtube.com') && !videoUrl.includes('youtu.be')) {
        throw new Error('Chỉ chấp nhận link video từ YouTube')
      }

      // Tạo bản ghi lecture với video URL
      const result = await createLecture({
        class_id: classId,
        title,
        description,
        file_url: videoUrl,
        file_type: 'video',
        file_size: 0,
        original_filename: null
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
              <Label htmlFor="file">
                File bài giảng
              </Label>
              <div className="mt-1">
                {!selectedFile ? (
                  <label 
                    htmlFor="file" 
                    className="flex items-center justify-center w-full h-32 px-4 transition bg-white border-2 border-dashed border-blue-400 rounded-lg appearance-none cursor-pointer hover:border-blue-500 focus:outline-none">
                    <div className="flex flex-col items-center space-y-2">
                      <FileUpIcon className="w-6 h-6 text-blue-500"/>
                      <span className="font-medium text-sm text-gray-600">
                        Kéo thả file vào đây hoặc click để chọn file
                      </span>
                      <span className="text-xs text-gray-500">
                        (Định dạng hỗ trợ: PDF, DOC, DOCX, PPT, PPTX)
                      </span>
                    </div>
                  </label>
                ) : (
                  <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-3">
                        <FileUpIcon className="w-8 h-8 text-blue-500"/>
                        <div>
                          <p className="text-sm font-medium text-gray-700">{selectedFile.name}</p>
                          <p className="text-xs text-gray-500">
                            {(selectedFile.size / (1024 * 1024)).toFixed(2)} MB
                          </p>
                        </div>
                      </div>
                      <button
                        type="button"
                        onClick={handleRemoveFile}
                        className="text-sm text-red-500 hover:text-red-700"
                      >
                        Xóa
                      </button>
                    </div>
                  </div>
                )}
                <Input
                  id="file"
                  name="file"
                  type="file"
                  className="hidden"
                  required
                  accept=".pdf,.doc,.docx,.ppt,.pptx"
                  onChange={handleFileChange}
                />
              </div>
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
      placeholder="Nhập tiêu đề bài giảng"
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
      placeholder="Nhập mô tả về nội dung bài giảng"
      rows={3}
      className="w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
    />
  </div>

  {/* Link video */}
  <div className="space-y-1">
    <Label htmlFor="videoUrl" >
      Link bài giảng từ YouTube
    </Label>
    <Input
      id="videoUrl"
      name="videoUrl"
      type="url"
      placeholder="Nhập link video YouTube (youtube.com hoặc youtu.be)"
      required
      pattern="^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+"
      title="Chỉ chấp nhận link từ YouTube"
      className="w-full rounded-lg border border-gray-300 p-2 focus:border-blue-500 focus:ring focus:ring-blue-200"
    />
    <p className="text-xs text-gray-500 mt-1">
      Chỉ chấp nhận link video từ YouTube (youtube.com hoặc youtu.be)
    </p>
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