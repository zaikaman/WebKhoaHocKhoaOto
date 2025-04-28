import { NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";

/**
 * API route để thiết lập hệ thống ping
 * - Kiểm tra bảng activity_logs đã tồn tại
 * - Thêm một bản ghi ping đầu tiên
 * Chỉ chạy một lần khi bạn muốn kiểm tra hệ thống
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

    const tableExists = existingTables && existingTables.length > 0;

    if (!tableExists) {
      return NextResponse.json({ 
        success: false, 
        message: 'Bảng activity_logs không tồn tại. Bạn cần tạo bảng này trong Supabase trước khi sử dụng hệ thống ping.',
        note: 'Bạn đã tạo bảng này trong Supabase nhưng cấu trúc khác với mong đợi. Id là kiểu int8.'
      }, { status: 404 });
    }

    // Bảng đã tồn tại, thêm dữ liệu ping đầu tiên
    const { data, error: insertError } = await supabase
      .from('activity_logs')
      .insert({
        activity_type: 'ping',
        details: 'Initial ping setup',
      })
      .select();

    if (insertError) {
      console.error('Error inserting initial data:', insertError);
      return NextResponse.json(
        { success: false, message: 'Failed to insert initial data', error: insertError.message },
        { status: 500 }
      );
    }

    return NextResponse.json({ 
      success: true, 
      message: 'Ping system setup completed successfully. Initial ping data was inserted.',
      data
    });

  } catch (error) {
    console.error('Unexpected error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error', error: String(error) },
      { status: 500 }
    );
  }
} 