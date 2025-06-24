import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/toaster";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "AutoEdu - Hệ thống quản lý học tập trực tuyến",
  description: "AutoEdu - Hệ thống quản lý học tập trực tuyến cho sinh viên và giảng viên",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi">
      <body className={inter.className}>
        {children}
        <Toaster />
      </body>
    </html>
  );
}
