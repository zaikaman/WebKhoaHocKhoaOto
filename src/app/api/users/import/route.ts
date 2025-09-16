import { NextResponse } from 'next/server'
import { adminSupabase } from '@/lib/supabase';

// Function to generate a random password if not provided
const generateRandomPassword = () => {
  return Math.random().toString(36).slice(-8);
};

export async function POST(req: Request) {
  const { users } = await req.json()

  if (!users || !Array.isArray(users) || users.length === 0) {
    return NextResponse.json({ message: 'Dữ liệu không hợp lệ' }, { status: 400 })
  }

  const processedUsers = [];
  const errors: { user: string, error: string }[] = [];

  for (const user of users) {
    if (!user.student_id || !user.last_name || !user.first_name || !user.role) {
        errors.push({ user: user.student_id || 'N/A', error: 'Thiếu thông tin (mã số, họ và tên đệm, tên, vai trò).' });
        continue;
    }

    const email = `${user.student_id}@aptech.edu.vn`;
    const full_name = `${user.last_name} ${user.first_name}`;

    try {
      // 1. Check if profile with student_id already exists
      const { data: existingProfile, error: profileCheckError } = await adminSupabase
        .from('profiles')
        .select('id')
        .eq('student_id', user.student_id)
        .maybeSingle();

      if (profileCheckError) {
          throw new Error(`Lỗi kiểm tra hồ sơ: ${profileCheckError.message}`);
      }

      if (existingProfile) {
        // User with this student_id exists. We can consider it "processed"
        errors.push({ user: user.student_id, error: 'Tài khoản đã tồn tại.' });

      } else {
        // New user based on student_id. Create them.
        const password = user.password || generateRandomPassword();
        const { data: authData, error: authError } = await adminSupabase.auth.admin.createUser({
          email: email.trim(),
          password: password,
          email_confirm: true,
          user_metadata: {
            full_name: full_name,
            role: user.role,
          }
        });

        if (authError) {
          if (authError.message.toLowerCase().includes('email address already exists')) {
              errors.push({ user: user.student_id, error: `Email ${email} đã được sử dụng.` });
              continue;
          }
          throw new Error(`Lỗi tạo tài khoản: ${authError.message}`);
        }

        if (!authData.user) {
          throw new Error('Không thể tạo người dùng.');
        }

        // Update profiles table with the rest of the info
        const { error: profileError } = await adminSupabase
          .from('profiles')
          .update({
            student_id: user.student_id,
            full_name: full_name,
            role: user.role,
            class_code: user.class_code,
            status: 'active',
            updated_at: new Date().toISOString()
          })
          .eq('id', authData.user.id);

        if (profileError) {
            // If profile update fails, we should probably delete the created auth user to avoid orphans
            await adminSupabase.auth.admin.deleteUser(authData.user.id);
            throw new Error(`Lỗi cập nhật hồ sơ: ${profileError.message}`);
        }
        
        processedUsers.push(user);
      }

    } catch (error: any) {
      errors.push({ user: user.student_id, error: error.message });
    }
  }

  if (errors.length > 0 && processedUsers.length === 0) {
      return NextResponse.json({ 
          message: "Thêm tài khoản thất bại. Vui lòng kiểm tra lại file.",
          errors: errors 
      }, { status: 400 });
  }

  if (errors.length > 0) {
    return NextResponse.json({
      message: `Hoàn thành với ${processedUsers.length} thành công và ${errors.length} lỗi.`,
      processedCount: processedUsers.length,
      errorCount: errors.length,
      errors: errors,
    }, { status: 207 }); // Multi-Status
  }

  return NextResponse.json({ message: `Đã thêm thành công ${processedUsers.length} tài khoản.` }, { status: 201 });
}
