"use client"

import { useState, useEffect } from "react"
import { UploadLecture } from "@/components/upload-lecture"
import { getClassLectures } from "@/lib/supabase"
import { LectureDetail } from "./lecture-details"
import { Button } from "@/components/ui/button"
import { useRouter } from "next/navigation"
interface LectureListProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

export function LectureList({ classId, onUploadSuccess }: LectureListProps) {
  const [lectures, setLectures] = useState<any[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [selectedLecture, setSelectedLecture] = useState<any | null>(null)
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const router = useRouter()

  useEffect(() => {
    loadLectures()
  }, [classId])

  async function loadLectures() {
    try {
      setIsLoading(true)
      const data = await getClassLectures(classId)
      setLectures(data)
    } catch (error) {
      console.error('Lỗi khi tải danh sách bài giảng:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleLectureDelete = async () => {
    await loadLectures()
    await onUploadSuccess()
  }

  const handleLectureUpdate = async () => {
    await loadLectures()
    await onUploadSuccess()
  }

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-sm md:text-base lg:text-lg font-medium">Danh sách bài giảng</h3>
        <UploadLecture 
          classId={classId}
          onUploadSuccess={onUploadSuccess}
        />
      </div>

      {isLoading ? (
        <div className="text-center py-8">Đang tải...</div>
      ) : lectures.length === 0 ? (
        <div className="text-center py-8 text-muted-foreground">
          Chưa có bài giảng nào
        </div>
      ) : (
        <div className="rounded-md border overflow-x-auto">
          <table className="w-full min-w-[600px] text-xs md:text-sm">
            <thead className="bg-muted">
              <tr>
                <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Tiêu đề</th>
                <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Loại</th>
                <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Mô tả</th>
                <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Ngày tạo</th>
                <th className="py-2 px-2 md:py-3 md:px-4 text-left font-medium">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {lectures.map((lecture) => (
                <tr key={lecture.id} className="border-t">
                  <td className="py-2 px-2 md:py-4 md:px-4">
                    <div className="font-medium">{lecture.title}</div>
                    {lecture.file_type === 'video' && lecture.fileUrl && (
                      <a 
                        href={lecture.fileUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-xs md:text-sm text-blue-500 hover:underline block truncate max-w-[180px] md:max-w-[250px]"
                      >
                        {lecture.fileUrl}
                      </a>
                    )}
                  </td>
                  <td className="py-2 px-2 md:py-4 md:px-4">
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      lecture.file_type === 'video' 
                        ? 'bg-blue-100 text-blue-800'
                        : 'bg-green-100 text-green-800'
                    }`}>
                      {lecture.file_type === 'video' ? 'Link' : 'File'}
                    </span>
                  </td>
                  <td className="py-2 px-2 md:py-4 md:px-4">
                    <p className="text-xs md:text-sm text-muted-foreground truncate max-w-[180px] md:max-w-[300px]">
                      {lecture.description}
                    </p>
                  </td>
                  <td className="py-2 px-2 md:py-4 md:px-4">
                    <span className="text-xs md:text-sm text-muted-foreground">
                      {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                    </span>
                  </td>
                  <td className="py-2 px-2 md:py-4 md:px-4">
                  <div className="flex flex-wrap justify-center items-center gap-2">
                    <LectureDetail 
                      lecture={lecture}
                      onDelete={handleLectureDelete}
                    />
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => router.push(`/dashboard/teacher/lectures/${lecture.id}/edit`)}
                    >
                      Chỉnh sửa
                    </Button>
                  </div>
                </td>


                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}