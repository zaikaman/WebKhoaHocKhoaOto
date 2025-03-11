"use client"

import { useState, useEffect, useRef } from "react"
import { useRouter, useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useToast } from "@/components/ui/use-toast"
import { getLecture, updateLecture, uploadLectureFile, deleteLectureFile } from "@/lib/supabase"
import { FileUpIcon, XIcon } from "lucide-react"

export default function LectureEditPage() {
  const router = useRouter()
  const params = useParams()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [lecture, setLecture] = useState<any>(null)
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    file_url: "",
  })

  useEffect(() => {
    loadLecture()
  }, [])

  async function loadLecture() {
    try {
      const lectureData = await getLecture(params.id as string)
      setLecture(lectureData)
      setFormData({
        title: lectureData.title,
        description: lectureData.description || "",
        file_url: lectureData.file_url || "",
      })
    } catch (error) {
      console.error("Lỗi khi tải bài giảng:", error)
      toast({
        variant: "destructive", 
        title: "Lỗi",
        description: "Không thể tải thông tin bài giảng"
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value
    }))
  }

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (file) {
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

  const handleRemoveFile = () => {
    setSelectedFile(null)
    if (fileInputRef.current) {
      fileInputRef.current.value = ''
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)

    try {
      let updatedFileUrl = formData.file_url

      if (lecture.file_type === 'video') {
        // Kiểm tra URL YouTube
        if (!formData.file_url.includes('youtube.com') && !formData.file_url.includes('youtu.be')) {
          throw new Error('Chỉ chấp nhận link video từ YouTube')
        }
        updatedFileUrl = formData.file_url
      } else {
        // Kiểm tra file mới
        if (!selectedFile && !formData.file_url) {
          throw new Error('Vui lòng chọn file')
        }
        
        if (selectedFile) {
          // Xóa file cũ nếu có
          if (formData.file_url) {
            await deleteLectureFile(formData.file_url)
          }
          // Upload file mới
          updatedFileUrl = await uploadLectureFile(selectedFile)
        }
      }

      await updateLecture(params.id as string, {
        title: formData.title,
        description: formData.description,
        file_url: updatedFileUrl,
        ...(selectedFile && {
          file_type: selectedFile.type,
          file_size: selectedFile.size
        })
      })

      toast({
        title: "Thành công",
        description: "Đã cập nhật bài giảng"
      })

      router.back()
    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể cập nhật bài giảng"
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg font-medium">Đang tải...</div>
      </div>
    )
  }

  if (!lecture) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg font-medium">Không tìm thấy bài giảng</div>
      </div>
    )
  }

  return (
    <div className="w-full px-20 py-0 space-y-2">
      <div className="flex items-center justify-between bg-white p-6 rounded-lg shadow-sm">
        <div>
          <h2 className="text-3xl font-bold tracking-tight text-gray-900">Chỉnh sửa bài giảng</h2>
          <p className="mt-1 text-gray-500">Cập nhật thông tin bài giảng</p>
        </div>
        <Button variant="outline" onClick={() => router.back()} className="hover:bg-gray-100">
          Quay lại
        </Button>
      </div>

      <form onSubmit={handleSubmit} className="bg-white p-6 rounded-lg shadow-sm space-y-6">
        <div className="space-y-4">
          <div>
            <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-1">
              Tiêu đề
            </label>
            <Input
              id="title"
              name="title"
              value={formData.title}
              onChange={handleInputChange}
              required
              className="w-full"
            />
          </div>

          <div>
            <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-1">
              Mô tả
            </label>
            <Textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleInputChange}
              rows={4}
              className="w-full"
            />
          </div>

          {lecture.file_type === 'video' ? (
            <div>
              <label htmlFor="file_url" className="block text-sm font-medium text-gray-700 mb-1">
                Link YouTube
              </label>
              <Input
                id="file_url"
                name="file_url"
                type="url"
                value={formData.file_url}
                onChange={handleInputChange}
                placeholder="Nhập link video YouTube"
                pattern="^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+"
                title="Chỉ chấp nhận link từ YouTube"
                required
                className="w-full"
              />
              <p className="text-xs text-gray-500 mt-1">
                Chỉ chấp nhận link video từ YouTube (youtube.com hoặc youtu.be)
              </p>
            </div>
          ) : (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                File bài giảng ( bài giảng cũ sẽ được ghi đè khi bạn upload file mới ) :
              </label>
              {!selectedFile && formData.file_url && (
                <div className="flex items-center gap-2 p-3 bg-blue-50 border border-blue-200 rounded-lg mb-3">
                  <FileUpIcon className="text-blue-500" size={20} />
                  <span className="text-sm text-blue-700">File hiện tại: <a href={formData.file_url} target="_blank" className="text-blue-700 hover:underline">Ở ĐÂY</a></span>
                </div>
              )}
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
                  ref={fileInputRef}
                  type="file"
                  accept=".pdf,.doc,.docx,.ppt,.pptx"
                  onChange={handleFileChange}
                  className="hidden"
                />
              </div>
            </div>
          )}
        </div>

        <Button 
          type="submit" 
          disabled={isLoading}
          className="w-full bg-blue-600 hover:bg-blue-700 text-white"
        >
          {isLoading ? "Đang lưu..." : "Lưu thay đổi"}
        </Button>
      </form>
    </div>
  )
}