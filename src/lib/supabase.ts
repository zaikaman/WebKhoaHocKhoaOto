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
  subject?: Subject
  teacher?: Profile
  enrollments?: {
    id: string
    student_id: string
    student?: Profile
  }[]
  assignments?: {
    count: number
  }
  exams?: {
    count: number
  }
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
  created_at: string
  updated_at: string
}

export type ClassDetails = {
  id: string
  code: string
  name: string
  semester: string
  academic_year: string
  status: string
  teacher_id: string
  subject_id: string
  created_at: string
  updated_at: string
  teacher: {
    id: string
    full_name: string
  }
  subjects: {
    id: string
    name: string 
    code: string
    credits: number
  }
  lectures: {
    id: string
    title: string
    description: string | null
    file_url: string | null
    created_at: string
  }[]
  assignments: {
    id: string
    title: string
    description: string | null
    due_date: string
  }[]
  exams: {
    id: string
    title: string
    description: string | null
    start_time: string
    end_time: string
    duration: number
    status: string
  }[]
  enrollments: {
    count: number
  }
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

// Cập nhật hàm createEnrollment
export async function createEnrollment(data: {
  student_id: string
  full_name: string
  class_id: string
}) {
  try {
    // Kiểm tra xem sinh viên đã tồn tại chưa
    const { data: existingProfile, error: profileError } = await supabase
      .from('profiles')
      .select('id')
      .eq('student_id', data.student_id)
      .single()

    if (profileError) {
      return { success: false, message: 'Không tìm thấy sinh viên trong hệ thống' }
    }

    // Kiểm tra xem sinh viên đã đăng ký lớp này chưa
    const { data: existingEnrollment, error: enrollmentCheckError } = await supabase
      .from('enrollments')
      .select('id, status')
      .eq('class_id', data.class_id)
      .eq('student_id', existingProfile.id)
      .single()

    if (enrollmentCheckError && enrollmentCheckError.code !== 'PGRST116') {
      return { success: false, message: 'Lỗi khi kiểm tra đăng ký' }
    }

    if (existingEnrollment?.status === 'enrolled') {
      return { success: false, message: 'Sinh viên đã đăng ký lớp học này' }
    }

    // Kiểm tra quyền truy cập
    const { data: session } = await supabase.auth.getSession()
    if (!session?.session?.access_token) {
      return { success: false, message: 'Không có quyền thực hiện thao tác này' }
    }

    if (existingEnrollment) {
      // Cập nhật enrollment hiện có
      const { error: updateError } = await supabase
        .from('enrollments')
        .update({ 
          status: 'enrolled',
          updated_at: new Date().toISOString()
        })
        .eq('id', existingEnrollment.id)

      if (updateError) {
        return { success: false, message: 'Không thể cập nhật đăng ký' }
      }
    } else {
      // Tạo enrollment mới
      const { error: createError } = await supabase
        .from('enrollments')
        .insert([{
          class_id: data.class_id,
          student_id: existingProfile.id,
          status: 'enrolled',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }])

      if (createError) {
        return { success: false, message: 'Không thể tạo đăng ký mới' }
      }
    }

    return { success: true, message: 'Đăng ký lớp học thành công' }
  } catch (error: any) {
    return { 
      success: false, 
      message: error.message || 'Không thể thêm sinh viên vào lớp học'
    }
  }
}

export async function getStudentClasses(studentId: string) {
  try {
    console.log('StudentId nhận vào:', studentId)

    // Bước 1: Lấy danh sách class_id từ bảng enrollments
    const { data: enrollments, error: enrollmentError } = await supabase
      .from('enrollments')
      .select('*')
      .eq('student_id', studentId)
      .eq('status', 'enrolled')

    if (enrollmentError) throw enrollmentError

    if (!enrollments || enrollments.length === 0) {
      console.log('Không tìm thấy enrollment nào')
      return []
    }

    // Lấy danh sách class_id
    const classIds = enrollments.map(e => e.class_id)

    // Bước 2: Lấy thông tin các lớp học từ bảng classes
    const { data: classes, error: classError } = await supabase
      .from('classes')
      .select(`
        *,
        teacher:profiles!teacher_id (
          id,
          full_name
        ),
        subjects:subjects!subject_id (
          id,
          name,
          code,
          credits
        )
      `)
      .filter('id', 'in', `(${classIds.join(',')})`)

    if (classError) throw classError

    return classes || []

  } catch (error) {
    console.error('Lỗi chi tiết:', error)
    throw error
  }
}

// Hàm xóa sinh viên khỏi lớp học
export async function removeStudentFromClass(studentId: string, classId: string) {
  try {
    const { error } = await supabase
      .from('enrollments')
      .delete()
      .eq('student_id', studentId)
      .eq('class_id', classId)

    if (error) {
      console.error('Lỗi khi xóa sinh viên:', error)
      return {
        success: false,
        message: 'Không thể xóa sinh viên khỏi lớp học'
      }
    }

    return {
      success: true,
      message: 'Đã xóa sinh viên khỏi lớp học thành công'
    }
  } catch (error) {
    console.error('Lỗi chi tiết:', error)
    return {
      success: false,
      message: 'Có lỗi xảy ra khi xóa sinh viên'
    }
  }
}

//Lấy thông tin chi tiết lớp học theo Id lớp học
export async function getClassDetailsById(courseId: string): Promise<ClassDetails> {
  try {
    const { data, error } = await supabase
      .from('classes')
      .select(`
        *,
        teacher:profiles!teacher_id(id, full_name),
        subjects(id, name, code, credits),
        lectures(id, title, description, file_url, created_at),
        assignments(id, title, description, due_date),
        exams(id, title, description, start_time, end_time, duration, status),
        enrollments(count)
      `)
      .eq('id', courseId)
      .single()

    if (error) {
      console.error('Chi tiết lỗi:', {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw new Error(`Lỗi khi lấy thông tin lớp học: ${error.message}`)
    }

    if (!data) {
      throw new Error('Không tìm thấy thông tin lớp học')
    }

    console.log("Class details:", {
      id: data.id,
      code: data.code,
      name: data.name,
      semester: data.semester,
      academic_year: data.academic_year,
      status: data.status,
      teacher: data.teacher,
      subjects: data.subjects,
      lectures: data.lectures,
      assignments: data.assignments,
      exams: data.exams,
      enrollments: data.enrollments
    })

    return data
  } catch (error) {
    console.error('Lỗi khi lấy thông tin lớp học:', error)
    throw error
  }
}
export async function uploadAssignmentFile(file: File) {
  const fileExt = file.name.split('.').pop()
  const fileName = `${Math.random()}.${fileExt}`
  const filePath = `assignments/${fileName}`

  const { error: uploadError } = await supabase.storage
    .from('assignments')
    .upload(filePath, file)

  if (uploadError) {
    throw new Error(`Lỗi khi tải file lên: ${uploadError.message}`)
  }

  const { data: { publicUrl } } = supabase.storage
    .from('assignments')
    .getPublicUrl(filePath)

  return publicUrl
}