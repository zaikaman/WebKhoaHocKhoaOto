import { Metadata } from "next"

export const metadata: Metadata = {
  title: "Khóa học - Khoa Công nghệ Ô tô",
  description: "Danh sách các khóa học chuyên ngành Công nghệ Ô tô",
}

export default function CoursesLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return <>{children}</>
} 