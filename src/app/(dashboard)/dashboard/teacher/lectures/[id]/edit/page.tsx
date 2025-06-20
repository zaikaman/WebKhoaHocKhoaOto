"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { getLecture, updateLecture, uploadLectureFile } from '@/lib/supabase'
import { FileUpIcon, XIcon, ArrowLeft } from "lucide-react"

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
  const [selectedFiles, setSelectedFiles] = useState<{ vie?: FileWithPreview; eng?: FileWithPreview }>({})
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
      const originalFilenames = lectureData.original_filename?.split('|||') || []

      let filesObj: { vie?: FileWithPreview; eng?: FileWithPreview } = {}
      if (fileUrls.length > 0) {
        if (fileTypes[0] === 'url') {
          setUploadMethod('url')
          setFileUrl(fileUrls[0])
        } else {
          setUploadMethod('upload')
          // Gán file cho từng ngôn ngữ dựa vào vị trí 0: vie, 1: eng
          if (fileUrls[0]) {
            filesObj.vie = {
              file: new File([], originalFilenames[0] || `file1`),
              preview: fileUrls[0],
              size: 0,
              type: fileTypes[0] || ''
            }
          }
          if (fileUrls[1]) {
            filesObj.eng = {
              file: new File([], originalFilenames[1] || `file2`),
              preview: fileUrls[1],
              size: 0,
              type: fileTypes[1] || ''
            }
          }
        }
      }
      setSelectedFiles(filesObj)
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
          file_size: 0,
          original_filename: null
        }
      } else {
        // Lấy dữ liệu cũ
        let fileUrls = lecture.file_url?.split('|||') || []
        let fileTypes = lecture.file_type?.split('|||') || []
        let originalFilenames = lecture.original_filename?.split('|||') || []
        let fileSizes = lecture.file_size?.toString().split('|||') || []
        let totalFileSize = 0
        // vie
        if (selectedFiles.vie) {
          const uploadedVie = await uploadLectureFile(selectedFiles.vie.file)
          fileUrls[0] = uploadedVie.url
          fileTypes[0] = uploadedVie.file_type
          originalFilenames[0] = uploadedVie.original_filename
          fileSizes[0] = uploadedVie.file_size.toString()
        }
        // eng
        if (selectedFiles.eng) {
          const uploadedEng = await uploadLectureFile(selectedFiles.eng.file)
          fileUrls[1] = uploadedEng.url
          fileTypes[1] = uploadedEng.file_type
          originalFilenames[1] = uploadedEng.original_filename
          fileSizes[1] = uploadedEng.file_size.toString()
        }
        // Tính tổng dung lượng
        totalFileSize = fileSizes.reduce((sum: number, size: string) => sum + (parseInt(size) || 0), 0)
        // Xử lý trường hợp chỉ có 1 file
        const filteredUrls = fileUrls.filter(Boolean)
        const filteredTypes = fileTypes.filter(Boolean)
        const filteredNames = originalFilenames.filter(Boolean)
        if (filteredUrls.length === 1) {
          lectureData = {
            ...lectureData,
            file_url: filteredUrls[0],
            file_type: filteredTypes[0],
            file_size: totalFileSize,
            original_filename: filteredNames[0]
          }
        } else {
          lectureData = {
            ...lectureData,
            file_url: filteredUrls.join('|||'),
            file_type: filteredTypes.join('|||'),
            file_size: totalFileSize,
            original_filename: filteredNames.join('|||')
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
    <div className="container mx-auto pb-8 px-2 sm:px-4 md:px-6 lg:px-8 max-w-4xl">
      <div className="bg-white rounded-lg shadow-sm px-2 sm:px-4 md:px-8 pb-6 md:pb-8">
        <div className="pt-4 pb-2">
          <Button variant="ghost" type="button" onClick={() => router.back()} className="flex items-center gap-2 px-0">
            <ArrowLeft className="w-5 h-5 mr-1" />
            Quay lại
          </Button>
        </div>
        <div className="mb-8">
          <h2 className="text-2xl sm:text-3xl font-bold tracking-tight">Chỉnh sửa bài giảng</h2>
          <p className="text-muted-foreground mt-2 text-sm sm:text-base">Cập nhật thông tin bài giảng bên dưới</p>
        </div>

        <form onSubmit={handleUpdateLecture} className="space-y-6">
          <div className="space-y-2">
            <label className="text-sm font-medium">Tiêu đề</label>
            <Input name="title" defaultValue={lecture.title} required className="w-full" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Mô tả</label>
            <Textarea name="description" defaultValue={lecture.description} required className="w-full min-h-[100px] sm:min-h-[120px]" />
          </div>

          <div className="space-y-4 pt-4 border-t">
            <div className="flex flex-col sm:flex-row items-start sm:items-center gap-2 sm:gap-6">
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
                  <div className="mt-2 p-2 bg-gray-50 rounded-lg text-xs text-gray-600 border border-gray-200">
                    File hiện tại: <span className="font-medium">{lecture.original_filename?.split('|||')[0] || lecture.file_url?.split('|||')[0]?.split('/').pop() || 'Chưa có'}</span>
                  </div>
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
                  <div className="mt-2 p-2 bg-gray-50 rounded-lg text-xs text-gray-600 border border-gray-200">
                    File hiện tại: <span className="font-medium">{lecture.original_filename?.split('|||')[1] || lecture.file_url?.split('|||')[1]?.split('/').pop() || 'Chưa có'}</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          <div className="flex flex-col sm:flex-row justify-end space-y-2 sm:space-y-0 sm:space-x-4 pt-6">
            <Button variant="outline" type="button" className="w-full sm:w-auto" onClick={() => router.back()}>Hủy</Button>
            <Button type="submit" disabled={isLoading} className="w-full sm:w-auto">
              {isLoading ? 'Đang cập nhật...' : 'Cập nhật bài giảng'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
}