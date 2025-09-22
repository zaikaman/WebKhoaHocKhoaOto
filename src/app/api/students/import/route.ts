import { NextResponse } from 'next/server'
import { adminSupabase } from '@/lib/supabase';

// Function to generate a random password
const generateRandomPassword = () => {
  return Math.random().toString(36).slice(-8);
};

export async function POST(req: Request) {
  const { students, classIds } = await req.json()

  if (!students || !classIds || !Array.isArray(students) || !Array.isArray(classIds) || students.length === 0 || classIds.length === 0) {
    return NextResponse.json({ message: 'Dữ liệu không hợp lệ' }, { status: 400 })
  }

  const processedStudents = [];
  const errors: { student: string, error: string }[] = [];

  for (const student of students) {
    if (!student.student_code || !student.full_name) {
        errors.push({ student: student.student_code || 'N/A', error: 'Thiếu thông tin (mã số sinh viên, họ tên).' });
        continue;
    }

    try {
      let profileId: string | null = null;

      // 1. Check if profile with student_id already exists
      const { data: existingProfile, error: profileCheckError } = await adminSupabase
        .from('profiles')
        .select('id')
        .eq('student_id', student.student_code)
        .maybeSingle();

      if (profileCheckError) {
          throw new Error(`Lỗi kiểm tra hồ sơ: ${profileCheckError.message}`);
      }

      if (existingProfile) {
        profileId = existingProfile.id;
      } else {
        // This is a new student. Generate a fake email and create the user.
        const password = generateRandomPassword();
        const syntheticEmail = `${student.student_code}@gmail.com`;

        const { data: authData, error: authError } = await adminSupabase.auth.admin.createUser({
          email: syntheticEmail,
          password: password,
          email_confirm: true, // Auto-confirm the fake email
          user_metadata: {
            full_name: student.full_name,
            student_id: student.student_code,
            role: 'student',
          }
        });

        if (authError) {
          // The synthetic email should be unique, but handle collision just in case.
          if (authError.message.toLowerCase().includes('email address already exists')) {
              errors.push({ student: student.student_code, error: `Tài khoản với MSSV ${student.student_code} đã tồn tại.` });
              continue; 
          }
          throw new Error(`Lỗi tạo tài khoản: ${authError.message}`);
        }

        if (!authData.user) {
          throw new Error('Không thể tạo người dùng sau khi đăng ký.');
        }
        profileId = authData.user.id;
      }

      // 3. Enroll student in selected classes if we have a profileId
      if (profileId) {
        const enrollments = classIds.map((classId: string) => ({
          class_id: classId,
          student_id: profileId!,
        }));

        // Upsert to avoid errors on duplicate enrollments
        const { error: enrollmentError } = await adminSupabase.from('enrollments').upsert(enrollments, { onConflict: 'class_id,student_id', ignoreDuplicates: true });

        if (enrollmentError) {
          // This is tricky. If user was newly created, should we delete them?
          // For now, we'll just report the enrollment error.
          throw new Error(`Lỗi ghi danh: ${enrollmentError.message}`);
        }
        processedStudents.push(student);
      }

    } catch (error: any) {
      errors.push({ student: student.student_code, error: error.message });
    }
  }

  if (errors.length > 0 && processedStudents.length === 0) {
      return NextResponse.json({ 
          message: "Thêm/ghi danh sinh viên thất bại. Vui lòng kiểm tra lại file.",
          errors: errors 
      }, { status: 400 });
  }

  if (errors.length > 0) {
    return NextResponse.json({
      message: `Hoàn thành với ${processedStudents.length} thành công và ${errors.length} lỗi.`,
      processedCount: processedStudents.length,
      errorCount: errors.length,
      errors: errors,
    }, { status: 207 }); // Multi-Status
  }

  return NextResponse.json({ message: `Đã xử lý thành công ${processedStudents.length} sinh viên và ghi danh vào các lớp đã chọn.` }, { status: 201 });
}