-- SQL để tạo bảng activity_logs trong Supabase
-- Sử dụng SQL này trong SQL Editor của Supabase nếu bạn cần tạo bảng thủ công

CREATE TABLE IF NOT EXISTS activity_logs (
  id TEXT PRIMARY KEY,
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
INSERT INTO activity_logs (id, activity_type, details)
VALUES ('ping-record', 'ping', 'Initial setup ping')
ON CONFLICT (id) DO UPDATE
SET updated_at = NOW(), details = 'Ping record updated';

-- Thông báo hoàn tất
SELECT 'Activity logs table created successfully' as message; 