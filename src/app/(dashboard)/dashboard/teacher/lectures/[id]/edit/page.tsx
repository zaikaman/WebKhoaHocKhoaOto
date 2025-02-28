"use client"

import { useState, useEffect, useRef } from "react"
import { useRouter, useParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useToast } from "@/components/ui/use-toast"
import { getLecture, updateLecture, uploadLectureFile } from "@/lib/supabase"
import { Editor } from '@tinymce/tinymce-react'
import { Document, Paragraph, Packer, TextRun } from "docx"
import mammoth from "mammoth"

export default function LectureEditPage() {
  const router = useRouter()
  const params = useParams()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [lecture, setLecture] = useState<any>(null)
  const [fileContent, setFileContent] = useState<string>("")
  const [isEditing, setIsEditing] = useState(false)
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    file_url: ""
  })
  const [originalFileType, setOriginalFileType] = useState<'text' | 'docx'>('text')
  const [htmlContent, setHtmlContent] = useState<string>("")
  const editorRef = useRef<any>(null)
  const [images, setImages] = useState<{ [key: string]: string }>({})

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
        file_url: lectureData.file_url
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

  async function loadFileContent() {
    try {
      setIsLoading(true)
      const response = await fetch(formData.file_url)
      if (!response.ok) throw new Error('Không thể tải nội dung file')
      
      const fileType = lecture.file_type.toLowerCase()
      
      if (fileType === 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
        const blob = await response.blob()
        const arrayBuffer = await blob.arrayBuffer()
        
        const result = await mammoth.convertToHtml({ arrayBuffer })
        
        if (!result.value) {
          throw new Error('Không thể đọc nội dung file DOCX')
        }

        setHtmlContent(result.value)
        setOriginalFileType('docx')
        setIsEditing(true)
      } else {
        const content = await response.text()
        setHtmlContent(content)
        setOriginalFileType('text')
        setIsEditing(true)
      }
    } catch (error) {
      console.error("Lỗi khi tải nội dung file:", error)
      toast({
        variant: "destructive", 
        title: "Lỗi",
        description: "Không thể tải nội dung file"
      })
    } finally {
      setIsLoading(false)
    }
  }

  async function handleSaveContent() {
    try {
      setIsLoading(true)
      let newFileUrl;
      
      if (originalFileType === 'docx') {
        const htmlContent = editorRef.current.getContent()
        
        const doc = new Document({
          sections: [{
            properties: {},
            children: [
              new Paragraph({
                children: [
                  new TextRun(htmlContent.replace(/<[^>]*>/g, ''))
                ],
              }),
            ],
          }],
        });

        const blob = await Packer.toBlob(doc);

        const file = new File([blob], `updated_${Date.now()}.docx`, {
          type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        });

        newFileUrl = await uploadLectureFile(file)
      } else {
        const content = editorRef.current.getContent()
        const blob = new Blob([content], { type: lecture.file_type })
        const file = new File([blob], `updated_${Date.now()}.${lecture.file_type.split('/')[1]}`, {
          type: lecture.file_type
        })

        newFileUrl = await uploadLectureFile(file)
      }

      await updateLecture(params.id as string, {
        title: formData.title,
        description: formData.description,
        file_url: newFileUrl
      })

      setFormData(prev => ({ ...prev, file_url: newFileUrl }))
      setIsEditing(false)

      toast({
        title: "Thành công",
        description: "Đã cập nhật bài giảng"
      })

      await loadLecture()

    } catch (error) {
      console.error("Lỗi khi lưu nội dung:", error)
      toast({
        variant: "destructive",
        title: "Lỗi", 
        description: "Không thể lưu nội dung đã chỉnh sửa"
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)

    try {
      await updateLecture(params.id as string, {
        title: formData.title,
        description: formData.description,
        file_url: formData.file_url
      })

      toast({
        title: "Thành công",
        description: "Đã cập nhật bài giảng"
      })

      router.back()
    } catch (error) {
      console.error("Lỗi khi cập nhật:", error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể cập nhật bài giảng"
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
        <div className="text-lg font-medium">Đang tải...</div>
      </div>
    )
  }

  return (
    <div className="w-full p-6 space-y-8">
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

          {lecture.file_type === 'video' && (
            <div>
              <label htmlFor="file_url" className="block text-sm font-medium text-gray-700 mb-1">
                Link video
              </label>
              <Input
                id="file_url"
                name="file_url"
                value={formData.file_url}
                onChange={handleInputChange}
                required
                className="w-full"
              />
            </div>
          )}

          {lecture.file_type !== 'video' && (
            <div className="space-y-4">
              <label className="block text-sm font-medium text-gray-700">
                File bài giảng
              </label>
              <div className="bg-gray-50 p-4 rounded-lg border">
                <div className="flex items-center justify-between">
                  <div className="space-y-1">
                    <p className="text-sm font-medium text-gray-700">File hiện tại:</p>
                    <a 
                      href={formData.file_url}
                      target="_blank"
                      rel="noopener noreferrer" 
                      className="text-sm text-blue-600 hover:text-blue-800 hover:underline"
                    >
                      Tải xuống file
                    </a>
                  </div>
                  <div className="space-x-3">
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => window.open(formData.file_url, '_blank')}
                      className="hover:bg-gray-100"
                    >
                      Xem file
                    </Button>
                    {!isEditing && (
                      <Button
                        type="button"
                        variant="secondary"
                        onClick={loadFileContent}
                        disabled={isLoading}
                        className="hover:bg-gray-200"
                      >
                        Chỉnh sửa nội dung
                      </Button>
                    )}
                  </div>
                </div>
              </div>

              {isEditing && (
                <div className="space-y-4">
                  <div className="flex justify-between items-center">
                    <label className="text-sm font-medium text-gray-700">
                      Chỉnh sửa nội dung
                    </label>
                    <Button
                      type="button"
                      onClick={handleSaveContent}
                      disabled={isLoading}
                      className="bg-blue-600 hover:bg-blue-700 text-white"
                    >
                      Lưu nội dung
                    </Button>
                  </div>
                  <div className="border rounded-lg overflow-hidden">
                    <Editor
                      apiKey={process.env.NEXT_PUBLIC_TINYMCE_API_KEY}
                      onInit={(evt, editor) => editorRef.current = editor}
                      initialValue={htmlContent}
                      init={{
                        height: 500,
                        menubar: true,
                        plugins: [
                          'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                          'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                          'insertdatetime', 'media', 'table', 'code', 'help', 'wordcount'
                        ],
                        toolbar: 'undo redo | blocks | ' +
                          'bold italic forecolor | alignleft aligncenter ' +
                          'alignright alignjustify | bullist numlist outdent indent | ' +
                          'removeformat | help',
                        content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
                        branding: false,
                        promotion: false,
                        tracking: false,
                        send_usage_data: false
                      }}
                    />
                  </div>
                </div>
              )}
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

function getEditorLanguage(fileType: string) {
  const type = fileType.toLowerCase()
  switch (type) {
    case 'text/html':
      return 'html'
    case 'text/css':
      return 'css'
    case 'application/javascript':
    case 'text/javascript':
      return 'javascript'
    case 'application/json':
      return 'json'
    case 'text/markdown':
    case 'application/markdown':
      return 'markdown'
    case 'text/xml':
    case 'application/xml':
      return 'xml'
    default:
      return 'plaintext'
  }
}