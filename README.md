# Web Khóa Học Khóa Ô Tô

## 1. Tổng quan dự án

Dự án "Web Khóa Học Khóa Ô Tô" là một nền tảng học trực tuyến hiện đại được phát triển nhằm cung cấp các khóa học chất lượng cao trong lĩnh vực ô tô. Hệ thống được xây dựng trên nền tảng công nghệ tiên tiến Next.js, tích hợp đầy đủ các tính năng thiết yếu cho việc học trực tuyến như:

- Quản lý khóa học và nội dung học tập
- Hệ thống xác thực và phân quyền người dùng
- Công cụ soạn thảo nội dung đa dạng
- Quản lý tài liệu và tài nguyên học tập
- Hệ thống đánh giá và phản hồi
- Báo cáo và thống kê chi tiết

Dự án hướng đến mục tiêu tạo ra một môi trường học tập trực tuyến chuyên nghiệp, dễ tiếp cận và hiệu quả cho người học, đồng thời xây dựng một mô hình kinh doanh bền vững trong lĩnh vực đào tạo trực tuyến. Với giao diện thân thiện và trải nghiệm người dùng được tối ưu hóa, hệ thống hứa hẹn mang lại giá trị thiết thực cho cả người học và đơn vị đào tạo.

## 2. Tính năng
## Dành cho **Sinh viên**

### Đăng nhập
- Sử dụng **mã số sinh viên** làm tên đăng nhập.
- Mật khẩu được cấp ban đầu là password123, có thể thay đổi sau khi đăng nhập.

### Trang Dashboard
- Xem tổng quan về:
  - Các lớp học đã đăng ký
  - Bài tập sắp đến hạn
  - Bài kiểm tra sắp diễn ra
  - Thống kê học tập

### Quản lý **Lớp học**
- Truy cập menu **"Lớp học"** để:
  - Xem danh sách các lớp đã đăng ký
  - Xem thông tin chi tiết từng lớp
  - Truy cập tài liệu học tập
  - Xem thông báo từ giảng viên

### Quản lý **Bài tập**
- Vào mục **"Bài tập"** để:
  - Xem danh sách bài tập được giao
  - Nộp bài tập trực tuyến
  - Theo dõi điểm và nhận xét từ giảng viên
  - Kiểm tra thời hạn nộp bài

### Quản lý **Bài kiểm tra**
- Sử dụng menu **"Bài kiểm tra"** để:
  - Xem lịch kiểm tra
  - Làm bài kiểm tra trực tuyến
  - Xem kết quả sau khi hoàn thành
  - Xem lại bài làm và đáp án

---

## Dành cho **Giảng viên**

### Đăng nhập
- Sử dụng tài khoản có định dạng **gvXXX** (ví dụ: gv001).
- Có quyền truy cập vào trang quản lý dành cho giảng viên.
- Mật khẩu được cấp ban đầu là password123, có thể thay đổi sau khi đăng nhập.

### Quản lý **Lớp học**
- Tạo và quản lý các lớp học
- Thêm/xóa sinh viên khỏi lớp
- Đăng tải tài liệu giảng dạy
- Gửi thông báo cho lớp

### Quản lý **Bài giảng**
- Tạo và quản lý nội dung bài giảng
- Tải lên tài liệu đính kèm
- Theo dõi tiến độ học tập của sinh viên

### Quản lý **Bài tập**
- Tạo bài tập mới
- Thiết lập thời hạn nộp bài
- Chấm điểm và nhận xét bài làm
- Xuất báo cáo điểm

### Quản lý **Kiểm tra**
- Tạo đề kiểm tra
- Thiết lập thời gian làm bài
- Chấm điểm tự động/thủ công
- Phân tích kết quả kiểm tra

---

## Dành cho **Admin**

### Đăng nhập Admin
- Truy cập trang `/admin/login`
- Sử dụng tài khoản admin được cấp (tài khoản: admin, mật khẩu: password)

### Quản lý **Tài khoản**
- Tạo mới tài khoản cho:
  - Sinh viên
  - Giảng viên
  - Admin khác
- Phân quyền người dùng
- Kích hoạt/vô hiệu hóa tài khoản
- Đặt lại mật khẩu

### Quản lý **Hệ thống**
- Theo dõi hoạt động hệ thống
- Quản lý cơ sở dữ liệu
- Sao lưu và phục hồi dữ liệu
- Cấu hình hệ thống

### **Báo cáo và Thống kê**
- Xem báo cáo tổng quan
- Thống kê người dùng
- Theo dõi hiệu suất hệ thống
- Xuất báo cáo định kỳ

----

## Công nghệ sử dụng

### Frontend (Giao diện người dùng)
- Next.js 14.1.0: Framework giúp xây dựng giao diện website hiện đại, nhanh và mượt mà
- TypeScript: Ngôn ngữ lập trình giúp code ổn định và ít lỗi hơn
- Tailwind CSS: Công cụ tạo giao diện đẹp một cách nhanh chóng
- Radix UI Components: Bộ công cụ tạo các nút bấm, menu, form đẹp và dễ sử dụng
- React Hook Form: Thư viện giúp xử lý form đăng nhập, đăng ký dễ dàng
- Zod: Công cụ kiểm tra dữ liệu người dùng nhập vào có hợp lệ không
- TipTap: Công cụ soạn thảo văn bản có định dạng (như Word)
- Monaco Editor: Công cụ soạn thảo code trực tuyến
- TinyMCE: Một công cụ soạn thảo văn bản khác có nhiều tính năng

### Backend (Hệ thống máy chủ)
- Next.js API Routes: Công nghệ xử lý yêu cầu từ người dùng
- Prisma: Công cụ giúp tương tác với cơ sở dữ liệu dễ dàng hơn
- Supabase: Hệ thống quản lý đăng nhập và lưu trữ dữ liệu
- NextAuth.js: Thư viện hỗ trợ đăng nhập, xác thực người dùng

### Công cụ phát triển
- ESLint: Công cụ giúp phát hiện và sửa lỗi code
- TypeScript: (Đã giới thiệu ở trên)
- Tailwind CSS: (Đã giới thiệu ở trên)
- PostCSS: Công cụ xử lý và tối ưu CSS
- Vercel: Nền tảng đưa website lên internet cho mọi người sử dụng

### Các thư viện hỗ trợ
- XLSX: Thư viện giúp đọc và tạo file Excel
- DOCX: Thư viện giúp đọc và tạo file Word
- File Saver: Công cụ hỗ trợ tải file về máy
- React Table: Thư viện tạo bảng dữ liệu đẹp và dễ sử dụng
- Hero Icons: Bộ icon đẹp và chuyên nghiệp
- Lucide React: Một bộ icon khác đẹp và dễ sử dụng

## Cài đặt và chạy dự án

1. Clone repository
```bash
git clone [repository-url]
```

2. Cài đặt dependencies
```bash
npm install
```

3. Chạy môi trường development
```bash
npm run dev
```

4. Build cho production
```bash
npm run build
```

5. Chạy production
```bash
npm start
```
