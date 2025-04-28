import { NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";

/**
 * API route để thiết lập hệ thống ping
 * - Tạo bảng activity_logs nếu chưa tồn tại
 * Chỉ chạy một lần khi bạn muốn thiết lập hệ thống
 */

export async function GET() {
  try {
    // 1. Kiểm tra nếu bảng activity_logs đã tồn tại
    const { data: existingTables, error: tableError } = await supabase
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public')
      .eq('table_name', 'activity_logs');

    if (tableError) {
      console.error('Error checking table existence:', tableError);
      return NextResponse.json(
        { success: false, message: 'Failed to check if table exists', error: tableError.message },
        { status: 500 }
      );
    }

    // Nếu bảng chưa tồn tại, tạo nó
    if (!existingTables || existingTables.length === 0) {
      // Sử dụng SQL trực tiếp để tạo bảng
      const { error: createError } = await supabase.rpc('create_activity_logs_table', {});

      if (createError) {
        // Thử cách khác nếu RPC không hoạt động
        // Chú ý: Sử dụng SQL raw phải được bật trong cài đặt Supabase
        const { error: sqlError } = await supabase.rpc('exec_sql', {
          sql_string: `
            CREATE TABLE IF NOT EXISTS activity_logs (
              id TEXT PRIMARY KEY,
              activity_type TEXT NOT NULL,
              details TEXT,
              created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
              updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
            );
          `
        });

        if (sqlError) {
          console.error('Failed to create table:', sqlError);
          return NextResponse.json(
            { 
              success: false, 
              message: 'Failed to create activity_logs table.', 
              note: 'Bạn cần tạo bảng này thủ công trong Supabase.',
              tableSchema: `
CREATE TABLE IF NOT EXISTS activity_logs (
  id TEXT PRIMARY KEY,
  activity_type TEXT NOT NULL,
  details TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);`
            },
            { status: 500 }
          );
        }
      }
    }

    // Kiểm tra bảng đã được tạo chưa
    const { data: tables, error: checkError } = await supabase
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public')
      .eq('table_name', 'activity_logs');

    if (checkError) {
      console.error('Error checking table after creation:', checkError);
      return NextResponse.json(
        { success: false, message: 'Error checking table after creation', error: checkError.message },
        { status: 500 }
      );
    }

    const tableExists = tables && tables.length > 0;

    if (tableExists) {
      // Thêm dữ liệu ping đầu tiên
      const timestamp = new Date().toISOString();
      
      const { error: insertError } = await supabase
        .from('activity_logs')
        .upsert({
          id: 'ping-record',
          activity_type: 'ping',
          details: 'Initial ping setup',
          created_at: timestamp,
          updated_at: timestamp,
        }, {
          onConflict: 'id',
        });

      if (insertError) {
        console.error('Error inserting initial data:', insertError);
        return NextResponse.json(
          { success: false, message: 'Failed to insert initial data', error: insertError.message },
          { status: 500 }
        );
      }

      return NextResponse.json({ 
        success: true, 
        message: 'Ping system setup completed successfully. Table exists or was created, and initial data was inserted.' 
      });
    } else {
      return NextResponse.json({ 
        success: false, 
        message: 'Failed to create activity_logs table. Please create it manually in Supabase.' 
      }, { status: 500 });
    }

  } catch (error) {
    console.error('Unexpected error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error', error: String(error) },
      { status: 500 }
    );
  }
} 