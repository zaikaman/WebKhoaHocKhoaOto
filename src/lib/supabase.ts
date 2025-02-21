import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://lrnlbvdgqpazzwbsxhqc.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxybmxidmRncXBhenp3YnN4aHFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk1NDQ2NDYsImV4cCI6MjA1NTEyMDY0Nn0.dQwqFBrx2JApXKwBPrBRgnrwElliv4gmkVlAtkV5f5Y'

// Types
export type Profile = {
  id: string
  student_id: string // Mã số sinh viên/giảng viên
  full_name: string | null
  role: 'student' | 'teacher' | 'admin'
  class_code: string | null
  status: 'active' | 'inactive'
  created_at: string
  updated_at: string
}

export type Subject = {
  id: string
  code: string
  name: string
  description: string | null
  credits: number
  created_at: string
  updated_at: string
}

export type Class = {
  id: string
  subject_id: string
  teacher_id: string
  code: string
  name: string
  semester: string
  academic_year: string
  status: 'active' | 'completed'
  created_at: string
  updated_at: string
}

export type Lecture = {
  id: string
  class_id: string
  title: string
  description: string | null
  file_url: string
  file_type: string
  file_size: number
  download_count: number
  created_at: string
  updated_at: string
}

export type Exam = {
  id: string
  class_id: string
  title: string
  description: string | null
  type: 'quiz' | 'midterm' | 'final'
  duration: number
  total_points: number
  start_time: string
  end_time: string
  status: 'upcoming' | 'in-progress' | 'completed'
  created_at: string
  updated_at: string
}

export type ExamQuestion = {
  id: string
  exam_id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: any | null
  correct_answer: string | null
  created_at: string
  updated_at: string
}

export type ExamSubmission = {
  id: string
  exam_id: string
  student_id: string
  answers: any | null
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
  created_at: string
  updated_at: string
}

export type Assignment = {
  id: string
  class_id: string
  title: string
  description: string | null
  due_date: string
  total_points: number
  file_url: string | null
  created_at: string
  updated_at: string
}

export type AssignmentSubmission = {
  id: string
  assignment_id: string
  student_id: string
  content: string | null
  file_url: string | null
  score: number | null
  submitted_at: string | null
  graded_at: string | null
  feedback: string | null
  created_at: string
  updated_at: string
}

export type Student = {
  id: string
  student_id: string
  full_name: string
  email: string
  class_code: string | null
  status: 'active' | 'inactive'
  created_at: string
  updated_at: string
}

export type Enrollment = {
  id: string
  class_id: string
  student_id: string
  status: 'enrolled' | 'dropped'
  grade: number | null
  created_at: string
  updated_at: string
}

export const supabase = createClient(supabaseUrl, supabaseKey)

// Hàm lấy danh sách tài khoản
export async function getAccounts() {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data
}

// Hàm thêm tài khoản mới
export async function createAccount(account: Omit<Profile, 'id' | 'created_at' | 'updated_at'>) {
  // Tạo auth user trước
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email: `${account.student_id}@auto.edu.vn`,
    password: 'password123', // Mật khẩu mặc định
  })

  if (authError) throw authError

  // Sau đó tạo profile
  const { data, error } = await supabase
    .from('profiles')
    .insert([
      {
        id: authData.user?.id,
        student_id: account.student_id,
        full_name: account.full_name,
        role: account.role,
        class_code: account.class_code,
        status: account.status,
      }
    ])
    .select()
    .single()

  if (error) throw error
  return data
}

// Hàm cập nhật tài khoản
export async function updateAccount(id: string, account: Partial<Profile>) {
  const { data, error } = await supabase
    .from('profiles')
    .update({
      student_id: account.student_id,
      full_name: account.full_name,
      role: account.role,
      class_code: account.class_code,
      status: account.status,
      updated_at: new Date().toISOString(),
    })
    .eq('id', id)
    .select()
    .single()

  if (error) throw error
  return data
}

// Hàm xóa tài khoản
export async function deleteAccount(id: string) {
  // Xóa auth user (sẽ tự động xóa profile do có cascade)
  const { error: authError } = await supabase.auth.admin.deleteUser(id)
  if (authError) throw authError
}

// Hàm xử lý auth
export async function signIn(studentId: string, password: string) {
  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: `${studentId}@gmail.com`,
      password,
    })

    if (error) {
      console.error('Lỗi đăng nhập:', error.message)
      throw new Error('Mật khẩu không chính xác')
    }

    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('student_id', studentId)
      .single()

    if (profileError) {
      console.error('Lỗi lấy profile:', profileError.message)
      throw new Error('Không tìm thấy thông tin người dùng')
    }

    return { user: data.user, profile }
  } catch (error) {
    console.error('Lỗi:', error)
    throw error
  }
}

export async function signOut() {
  const { error } = await supabase.auth.signOut()
  if (error) throw error
}

// Hàm lấy thông tin người dùng hiện tại
export async function getCurrentUser() {
  const { data: { user }, error: userError } = await supabase.auth.getUser()
  if (userError) throw userError
  if (!user) return null

  const { data: profile, error: profileError } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  if (profileError) throw profileError
  return { user, profile }
}

// Hàm xử lý lớp học
export async function getTeacherClasses(teacherId: string) {
  const { data, error } = await supabase
    .from('classes')
    .select(`
      *,
      subject:subjects(*),
      enrollments:enrollments(count),
      lectures:lectures(count),
      exams:exams(count),
      assignments:assignments(count)
    `)
    .eq('teacher_id', teacherId)
    .order('created_at', { ascending: false })

  if (error) throw error
  return data
}

export async function createClass(classData: Omit<Class, 'id' | 'created_at' | 'updated_at'>) {
  const { data, error } = await supabase
    .from('classes')
    .insert([classData])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function getClassById(classId: string) {
  const { data, error } = await supabase
    .from('classes')
    .select(`
      *,
      subject:subjects(*),
      teacher:profiles!teacher_id(*),
      enrollments:enrollments(
        student:profiles(*)
      ),
      lectures:lectures(*),
      exams:exams(*),
      assignments:assignments(*)
    `)
    .eq('id', classId)
    .single()

  if (error) throw error
  return data
}

// Hàm xử lý bài giảng
export async function getClassStudents(classId: string): Promise<Student[]> {
  try {
    const { data: enrollments, error: enrollmentError } = await supabase
      .from('enrollments')
      .select('student_id')
      .eq('class_id', classId)
      .eq('status', 'enrolled')

    if (enrollmentError) {
      console.error('Chi tiết lỗi:', {
        message: enrollmentError.message,
        details: enrollmentError.details,
        hint: enrollmentError.hint,
        code: enrollmentError.code
      })
      throw new Error(`Lỗi khi lấy danh sách sinh viên đã đăng ký: ${enrollmentError.message}`)
    }

    if (!enrollments?.length) {
      return []
    }

    const studentIds = enrollments.map(e => e.student_id)

    const { data: students, error: studentError } = await supabase
      .from('profiles')
      .select('*')
      .in('id', studentIds)
      .eq('role', 'student')

    if (studentError) {
      console.error('Chi tiết lỗi:', {
        message: studentError.message,
        details: studentError.details,
        hint: studentError.hint,
        code: studentError.code
      })
      throw new Error(`Lỗi khi lấy thông tin sinh viên: ${studentError.message}`)
    }

    return students || []
  } catch (error) {
    console.error('Lỗi khi lấy danh sách sinh viên:', error)
    throw error
  }
}

export async function getClassLectures(classId: string): Promise<Lecture[]> {
  try {
    const { data, error } = await supabase
      .from('lectures')
      .select('*')
      .eq('class_id', classId)
      .order('created_at', { ascending: false })

    if (error) {
      console.error('Chi tiết lỗi:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw new Error(`Lỗi khi lấy danh sách bài giảng: ${error.message}`)
    }

    return data || []
  } catch (error) {
    console.error('Lỗi khi lấy danh sách bài giảng:', error)
    throw error
  }
}

export async function createLecture(lecture: Omit<Lecture, 'id' | 'download_count' | 'created_at' | 'updated_at'>) {
  const { data, error } = await supabase
    .from('lectures')
    .insert([lecture])
    .select()
    .single()

  if (error) throw error
  return data
}

// Hàm xử lý bài kiểm tra
export async function getClassExams(classId: string): Promise<Exam[]> {
  try {
    const { data, error } = await supabase
      .from('exams')
      .select('*')
      .eq('class_id', classId)
      .order('start_time', { ascending: true })

    if (error) {
      console.error('Chi tiết lỗi:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw new Error(`Lỗi khi lấy danh sách bài kiểm tra: ${error.message}`)
    }

    return data || []
  } catch (error) {
    console.error('Lỗi khi lấy danh sách bài kiểm tra:', error)
    throw error
  }
}

export async function createExam(exam: Omit<Exam, 'id' | 'created_at' | 'updated_at'>) {
  const { data, error } = await supabase
    .from('exams')
    .insert([exam])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function getExamSubmissions(examId: string) {
  const { data, error } = await supabase
    .from('exam_submissions')
    .select(`
      *,
      student:profiles(*)
    `)
    .eq('exam_id', examId)
    .order('submitted_at', { ascending: false })

  if (error) throw error
  return data
}

export async function gradeExamSubmission(
  submissionId: string,
  score: number,
  feedback: string
) {
  const { data, error } = await supabase
    .from('exam_submissions')
    .update({
      score,
      feedback,
      graded_at: new Date().toISOString()
    })
    .eq('id', submissionId)
    .select()
    .single()

  if (error) throw error
  return data
}

// Hàm xử lý bài tập
export async function getClassAssignments(classId: string): Promise<Assignment[]> {
  try {
    const { data, error } = await supabase
      .from('assignments')
      .select('*')
      .eq('class_id', classId)
      .order('due_date', { ascending: true })

    if (error) {
      console.error('Chi tiết lỗi:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw new Error(`Lỗi khi lấy danh sách bài tập: ${error.message}`)
    }

    return data || []
  } catch (error) {
    console.error('Lỗi khi lấy danh sách bài tập:', error)
    throw error
  }
}

export async function createAssignment(assignment: Omit<Assignment, 'id' | 'created_at' | 'updated_at'>) {
  const { data, error } = await supabase
    .from('assignments')
    .insert([assignment])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function getAssignmentSubmissions(assignmentId: string) {
  const { data, error } = await supabase
    .from('assignment_submissions')
    .select(`
      *,
      student:profiles(*)
    `)
    .eq('assignment_id', assignmentId)
    .order('submitted_at', { ascending: false })

  if (error) throw error
  return data
}

export async function gradeAssignmentSubmission(
  submissionId: string,
  score: number,
  feedback: string
) {
  const { data, error } = await supabase
    .from('assignment_submissions')
    .update({
      score,
      feedback,
      graded_at: new Date().toISOString()
    })
    .eq('id', submissionId)
    .select()
    .single()

  if (error) throw error
  return data
}

// Hàm thống kê
export async function getTeacherStats(teacherId: string) {
  const { data: classes, error: classError } = await supabase
    .from('classes')
    .select('id')
    .eq('teacher_id', teacherId)
    .eq('status', 'active')

  if (classError) throw classError

  const classIds = classes.map(c => c.id)

  const [
    { count: totalStudents },
    { count: totalLectures },
    { count: totalExams },
    { count: totalAssignments }
  ] = await Promise.all([
    supabase
      .from('enrollments')
      .select('*', { count: 'exact' })
      .in('class_id', classIds)
      .eq('status', 'enrolled'),
    supabase
      .from('lectures')
      .select('*', { count: 'exact' })
      .in('class_id', classIds),
    supabase
      .from('exams')
      .select('*', { count: 'exact' })
      .in('class_id', classIds),
    supabase
      .from('assignments')
      .select('*', { count: 'exact' })
      .in('class_id', classIds)
  ])

  return {
    totalClasses: classes.length,
    totalStudents,
    totalLectures,
    totalExams,
    totalAssignments
  }
}

// Hàm lấy danh sách môn học
export async function getSubjects() {
  const { data, error } = await supabase
    .from('subjects')
    .select('*')
    .order('code', { ascending: true })

  if (error) throw error
  return data
}

export async function createSubject(subjectData: Omit<Subject, 'id' | 'created_at' | 'updated_at'>) {
  try {
    const { data, error } = await supabase
      .from('subjects')
      .insert({
        ...subjectData,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
      .single()

    if (error) {
      console.error('Chi tiết lỗi:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw new Error(`Lỗi khi tạo môn học: ${error.message}`)
    }

    return data
  } catch (error) {
    console.error('Lỗi khi tạo môn học:', error)
    throw error
  }
} 