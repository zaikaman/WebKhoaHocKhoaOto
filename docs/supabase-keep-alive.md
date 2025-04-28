# Hướng dẫn giữ cho Supabase luôn hoạt động

## Vấn đề

Supabase free tier sẽ tự động chuyển sang trạng thái không hoạt động (inactive) sau khoảng 1 tháng nếu không có hoạt động nào (như insert, update, delete). Điều này có thể gây gián đoạn hoạt động của ứng dụng.

## Giải pháp

Chúng tôi đã tạo một hệ thống tự động ping để giữ cho Supabase luôn hoạt động bằng cách thực hiện các hoạt động cơ sở dữ liệu định kỳ. Hệ thống bao gồm:

1. API endpoint để thực hiện ping
2. Bảng `activity_logs` để lưu thông tin ping
3. Cron job để tự động gọi API ping mỗi 7 ngày

## Cách thiết lập

### 1. Tạo bảng `activity_logs` trong Supabase

Bạn có hai cách để tạo bảng này:

#### Cách 1: Sử dụng API tự động

Truy cập URL sau để thiết lập tự động:
```
https://your-website.com/api/setup-ping
```

#### Cách 2: Tạo thủ công trong Supabase

1. Đăng nhập vào Supabase Dashboard
2. Chọn SQL Editor
3. Dán nội dung từ file `src/sql/create_activity_logs.sql` và chạy

### 2. Thiết lập Vercel Cron Job

Vercel Hobby (free tier) hỗ trợ Cron Jobs. Chúng tôi đã tự động thiết lập cron job trong file `vercel.json` để gọi API ping mỗi 7 ngày.

Để kiểm tra cron job đã được cài đặt:
1. Đăng nhập vào Vercel Dashboard
2. Chọn dự án của bạn
3. Vào mục "Settings" > "Cron Jobs"
4. Xác nhận cron job `/api/ping` đã được thiết lập

### 3. Kiểm tra thủ công

Truy cập URL sau để kiểm tra hệ thống ping hoạt động đúng:
```
https://your-website.com/api/ping
```

Nếu mọi thứ hoạt động đúng, bạn sẽ nhận được phản hồi JSON thành công.

## Cách hoạt động

Mỗi khi cron job kích hoạt (7 ngày một lần), hệ thống sẽ:
1. Gọi API `/api/ping`
2. API này cập nhật bản ghi trong bảng `activity_logs`
3. Hoạt động cập nhật này giữ cho Supabase tiếp tục hoạt động

## Giải pháp thay thế

Nếu bạn không muốn sử dụng Vercel Cron Jobs, bạn có thể sử dụng các dịch vụ miễn phí khác:

1. **Uptime Robot**: Thiết lập để ping URL `/api/ping` mỗi ngày
2. **GitHub Actions**: Tạo workflow để gọi API định kỳ
3. **Cron-job.org**: Dịch vụ miễn phí để lên lịch HTTP requests

## Lưu ý

- Hệ thống này sử dụng bảng `activity_logs` chuyên dụng, không ảnh hưởng đến dữ liệu ứng dụng chính
- Mỗi lần ping chỉ cập nhật một bản ghi duy nhất, không gây tăng dữ liệu đáng kể
- Cron job được cài đặt mỗi 7 ngày, nhưng bạn có thể điều chỉnh tần suất trong `vercel.json` 