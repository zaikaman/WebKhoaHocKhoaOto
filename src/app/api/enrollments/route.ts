
import { NextResponse } from 'next/server'
import { adminSupabase } from '@/lib/supabase';

export async function POST(req: Request) {
  const { studentIds, classIds } = await req.json();

  if (!studentIds || !classIds || !Array.isArray(studentIds) || !Array.isArray(classIds) || studentIds.length === 0 || classIds.length === 0) {
    return NextResponse.json({ message: 'Dữ liệu không hợp lệ: studentIds và classIds là bắt buộc.' }, { status: 400 });
  }

  const enrollments: any[] = [];
  const errors: { student: string; error: string }[] = [];

  // 1. Find profile UUIDs for the given student codes
  const { data: profiles, error: profileError } = await adminSupabase
    .from('profiles')
    .select('id, student_id')
    .in('student_id', studentIds);

  if (profileError) {
    return NextResponse.json({ message: `Lỗi khi tìm thông tin sinh viên: ${profileError.message}` }, { status: 500 });
  }

  const foundStudentIds = profiles.map(p => p.student_id);
  const notFoundStudentIds = studentIds.filter(id => !foundStudentIds.includes(id));

  if (notFoundStudentIds.length > 0) {
    notFoundStudentIds.forEach(id => {
      errors.push({ student: id, error: 'Không tìm thấy sinh viên với mã số này.' });
    });
  }

  if (profiles.length === 0) {
    return NextResponse.json({ message: 'Không có sinh viên nào được tìm thấy để ghi danh.', errors }, { status: 404 });
  }

  // 2. Prepare enrollment records
  for (const classId of classIds) {
    for (const profile of profiles) {
      enrollments.push({
        class_id: classId,
        student_id: profile.id,
      });
    }
  }

  // 3. Upsert enrollments to avoid duplicates
  // `onConflict` will prevent errors if a student is already enrolled.
  // It will just ignore the duplicate entry.
  const { error: enrollmentError } = await adminSupabase
    .from('enrollments')
    .upsert(enrollments, { onConflict: 'class_id,student_id', ignoreDuplicates: true });

  if (enrollmentError) {
    errors.push({ student: 'N/A', error: `Lỗi khi ghi danh: ${enrollmentError.message}` });
  }
  
  const successCount = profiles.length;

  if (errors.length > 0) {
    return NextResponse.json({
      message: `Hoàn thành với một số lỗi.`,
      successCount,
      errorCount: errors.length,
      errors,
    }, { status: 207 });
  }

  return NextResponse.json({ message: `Đã ghi danh thành công ${successCount} sinh viên vào ${classIds.length} lớp học.` }, { status: 201 });
}
