import { NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";

/**
 * API route để giữ cho Supabase luôn hoạt động
 * Route này sẽ thực hiện một thao tác đơn giản để cập nhật bảng activity_logs
 * Sử dụng Uptime Robot hoặc công cụ tương tự để gọi endpoint này định kỳ (ví dụ: mỗi ngày)
 */

export async function GET() {
  try {
    const timestamp = new Date().toISOString();
    
    // Tạo hoặc cập nhật bản ghi ping trong bảng activity_logs
    const { error } = await supabase
      .from('activity_logs')
      .upsert({
        id: 'ping-record', // Sử dụng ID cố định để upsert
        activity_type: 'ping',
        details: 'Automatic ping to keep database active',
        created_at: timestamp,
        updated_at: timestamp,
      }, {
        onConflict: 'id',
      });

    if (error) {
      console.error('Ping error:', error);
      return NextResponse.json(
        { success: false, message: 'Failed to ping database', error: error.message },
        { status: 500 }
      );
    }

    return NextResponse.json({ 
      success: true, 
      message: 'Database pinged successfully', 
      timestamp
    });
  } catch (error) {
    console.error('Unexpected error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error', error: String(error) },
      { status: 500 }
    );
  }
} 