"use client"

import { UploadLecture } from "@/components/upload-lecture"

interface LectureListProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

export function LectureList({ classId, onUploadSuccess }: LectureListProps) {
  return (
    <div>
      <UploadLecture 
        classId={classId}
        onUploadSuccess={onUploadSuccess}
      />
    </div>
  )
}