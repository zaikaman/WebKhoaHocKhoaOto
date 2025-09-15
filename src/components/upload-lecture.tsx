"use client"

import { useState, useRef, useCallback } from 'react'
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { createLecture, uploadLectureFile, createLectureFiles } from '@/lib/supabase'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog"
import { FileUpIcon, XIcon, Paperclip } from "lucide-react"
import { sanitizeDescription } from '@/lib/utils'

interface UploadLectureProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

interface FileState {
  file: File | null;
  type: 'VIE' | 'ENG' | 'SIM';
}

// Reusable component for a single file upload slot
const FileUploadSlot = ({ title, accept, file, setFile, disabled }: { title: string, accept: string, file: File | null, setFile: (file: File | null) => void, disabled: boolean }) => {
  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = event.target.files?.[0] || null;
    if (selectedFile) {
      if (selectedFile.size > 100 * 1024 * 1024) { // 100MB limit
        alert("File không được vượt quá 100MB");
        return;
      }
      setFile(selectedFile);
    }
  };

  const handleRemoveFile = () => {
    setFile(null);
  };

  const onDrop = useCallback((event: React.DragEvent<HTMLLabelElement>) => {
    event.preventDefault();
    const droppedFile = event.dataTransfer.files?.[0] || null;
    if (droppedFile) {
        if (droppedFile.size > 100 * 1024 * 1024) {
            alert("File không được vượt quá 100MB");
            return;
        }
        setFile(droppedFile);
    }
  }, [setFile]);

  const onDragOver = (event: React.DragEvent<HTMLLabelElement>) => {
    event.preventDefault();
  };

  return (
    <div className="space-y-1">
      <p className="text-sm font-medium text-gray-800">{title}</p>
      <div className="mt-1">
        {!file ? (
          <label
            onDrop={onDrop}
            onDragOver={onDragOver}
            className="flex items-center justify-center w-full h-24 px-4 transition bg-white border-2 border-dashed border-gray-300 rounded-lg appearance-none cursor-pointer hover:border-gray-400 focus:outline-none">
            <div className="flex flex-col items-center space-y-1">
              <Paperclip className="w-5 h-5 text-gray-500"/>
              <span className="font-medium text-xs text-gray-600">
                Kéo thả hoặc chọn file
              </span>
            </div>
            <Input
              type="file"
              className="hidden"
              accept={accept}
              onChange={handleFileChange}
              disabled={disabled}
            />
          </label>
        ) : (
          <div className="p-3 bg-gray-50 border border-gray-200 rounded-lg">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <FileUpIcon className="w-6 h-6 text-gray-600"/>
                <div>
                  <p className="text-sm font-medium text-gray-700 truncate max-w-[200px]">{file.name}</p>
                  <p className="text-xs text-gray-500">
                    {(file.size / (1024 * 1024)).toFixed(2)} MB
                  </p>
                </div>
              </div>
              <Button
                type="button"
                variant="ghost"
                size="icon"
                onClick={handleRemoveFile}
                disabled={disabled}
                className="text-red-500 hover:text-red-700"
              >
                <XIcon size={16} />
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};


export function UploadLecture({ classId, onUploadSuccess }: UploadLectureProps) {
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(false)
  const [isOpen, setIsOpen] = useState(false)
  
  const [vieFile, setVieFile] = useState<File | null>(null);
  const [engFile, setEngFile] = useState<File | null>(null);
  const [simFile, setSimFile] = useState<File | null>(null);

  const formRef = useRef<HTMLFormElement>(null)

  const resetForm = () => {
    setVieFile(null);
    setEngFile(null);
    setSimFile(null);
    formRef.current?.reset();
  }

  async function handleFileUpload(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    
    const formData = new FormData(event.currentTarget)
    const title = formData.get('title') as string
    const description = formData.get('description') as string
    const video_url = formData.get('video_url') as string
    
    const filesToUpload: FileState[] = [];
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
      // Step 1: Create the lecture entry to get an ID
      const newLecture = await createLecture({
        class_id: classId,
        title,
        description: sanitizeDescription(description),
        video_url,
      });

      if (!newLecture || !newLecture.id) {
        throw new Error("Không thể tạo bài giảng mới.");
      }
      
      const lectureId = newLecture.id;

      if (filesToUpload.length > 0) {
        // Step 2: Upload files in parallel
        const uploadPromises = filesToUpload.map(fileState => 
          uploadLectureFile(fileState.file!)
        );
        
        const uploadedFiles = await Promise.all(uploadPromises);

        // Step 3: Create lecture_files records
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
        description: "Đã tải lên bài giảng và các file đính kèm."
      })

      resetForm();
      setIsOpen(false)
      await onUploadSuccess()

    } catch (error: any) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể tải lên bài giảng."
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
      
      <Dialog open={isOpen} onOpenChange={(open) => {
          if (!open) resetForm();
          setIsOpen(open);
      }}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle className="text-xl font-semibold">Thêm bài giảng mới</DialogTitle>
            <DialogDescription>
              Tải lên tài liệu cho bài giảng của bạn.
            </DialogDescription>
          </DialogHeader>

          <form ref={formRef} onSubmit={handleFileUpload} className="space-y-6 mt-4">
            <div className="space-y-2">
              <Label htmlFor="title">Tiêu đề</Label>
              <Input
                id="title"
                name="title"
                placeholder="Ví dụ: Bài 1 - Giới thiệu về động cơ đốt trong"
                required
                disabled={isLoading}
                className="mt-1"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="description">Mô tả</Label>
              <Textarea
                id="description"
                name="description"
                placeholder="Nhập mô tả ngắn gọn về nội dung bài giảng"
                rows={3}
                disabled={isLoading}
                className="mt-1"
              />
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="video_url">Link video YouTube</Label>
              <Input
                id="video_url"
                name="video_url"
                placeholder="Dán link video YouTube vào đây"
                disabled={isLoading}
                className="mt-1"
              />
            </div>

            <div className="space-y-4">
                <FileUploadSlot title="File Tiếng Việt (VIE)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={vieFile} setFile={setVieFile} disabled={isLoading} />
                <FileUploadSlot title="File Tiếng Anh (ENG)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={engFile} setFile={setEngFile} disabled={isLoading} />
                <FileUploadSlot title="File Mô phỏng (SIM)" accept=".html,.swf" file={simFile} setFile={setSimFile} disabled={isLoading} />
            </div>
            
            <Button type="submit" disabled={isLoading} className="w-full">
              {isLoading ? "Đang xử lý..." : "Tạo và Tải lên"}
            </Button>
          </form>
        </DialogContent>
      </Dialog>
    </>
  )
}
