"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { getLecture, updateLecture, uploadLectureFile } from '@/lib/supabase'
import { FileUpIcon, XIcon } from "lucide-react"

type FileWithPreview = {
  file: File;
  preview: string;
  size: number;
  type: string;
}

export default function EditLecturePage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [selectedFiles, setSelectedFiles] = useState<FileWithPreview[]>([])
  const [uploadMethod, setUploadMethod] = useState<'url' | 'upload'>('url')
  const [fileUrl, setFileUrl] = useState('')
  const [lecture, setLecture] = useState<any>(null)

  useEffect(() => {
    loadLecture()
  }, [])

  async function loadLecture() {
    try {
      const lectureData = await getLecture(params.id)
      if (!lectureData) {
        throw new Error('Không tìm thấy bài giảng')
      }

      // Parse thông tin file từ file_url
      const fileUrls = lectureData.file_url?.split('|||') || []
      const fileTypes = lectureData.file_type?.split('|||') || []

      if (fileUrls.length > 0) {
        if (fileTypes[0] === 'url') {
          setUploadMethod('url')
          setFileUrl(fileUrls[0])
        } else {
          setUploadMethod('upload')
          // Tạo FileWithPreview giả cho các file đã upload
          setSelectedFiles(fileUrls.map((url: string, index: number) => ({
            file: new File([], `file${index + 1}`),
            preview: url,
            size: 0,
            type: fileTypes[index] || ''
          })))
        }
      }

      setLecture(lectureData)
    } catch (error) {
      console.error('Lỗi khi tải bài giảng:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: 'Không thể tải thông tin bài giảng'
      })
      router.push('/dashboard/teacher/lectures')
    }
  }

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files
    if (files) {
      const newFiles = Array.from(files).map(file => ({
        file,
        preview: URL.createObjectURL(file),
        size: file.size,
        type: file.type
      }))
      
      // Chỉ cho phép chọn 1 file khi đang sửa
      if (newFiles.length > 1) {
        toast({
          variant: 'destructive',
          title: 'Lỗi',
          description: 'Chỉ được chọn 1 file để thay thế'
        })
        return
      }

      setSelectedFiles(newFiles)
    }
  }

  const handleRemoveFile = () => {
    setSelectedFiles([])
  }

  async function handleUpdateLecture(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      
      let lectureData: any = {
        title: formData.get('title') as string,
        description: formData.get('description') as string,
      }

      if (uploadMethod === 'url') {
        if (!fileUrl) {
          throw new Error('Vui lòng nhập link bài giảng')
        }
        lectureData = {
          ...lectureData,
          file_url: fileUrl,
          file_type: 'url',
          file_size: 0
        }
      } else {
        if (selectedFiles.length === 0) {
          throw new Error('Vui lòng chọn file để thay thế')
        }

        // Upload file mới
        const newFile = selectedFiles[0]
        const uploadedFileUrl = await uploadLectureFile(newFile.file)
        
        // Nếu có file thứ hai, giữ nguyên file thứ hai
        if (lecture.file_url.includes('|||')) {
          const secondFileUrl = lecture.file_url.split('|||')[1]
          const secondFileType = lecture.file_type.split('|||')[1]
          lectureData = {
            ...lectureData,
            file_url: `${uploadedFileUrl.url}|||${secondFileUrl}`,
            file_type: `${uploadedFileUrl.file_type}|||${secondFileType}`,
            file_size: uploadedFileUrl.file_size + (lecture.file_size - parseInt(lecture.file_url.split('|||')[0].split('/').pop()?.split('.')[1] || '0'))
          }
        } else {
          lectureData = {
            ...lectureData,
            file_url: uploadedFileUrl.url,
            file_type: uploadedFileUrl.file_type,
            file_size: uploadedFileUrl.file_size
          }
        }
      }
      
      await updateLecture(params.id, lectureData)
      toast({
        title: 'Thành công',
        description: 'Đã cập nhật bài giảng'
      })
      router.push('/dashboard/teacher/lectures')
    } catch (error) {
      console.error('Lỗi khi cập nhật bài giảng:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: error instanceof Error ? error.message : 'Không thể cập nhật bài giảng'
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (!lecture) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  return (
    <div className="container mx-auto pb-8 px-4 md:px-6 lg:px-8 max-w-4xl">
      <div className="bg-white rounded-lg shadow-sm px-6 pb-6 md:px-8 md:pb-8">
        <div className="mb-8">
          <h2 className="text-3xl font-bold tracking-tight">Chỉnh sửa bài giảng</h2>
          <p className="text-muted-foreground mt-2">Cập nhật thông tin bài giảng bên dưới</p>
        </div>

        <form onSubmit={handleUpdateLecture} className="space-y-6">
          <div className="space-y-2">
            <label className="text-sm font-medium">Tiêu đề</label>
            <Input name="title" defaultValue={lecture.title} required className="w-full" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Mô tả</label>
            <Textarea name="description" defaultValue={lecture.description} required className="w-full min-h-[120px]" />
          </div>

          <div className="space-y-4 pt-4 border-t">
            <div className="flex items-center gap-6">
              <label className="inline-flex items-center">
                <input
                  type="radio"
                  name="uploadMethod"
                  value="url"
                  checked={uploadMethod === 'url'}
                  onChange={() => setUploadMethod('url')}
                  className="form-radio text-primary"
                />
                <span className="ml-2">Nhập link</span>
              </label>
              <label className="inline-flex items-center">
                <input
                  type="radio"
                  name="uploadMethod"
                  value="upload"
                  checked={uploadMethod === 'upload'}
                  onChange={() => setUploadMethod('upload')}
                  className="form-radio text-primary"
                />
                <span className="ml-2">Upload file</span>
              </label>
            </div>
          </div>

          {uploadMethod === 'url' ? (
            <div className="space-y-2">
              <label className="text-sm font-medium">Link bài giảng</label>
              <Input
                name="file_url"
                value={fileUrl}
                onChange={(e) => setFileUrl(e.target.value)}
                placeholder="Nhập link video YouTube (youtube.com hoặc youtu.be)"
                required
                className="w-full"
              />
            </div>
          ) : (
            <div className="space-y-2">
              <label className="text-sm font-medium">Upload file bài giảng</label>
              <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors">
                <div className="flex flex-col items-center justify-center space-y-4">
                  <FileUpIcon className="h-12 w-12 text-blue-500" />
                  <div className="text-center">
                    <p className="text-base font-medium text-blue-600">Chọn file để tải lên</p>
                    <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                    <p className="text-xs text-muted-foreground mt-2">
                      Định dạng hỗ trợ: PDF, DOC, DOCX, PPT, PPTX
                    </p>
                  </div>
                  <input
                    type="file"
                    name="lecture_files"
                    accept=".pdf,.doc,.docx,.ppt,.pptx"
                    onChange={handleFileChange}
                    className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                  />
                </div>
              </div>

              {selectedFiles.length > 0 && (
                <div className="mt-4 space-y-2">
                  {selectedFiles.map((file, index) => (
                    <div key={index} className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-3">
                          <FileUpIcon className="w-8 h-8 text-blue-500"/>
                          <div>
                            <p className="text-sm font-medium text-gray-700">{file.file.name}</p>
                            <p className="text-xs text-gray-500">
                              {(file.size / (1024 * 1024)).toFixed(2)} MB
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
                  ))}
                </div>
              )}

              <div className="mt-4 p-4 bg-gray-50 rounded-lg">
                <p className="text-sm text-gray-600">File hiện tại: {lecture.file_url.split('|||')[0].split('/').pop()}</p>
                {lecture.file_url.includes('|||') && (
                  <p className="text-sm text-gray-600 mt-2">File thứ hai: {lecture.file_url.split('|||')[1].split('/').pop()}</p>
                )}
              </div>
            </div>
          )}

          <div className="flex justify-end space-x-4 pt-6">
            <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
            <Button type="submit" disabled={isLoading}>
              {isLoading ? 'Đang cập nhật...' : 'Cập nhật bài giảng'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
}