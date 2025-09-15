"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { createLecture, getTeacherClasses, uploadLectureFile, getCurrentUser, createLectureFiles } from '@/lib/supabase'
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
  const [classes, setClasses] = useState<any[]>([])
  
  const [vieFile, setVieFile] = useState<File | null>(null);
  const [engFile, setEngFile] = useState<File | null>(null);
  const [simFile, setSimFile] = useState<File | null>(null);

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

  async function handleCreateLecture(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    
    const formData = new FormData(event.currentTarget)
    const title = formData.get('title') as string
    const description = formData.get('description') as string
    const class_id = formData.get('class_id') as string
    const video_url = formData.get('video_url') as string

    if (!class_id) {
        toast({ variant: "destructive", title: "Lỗi", description: "Vui lòng chọn một lớp học." });
        return;
    }

    const filesToUpload: { file: File; type: 'VIE' | 'ENG' | 'SIM' }[] = [];
    if (vieFile) filesToUpload.push({ file: vieFile, type: 'VIE' });
    if (engFile) filesToUpload.push({ file: engFile, type: 'ENG' });
    if (simFile) filesToUpload.push({ file: simFile, type: 'SIM' });

    if (!title) {
      toast({ variant: "destructive", title: "Lỗi", description: "Vui lòng nhập tiêu đề bài giảng." });
      return;
    }
    if (filesToUpload.length === 0 && !video_url) {
        toast({ variant: "destructive", title: "Lỗi", description: "Vui lòng chọn ít nhất một file để tải lên hoặc cung cấp link video." });
        return;
    }

    setIsLoading(true);
    try {
      const newLecture = await createLecture({
        class_id: class_id,
        title,
        description,
        video_url,
      });

      if (!newLecture || !newLecture.id) {
        throw new Error("Không thể tạo bài giảng mới.");
      }
      
      const lectureId = newLecture.id;

      if (filesToUpload.length > 0) {
        const uploadPromises = filesToUpload.map(fileState => 
          uploadLectureFile(fileState.file!)
        );
        
        const uploadedFiles = await Promise.all(uploadPromises);

        const lectureFilesData = filesToUpload.map((fileState, index) => ({
          lecture_id: lectureId,
          file_path: uploadedFiles[index].path,
          original_filename: uploadedFiles[index].original_filename,
          file_type: fileState.type,
        }));

        await createLectureFiles(lectureFilesData);
      }

      toast({
        title: "Thành công",
        description: "Đã tạo và tải lên bài giảng thành công."
      })

      router.push('/dashboard/teacher/lectures')

    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể tạo bài giảng."
      })
    } finally {
      setIsLoading(false)
    }
  }

  const FileUploadSlot = ({ title, accept, file, setFile, disabled }: { title: string, accept: string, file: File | null, setFile: (file: File | null) => void, disabled: boolean }) => {
    const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      const selectedFile = event.target.files?.[0] || null;
      setFile(selectedFile);
    };
  
    const handleRemoveFile = () => {
      setFile(null);
    };
  
    return (
      <div className="space-y-1">
        <label className="text-sm font-medium">{title}</label>
        <div className="mt-1">
          {!file ? (
            <label className="flex items-center justify-center w-full h-24 px-4 transition bg-white border-2 border-dashed rounded-lg appearance-none cursor-pointer hover:border-gray-400 focus:outline-none">
              <div className="flex flex-col items-center space-y-1">
                <FileUpIcon className="w-5 h-5 text-gray-500"/>
                <span className="font-medium text-xs text-gray-600">Kéo thả hoặc chọn file</span>
              </div>
              <Input type="file" className="hidden" accept={accept} onChange={handleFileChange} disabled={disabled} />
            </label>
          ) : (
            <div className="p-3 bg-gray-50 border border-gray-200 rounded-lg">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <FileUpIcon className="w-6 h-6 text-gray-600"/>
                  <div>
                    <p className="text-sm font-medium text-gray-700 truncate max-w-[200px]">{file.name}</p>
                    <p className="text-xs text-gray-500">{(file.size / (1024 * 1024)).toFixed(2)} MB</p>
                  </div>
                </div>
                <Button type="button" variant="ghost" size="icon" onClick={handleRemoveFile} disabled={disabled} className="text-red-500 hover:text-red-700">
                  <XIcon size={16} />
                </Button>
              </div>
            </div>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="container mx-auto pb-8 px-4 md:px-6 lg:px-8 max-w-5xl">
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
                  {c.name} - {c.subject.name}
                </option>
              ))}
            </select>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Link video YouTube</label>
            <Input name="video_url" className="w-full" />
          </div>

          <div className="space-y-4 pt-4 border-t">
             <FileUploadSlot title="File Tiếng Việt (VIE)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={vieFile} setFile={setVieFile} disabled={isLoading} />
             <FileUploadSlot title="File Tiếng Anh (ENG)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={engFile} setFile={setEngFile} disabled={isLoading} />
             <FileUploadSlot title="File Mô phỏng (SIM)" accept=".html,.swf" file={simFile} setFile={setSimFile} disabled={isLoading} />
          </div>

          <div className="flex justify-end space-x-4 pt-6">
            <Button variant="outline" type="button" onClick={() => router.back()}>Hủy</Button>
            <Button type="submit" disabled={isLoading}>
              {isLoading ? 'Đang tạo...' : 'Tạo bài giảng'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
}
