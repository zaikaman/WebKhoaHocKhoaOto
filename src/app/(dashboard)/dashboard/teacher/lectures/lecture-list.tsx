"use client"

import { useState, useEffect } from "react"
import { UploadLecture } from "@/components/upload-lecture"
import { getClassLectures } from "@/lib/supabase"
import { LectureDetail } from "./lecture-details"

interface LectureListProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

export function LectureList({ classId, onUploadSuccess }: LectureListProps) {
  const [lectures, setLectures] = useState<any[]>([])
  const [isLoading, setIsLoading] = useState(true)

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

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h3 className="text-lg font-medium">Danh sách bài giảng</h3>
        <UploadLecture 
          classId={classId}
          onUploadSuccess={onUploadSuccess}
        />
      </div>

      {isLoading ? (
        <div className="text-center py-4">Đang tải...</div>
      ) : lectures.length === 0 ? (
        <div className="text-center py-4 text-muted-foreground">
          Chưa có bài giảng nào
        </div>
      ) : (
        <div className="grid gap-4">
          {lectures.map((lecture) => (
            <div key={lecture.id} className="flex items-center justify-between p-4 border rounded-lg">
              <div>
                <h4 className="font-semibold">{lecture.title}</h4>
                <p className="text-sm text-muted-foreground">{lecture.description}</p>
                <p className="text-sm text-muted-foreground">
                  Ngày tạo: {new Date(lecture.created_at).toLocaleDateString('vi-VN')}
                </p>
              </div>
              <LectureDetail 
                lecture={lecture}
                onDelete={handleLectureDelete}
              />
            </div>
          ))}
        </div>
      )}
    </div>
  )
}