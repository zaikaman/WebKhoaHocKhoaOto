"use client"

import { useRouter, useParams } from "next/navigation"
import { UploadLecture } from "@/components/upload-lecture"

export default function LecturesPage() {
  const router = useRouter()
  const params = useParams()
  const classId = params.id as string

  const handleUploadSuccess = async () => {
    // Refresh the page data
    router.refresh()
  }

  return (
    <div>
      <UploadLecture 
        classId={classId}
        onUploadSuccess={handleUploadSuccess}
      />
    </div>
  )
}