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
      
      const fileInput = formData.get('file')
      const title = formData.get('title') as string

      if (!fileInput || !(fileInput instanceof File) || !title) {
        throw new Error('Vui lòng điền đầy đủ thông tin')
      }

      const file = fileInput as File

      // Kiểm tra định dạng file
      const allowedTypes = ['.pdf', '.doc', '.docx', '.ppt', '.pptx']
      const fileExt = file.name.substring(file.name.lastIndexOf('.')).toLowerCase()
      
      if (!allowedTypes.includes(fileExt)) {
        throw new Error('Định dạng file không được hỗ trợ')
      }

      // Upload file
      const result = await uploadLectureFile(file, classId, title)
      
      if (!result) {
        throw new Error('Không thể tải lên bài giảng')
      }

      toast({
        title: "Thành công",
        description: "Đã tải lên bài giảng"
      })

      // Reset form an toàn
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
  
      // Upload thông tin video
      const result = await uploadLectureFile({
        title,
        classId,
        fileUrl: videoUrl,
        fileType: 'video',
        fileSize: 0
      })
      
      if (!result) {
        throw new Error('Không thể lưu thông tin video')
      }
  
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
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 5v14M5 12h14"/></svg>
        Thêm bài giảng
      </Button>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold text-primary">Thêm bài giảng mới</DialogTitle>
            <DialogDescription className="text-muted-foreground">
              Tải lên bài giảng cho lớp học của bạn. Bạn có thể chọn tải lên tài liệu hoặc video.
            </DialogDescription>
          </DialogHeader>

          <Tabs defaultValue="file" className="mt-6">
            <TabsList className="grid w-full grid-cols-2 mb-6">
              <TabsTrigger value="file" className="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/></svg>
                Tài liệu
              </TabsTrigger>
              <TabsTrigger value="video" className="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polygon points="23 7 16 12 23 17 23 7"/><rect x="1" y="5" width="15" height="14" rx="2" ry="2"/></svg>
                Link
              </TabsTrigger>
            </TabsList>

            <TabsContent value="file">
              <form ref={fileFormRef} onSubmit={handleFileUpload} className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="title">Tiêu đề bài giảng</Label>
                  <Input 
                    id="title" 
                    name="title" 
                    placeholder="Nhập tiêu đề bài giảng"
                    className="focus-visible:ring-primary ml-[20px]"
                    required 
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="file" >File bài giảng</Label>
                  <div className="border-2 border-dashed rounded-lg p-4 hover:border-primary transition-colors">
                    <Input 
                      type="file"
                      name="file"
                      accept=".pdf,.doc,.docx,.ppt,.pptx"
                      className="file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:bg-primary/10 file:text-primary hover:file:bg-primary/20"
                      required
                    />
                    <p className="text-xs text-muted-foreground mt-2">Hỗ trợ: PDF, Word, PowerPoint</p>
                  </div>
                </div>

                <Button type="submit" className="w-full font-medium" disabled={isLoading}>
                  {isLoading ? (
                    <div className="flex items-center gap-2">
                      <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none"/>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
                      </svg>
                      Đang tải lên...
                    </div>
                  ) : "Tải lên"}
                </Button>
              </form>
            </TabsContent>

            <TabsContent value="video">
              <form ref={videoFormRef} onSubmit={handleVideoUpload} className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="title">Tiêu đề bài giảng</Label>
                  <Input 
                    id="title" 
                    name="title" 
                    placeholder="Nhập tiêu đề bài giảng"
                    className="focus-visible:ring-primary ml-[20px]"
                    required 
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="videoUrl">Link bài giảng</Label>
                  <Input 
                    id="videoUrl"
                    name="videoUrl"
                    type="url"
                    placeholder="Nhập link bài giảng (YouTube, Vimeo,...)"
                    className="focus-visible:ring-primary ml-[20px]"
                    required
                  />
                  <p className="text-xs text-muted-foreground mt-2">
                    Hỗ trợ: YouTube, Vimeo, Google Drive,...
                  </p>
                </div>

                <Button type="submit" className="w-full font-medium" disabled={isLoading}>
                  {isLoading ? (
                    <div className="flex items-center gap-2">
                      <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none"/>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
                      </svg>
                      Đang lưu...
                    </div>
                  ) : "Lưu video"}
                </Button>
              </form>
            </TabsContent>
          </Tabs>
        </DialogContent>
      </Dialog>
    </>
  )
}