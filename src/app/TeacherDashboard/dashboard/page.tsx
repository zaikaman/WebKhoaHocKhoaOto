"use client"

import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { supabase } from "@/lib/supabase"

export default function TeacherDashboardPage() {
  const [teacherInfo, setTeacherInfo] = useState({
    name: '',
    courses: 0,
    students: 0,
    assignments: 0
  })

  useEffect(() => {
    // TODO: Lấy thông tin giáo viên từ Supabase
  }, [])

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">
          Xin chào, {teacherInfo.name || 'Giảng viên'}
        </h2>
      </div>

      {/* Thống kê */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Lớp đang dạy</h3>
          </div>
          <div className="text-2xl font-bold">{teacherInfo.courses}</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Sinh viên</h3>
          </div>
          <div className="text-2xl font-bold">{teacherInfo.students}</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Bài tập đã giao</h3>
          </div>
          <div className="text-2xl font-bold">{teacherInfo.assignments}</div>
        </div>
        <div className="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
          <div className="flex flex-row items-center justify-between pb-2 space-y-0">
            <h3 className="tracking-tight text-sm font-medium">Bài cần chấm</h3>
          </div>
          <div className="text-2xl font-bold">15</div>
        </div>
      </div>

      {/* Danh sách lớp học */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-medium">Lớp học của tôi</h3>
          <Button variant="outline">Xem tất cả</Button>
        </div>
        {/* Thêm danh sách lớp học ở đây */}
      </div>
    </div>
  )
}