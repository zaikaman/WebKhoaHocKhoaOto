import { NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";

/**
 * API route để giữ cho Supabase luôn hoạt động
 * Route này sẽ thực hiện một thao tác đơn giản để cập nhật bảng activity_logs
 * Sử dụng Uptime Robot hoặc công cụ tương tự để gọi endpoint này định kỳ (ví dụ: mỗi ngày)
 */

// Disable caching for this route
export const dynamic = 'force-dynamic'
export const revalidate = 0

export async function GET() {
  try {
    const timestamp = new Date().toISOString();
    
    // Tạo bản ghi ping mới trong bảng activity_logs
    // Không cung cấp id vì đó là số tự động tăng
    const { data, error } = await supabase
      .from('activity_logs')
      .insert({
        activity_type: 'ping',
        details: 'Automatic ping to keep database active',
      })
      .select();

    if (error) {
      console.error('Ping error:', error);
      return NextResponse.json(
        { success: false, message: 'Failed to ping database', error: error.message },
        { 
          status: 500,
          headers: {
            'Cache-Control': 'no-store, max-age=0',
          }
        }
      );
    }

    return NextResponse.json({ 
      success: true, 
      message: 'Database pinged successfully', 
      timestamp,
      data
    }, {
      headers: {
        'Cache-Control': 'no-store, max-age=0',
      }
    });
  } catch (error) {
    console.error('Unexpected error:', error);
    return NextResponse.json(
      { success: false, message: 'Internal server error', error: String(error) },
      { 
        status: 500,
        headers: {
          'Cache-Control': 'no-store, max-age=0',
        }
      }
    );
  }
} 