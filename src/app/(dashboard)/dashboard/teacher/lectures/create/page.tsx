"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { createLecture, getTeacherClasses, uploadLectureFile, getCurrentUser } from '@/lib/supabase'
import { FileUpIcon, XIcon } from "lucide-react"

type FileWithPreview = {
  file: File;
  preview: string;
  size: number;
  type: string;
}

export default function CreateLecturePage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [selectedFiles, setSelectedFiles] = useState<FileWithPreview[]>([])
  const [uploadMethod, setUploadMethod] = useState<'url' | 'upload'>('url')
  const [fileUrl, setFileUrl] = useState('')
  const [classes, setClasses] = useState<any[]>([])

  useEffect(() => {
    loadClasses()
  }, [])

  async function loadClasses() {
    try {
      const currentUser = await getCurrentUser()
      if (!currentUser) {
        router.push('/login')
        return
      }
      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses)
    } catch (error) {
      console.error('Lỗi khi tải danh sách lớp:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: 'Không thể tải danh sách lớp'
      })
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
      
      // Chỉ cho phép chọn tối đa 2 file
      if (selectedFiles.length + newFiles.length > 2) {
        toast({
          variant: 'destructive',
          title: 'Lỗi',
          description: 'Chỉ được chọn tối đa 2 file'
        })
        return
      }

      setSelectedFiles(prev => [...prev, ...newFiles].slice(0, 2))
    }
  }

  const handleRemoveFile = (index: number) => {
    setSelectedFiles(prev => prev.filter((_, i) => i !== index))
  }

  async function handleCreateLecture(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    try {
      setIsLoading(true)
      const formData = new FormData(event.currentTarget)
      
      let lectureData: any = {
        title: formData.get('title') as string,
        description: formData.get('description') as string,
        class_id: formData.get('class_id') as string,
      }

      if (uploadMethod === 'url') {
        if (!fileUrl) {
          throw new Error('Vui lòng nhập link bài giảng')
        }
        lectureData = {
          ...lectureData,
          file_url: fileUrl,
          file_type: 'url',
          file_size: 0,
          original_filename: null
        }
      } else {
        if (selectedFiles.length === 0) {
          throw new Error('Vui lòng chọn ít nhất một file')
        }

        // Upload file đầu tiên
        const firstFile = selectedFiles[0]
        const uploadedFileUrl = await uploadLectureFile(firstFile.file)
        let fileUrl = uploadedFileUrl.url
        let fileType = uploadedFileUrl.file_type
        let fileSize = uploadedFileUrl.file_size
        let originalFilename = uploadedFileUrl.original_filename

        // Nếu có file thứ hai, upload và nối URL
        if (selectedFiles.length > 1) {
          const secondFile = selectedFiles[1]
          const secondFileUrl = await uploadLectureFile(secondFile.file)
          fileUrl = `${fileUrl}|||${secondFileUrl.url}`
          fileType = `${fileType}|||${secondFileUrl.file_type}`
          fileSize = fileSize + secondFileUrl.file_size
          originalFilename = `${originalFilename}|||${secondFileUrl.original_filename}`
        }

        lectureData = {
          ...lectureData,
          file_url: fileUrl,
          file_type: fileType,
          file_size: fileSize,
          original_filename: originalFilename
        }
      }
      
      await createLecture(lectureData)
      toast({
        title: 'Thành công',
        description: 'Đã tạo bài giảng mới'
      })
      router.push('/dashboard/teacher/lectures')
    } catch (error) {
      console.error('Lỗi khi tạo bài giảng:', error)
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: error instanceof Error ? error.message : 'Không thể tạo bài giảng'
      })
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="container mx-auto pb-8 px-4 md:px-6 lg:px-8 max-w-4xl">
      <div className="bg-white rounded-lg shadow-sm px-6 pb-6 md:px-8 md:pb-8">
        <div className="mb-8">
          <h2 className="text-3xl font-bold tracking-tight">Tạo bài giảng mới</h2>
          <p className="text-muted-foreground mt-2">Nhập thông tin bài giảng bên dưới</p>
        </div>

        <form onSubmit={handleCreateLecture} className="space-y-6">
          <div className="space-y-2">
            <label className="text-sm font-medium">Tiêu đề</label>
            <Input name="title" required className="w-full" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Mô tả</label>
            <Textarea name="description" required className="w-full min-h-[120px]" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Lớp học</label>
            <select name="class_id" required className="w-full px-3 py-2 border rounded-md bg-background">
              <option value="">Chọn lớp học</option>
              {classes.map(c => (
                <option key={c.id} value={c.id}>
                  {c.code} - {c.subject.name}
                </option>
              ))}
            </select>
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
                          onClick={() => handleRemoveFile(index)}
                          className="text-sm text-red-500 hover:text-red-700"
                        >
                          Xóa
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          <div className="flex justify-end space-x-4 pt-6">
            <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
            <Button type="submit" disabled={isLoading}>
              {isLoading ? 'Đang tạo...' : 'Tạo bài giảng'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
}
