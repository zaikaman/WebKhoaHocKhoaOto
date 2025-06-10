-- Tạo bảng lecture_files
CREATE TABLE IF NOT EXISTS lecture_files (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    lecture_id UUID REFERENCES lectures(id) ON DELETE CASCADE,
    file_url TEXT NOT NULL,
    file_type TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Thêm RLS policies
ALTER TABLE lecture_files ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON lecture_files
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON lecture_files
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users only" ON lecture_files
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users only" ON lecture_files
    FOR DELETE USING (auth.role() = 'authenticated'); 