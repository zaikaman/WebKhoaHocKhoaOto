"use client"

import { useRouter } from "next/navigation"
import { UploadLecture } from "@/components/upload-lecture"

interface LecturesPageProps {
  classId: string;
  onUploadSuccess: () => Promise<void>;
}

export default function LecturesPage({ classId, onUploadSuccess }: LecturesPageProps) {
  return (
    <div>
      <UploadLecture 
        classId={classId}
        onUploadSuccess={onUploadSuccess}
      />
    </div>
  )
}