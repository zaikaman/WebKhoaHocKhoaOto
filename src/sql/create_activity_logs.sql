-- SQL để tạo bảng activity_logs trong Supabase với id tự động tăng
-- Sử dụng SQL này trong SQL Editor của Supabase

-- Tạo sequence cho id tự động tăng (nếu chưa có)
CREATE SEQUENCE IF NOT EXISTS activity_logs_id_seq;

-- Tạo bảng với id tự động tăng
CREATE TABLE IF NOT EXISTS activity_logs (
  id INT8 PRIMARY KEY DEFAULT nextval('activity_logs_id_seq'),
  activity_type TEXT NOT NULL,
  details TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Thêm chính sách bảo mật để chỉ admin và các bảng hệ thống có thể truy cập
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;

-- Tạo chính sách cho admin
CREATE POLICY "Admin can do all" ON activity_logs 
FOR ALL USING (auth.role() = 'authenticated' AND auth.jwt() ->> 'role' = 'admin');

-- Tạo chính sách cho hệ thống
CREATE POLICY "System services can do all" ON activity_logs 
FOR ALL USING (auth.role() = 'service_role');

-- Thêm chỉ mục để tối ưu truy vấn
CREATE INDEX activity_logs_type_idx ON activity_logs(activity_type);
CREATE INDEX activity_logs_updated_at_idx ON activity_logs(updated_at);

-- Chèn bản ghi đầu tiên
INSERT INTO activity_logs (activity_type, details)
VALUES ('ping', 'Initial setup ping');

-- Thông báo hoàn tất
SELECT 'Activity logs table created successfully' as message; 