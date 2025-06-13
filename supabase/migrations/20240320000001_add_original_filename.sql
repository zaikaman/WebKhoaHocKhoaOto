-- Thêm trường original_filename vào bảng lectures
ALTER TABLE lectures ADD COLUMN original_filename TEXT;

-- Cập nhật các bản ghi hiện tại (nếu cần)
COMMENT ON COLUMN lectures.original_filename IS 'Tên file gốc khi upload'; 