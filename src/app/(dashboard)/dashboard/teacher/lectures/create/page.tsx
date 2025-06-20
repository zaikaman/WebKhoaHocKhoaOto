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
  const [selectedFiles, setSelectedFiles] = useState<{ vie?: FileWithPreview; eng?: FileWithPreview }>({})
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

  const handleFileChange = (lang: 'vie' | 'eng') => (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files
    if (files && files.length > 0) {
      const file = files[0]
      setSelectedFiles(prev => ({ ...prev, [lang]: {
        file,
        preview: URL.createObjectURL(file),
        size: file.size,
        type: file.type
      }}))
    }
  }

  const handleRemoveFile = (lang: 'vie' | 'eng') => {
    setSelectedFiles(prev => {
      const newFiles = { ...prev }
      delete newFiles[lang]
      return newFiles
    })
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
        // download_count: 0 // Nếu DB không có default, mở dòng này
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
        // Upload từng file nếu có
        let fileUrls: string[] = []
        let fileTypes: string[] = []
        let originalFilenames: string[] = []
        let totalFileSize = 0
        if (selectedFiles.vie) {
          const uploadedVie = await uploadLectureFile(selectedFiles.vie.file)
          fileUrls[0] = uploadedVie.url
          fileTypes[0] = uploadedVie.file_type
          originalFilenames[0] = uploadedVie.original_filename
          totalFileSize += uploadedVie.file_size
        }
        if (selectedFiles.eng) {
          const uploadedEng = await uploadLectureFile(selectedFiles.eng.file)
          fileUrls[1] = uploadedEng.url
          fileTypes[1] = uploadedEng.file_type
          originalFilenames[1] = uploadedEng.original_filename
          totalFileSize += uploadedEng.file_size
        }
        // Xử lý trường hợp không có file nào
        if (!fileUrls[0] && !fileUrls[1]) {
          throw new Error('Vui lòng chọn ít nhất một file')
        }
        // Nếu chỉ có 1 file, không join chuỗi
        if (fileUrls.length === 1 || (!fileUrls[1] && fileUrls[0])) {
          lectureData = {
            ...lectureData,
            file_url: fileUrls[0],
            file_type: fileTypes[0],
            file_size: totalFileSize,
            original_filename: originalFilenames[0]
          }
        } else {
          // Có cả 2 file
          lectureData = {
            ...lectureData,
            file_url: fileUrls.join('|||'),
            file_type: fileTypes.join('|||'),
            file_size: totalFileSize,
            original_filename: originalFilenames.join('|||')
          }
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
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-2">
                {/* File tiếng Việt */}
                <div className="bg-white border border-blue-300 rounded-xl shadow-sm p-5 flex flex-col gap-3">
                  <div className="flex items-center gap-2 mb-1">
                    <FileUpIcon className="h-6 w-6 text-blue-500" />
                    <span className="font-semibold text-blue-700 text-base">File tiếng Việt (vie)</span>
                  </div>
                  <p className="text-xs text-gray-500 mb-2">Chọn file tài liệu tiếng Việt (PDF, DOC, DOCX, PPT, PPTX)</p>
                  <label className="relative flex flex-col items-center justify-center border-2 border-dashed border-blue-400 rounded-lg p-4 hover:border-blue-500 transition-colors cursor-pointer min-h-[120px]">
                    <input
                      type="file"
                      name="lecture_file_vie"
                      accept=".pdf,.doc,.docx,.ppt,.pptx"
                      onChange={handleFileChange('vie')}
                      className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                    />
                    {selectedFiles.vie ? (
                      <>
                        <span className="text-blue-700 font-medium">{selectedFiles.vie.file.name}</span>
                        <span className="text-xs text-gray-500">{(selectedFiles.vie.size / (1024 * 1024)).toFixed(2)} MB</span>
                        <button type="button" onClick={e => { e.stopPropagation(); handleRemoveFile('vie') }} className="mt-2 px-2 py-1 text-xs rounded bg-red-100 text-red-600 hover:bg-red-200">Xóa file</button>
                      </>
                    ) : (
                      <>
                        <FileUpIcon className="h-8 w-8 text-blue-400 mb-2" />
                        <span className="text-sm text-blue-600">Nhấn để chọn hoặc kéo thả file vào đây</span>
                      </>
                    )}
                  </label>
                </div>
                {/* File tiếng Anh */}
                <div className="bg-white border border-green-300 rounded-xl shadow-sm p-5 flex flex-col gap-3">
                  <div className="flex items-center gap-2 mb-1">
                    <FileUpIcon className="h-6 w-6 text-green-500" />
                    <span className="font-semibold text-green-700 text-base">File tiếng Anh (eng)</span>
                  </div>
                  <p className="text-xs text-gray-500 mb-2">Chọn file tài liệu tiếng Anh (PDF, DOC, DOCX, PPT, PPTX)</p>
                  <label className="relative flex flex-col items-center justify-center border-2 border-dashed border-green-400 rounded-lg p-4 hover:border-green-500 transition-colors cursor-pointer min-h-[120px]">
                    <input
                      type="file"
                      name="lecture_file_eng"
                      accept=".pdf,.doc,.docx,.ppt,.pptx"
                      onChange={handleFileChange('eng')}
                      className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                    />
                    {selectedFiles.eng ? (
                      <>
                        <span className="text-green-700 font-medium">{selectedFiles.eng.file.name}</span>
                        <span className="text-xs text-gray-500">{(selectedFiles.eng.size / (1024 * 1024)).toFixed(2)} MB</span>
                        <button type="button" onClick={e => { e.stopPropagation(); handleRemoveFile('eng') }} className="mt-2 px-2 py-1 text-xs rounded bg-red-100 text-red-600 hover:bg-red-200">Xóa file</button>
                      </>
                    ) : (
                      <>
                        <FileUpIcon className="h-8 w-8 text-green-400 mb-2" />
                        <span className="text-sm text-green-600">Nhấn để chọn hoặc kéo thả file vào đây</span>
                      </>
                    )}
                  </label>
                </div>
              </div>
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
