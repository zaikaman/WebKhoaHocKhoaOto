"use client"

import { useState, useEffect, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { useToast } from '@/components/ui/use-toast'
import { getLecture, updateLecture, uploadLectureFile, deleteLectureFile, createLectureFiles, supabase } from '@/lib/supabase'
import type { Lecture, LectureFile } from '@/lib/supabase'
import { FileUpIcon, XIcon, ArrowLeft, Paperclip } from "lucide-react"

// This is a simplified local type for the file state
// It can hold a new File object or an existing LectureFile from the DB
type FileState = File | LectureFile;

export default function EditLecturePage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isUpdating, setIsUpdating] = useState(false)

  // Form state
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [videoUrl, setVideoUrl] = useState('');

  // File state
  const [vieFile, setVieFile] = useState<FileState | null>(null);
  const [engFile, setEngFile] = useState<FileState | null>(null);
  const [simFile, setSimFile] = useState<FileState | null>(null);

  // Keep track of initial files to detect deletions
  const [initialFiles, setInitialFiles] = useState<LectureFile[]>([]);

  const loadLecture = useCallback(async () => {
    try {
      setIsLoading(true);
      const lectureData = await getLecture(params.id);
      if (!lectureData) {
        throw new Error('Không tìm thấy bài giảng');
      }
      
      setTitle(lectureData.title);
      setDescription(lectureData.description || '');
      setVideoUrl(lectureData.video_url || '');
      setInitialFiles(lectureData.lecture_files || []);

      // Populate file states
      setVieFile(lectureData.lecture_files.find(f => f.file_type === 'VIE') || null);
      setEngFile(lectureData.lecture_files.find(f => f.file_type === 'ENG') || null);
      setSimFile(lectureData.lecture_files.find(f => f.file_type === 'SIM') || null);

    } catch (error) {
      console.error('Lỗi khi tải bài giảng:', error);
      toast({ variant: 'destructive', title: 'Lỗi', description: 'Không thể tải thông tin bài giảng' });
      router.push('/dashboard/teacher/lectures');
    } finally {
      setIsLoading(false);
    }
  }, [params.id, router, toast]);

  useEffect(() => {
    loadLecture();
  }, [loadLecture]);

  async function handleUpdateLecture(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsUpdating(true);

    try {
        // 1. Update lecture title and description
        await updateLecture(params.id, { title, description, video_url: videoUrl });

        const currentFiles: (FileState | null)[] = [vieFile, engFile, simFile];
        const fileTypes: ('VIE' | 'ENG' | 'SIM')[] = ['VIE', 'ENG', 'SIM'];

        // 2. Handle file deletions and additions/updates
        for (let i = 0; i < fileTypes.length; i++) {
            const type = fileTypes[i];
            const initialFile = initialFiles.find(f => f.file_type === type);
            const currentFile = currentFiles[i];

            if (initialFile && !currentFile) {
                // File was deleted
                await supabase.from('lecture_files').delete().eq('id', initialFile.id);
                await deleteLectureFile(initialFile.file_path);
            } else if (currentFile && currentFile instanceof File) {
                // New file was added or replaced
                if (initialFile) {
                    // Delete old file first
                    await supabase.from('lecture_files').delete().eq('id', initialFile.id);
                    await deleteLectureFile(initialFile.file_path);
                }
                // Upload new file
                const uploadedFile = await uploadLectureFile(currentFile);
                await createLectureFiles([{
                    lecture_id: params.id,
                    file_path: uploadedFile.path,
                    original_filename: uploadedFile.original_filename,
                    file_type: type,
                }]);
            }
        }

        toast({ title: 'Thành công', description: 'Đã cập nhật bài giảng' });
        router.push('/dashboard/teacher/lectures');

    } catch (error: any) {
        console.error('Lỗi khi cập nhật bài giảng:', error);
        toast({ variant: 'destructive', title: 'Lỗi', description: error.message || 'Không thể cập nhật bài giảng' });
    } finally {
        setIsUpdating(false);
    }
  }

  if (isLoading) {
    return <div className="flex justify-center items-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div></div>;
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
            <Input value={title} onChange={(e) => setTitle(e.target.value)} required />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Mô tả</label>
            <Textarea value={description} onChange={(e) => setDescription(e.target.value)} required className="min-h-[120px]" />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Link video YouTube</label>
            <Input value={videoUrl} onChange={(e) => setVideoUrl(e.target.value)} />
          </div>

          <div className="space-y-4 pt-4 border-t">
            <FileUploadSlot title="File Tiếng Việt (VIE)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={vieFile} setFile={setVieFile} disabled={isUpdating} />
            <FileUploadSlot title="File Tiếng Anh (ENG)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={engFile} setFile={setEngFile} disabled={isUpdating} />
            <FileUploadSlot title="File Mô phỏng (SIM)" accept=".html,.swf" file={simFile} setFile={setSimFile} disabled={isUpdating} />
          </div>

          <div className="flex justify-end space-x-4 pt-6">
            <Button variant="outline" type="button" onClick={() => router.back()}>Hủy</Button>
            <Button type="submit" disabled={isUpdating}>
              {isUpdating ? 'Đang cập nhật...' : 'Cập nhật bài giảng'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

// Reusable File Upload Slot Component
const FileUploadSlot = ({ title, accept, file, setFile, disabled }: { title: string, accept: string, file: FileState | null, setFile: (file: FileState | null) => void, disabled: boolean }) => {
    const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const selectedFile = event.target.files?.[0] || null;
        if (selectedFile) {
            setFile(selectedFile);
        }
    };

    const handleRemoveFile = () => {
        setFile(null);
    };

    const fileName = file ? (file instanceof File ? file.name : file.original_filename) : '';
    const fileSize = file && file instanceof File ? (file.size / (1024 * 1024)).toFixed(2) + ' MB' : '';

    return (
        <div className="space-y-1">
            <label className="text-sm font-medium">{title}</label>
            <div className="mt-1">
                {!file ? (
                    <label className="flex items-center justify-center w-full h-24 px-4 transition bg-white border-2 border-dashed rounded-lg appearance-none cursor-pointer hover:border-gray-400 focus:outline-none">
                        <div className="flex flex-col items-center space-y-1">
                            <FileUpIcon className="w-5 h-5 text-gray-500" />
                            <span className="font-medium text-xs text-gray-600">Kéo thả hoặc chọn file mới</span>
                        </div>
                        <Input type="file" className="hidden" accept={accept} onChange={handleFileChange} disabled={disabled} />
                    </label>
                ) : (
                    <div className="p-3 bg-gray-50 border border-gray-200 rounded-lg">
                        <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-3">
                                <Paperclip className="w-6 h-6 text-gray-600" />
                                <div>
                                    <p className="text-sm font-medium text-gray-700 truncate max-w-[200px]">{fileName}</p>
                                    {fileSize && <p className="text-xs text-gray-500">{fileSize}</p>}
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
