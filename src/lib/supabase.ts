import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://lrnlbvdgqpazzwbsxhqc.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxybmxidmRncXBhenp3YnN4aHFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk1NDQ2NDYsImV4cCI6MjA1NTEyMDY0Nn0.dQwqFBrx2JApXKwBPrBRgnrwElliv4gmkVlAtkV5f5Y'

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

export async function signIn(studentId: string, password: string) {
  try {
    // Thử đăng nhập trước
    const { data, error } = await supabase.auth.signInWithPassword({
      email: `${studentId}@auto.edu.vn`,
      password,
    })

    if (error) {
      console.error('Lỗi đăng nhập:', error.message)
      throw new Error('Mật khẩu không chính xác')
    }

    // Sau khi đăng nhập thành công, lấy thông tin profile
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('student_id', studentId)
      .single()

    if (profileError) {
      console.error('Lỗi lấy profile:', profileError.message)
      throw new Error('Không tìm thấy thông tin sinh viên')
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

export async function getProfile() {
  const { data: { user }, error: userError } = await supabase.auth.getUser()
  if (userError) throw userError
  if (!user) return null

  const { data: profile, error: profileError } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  if (profileError) throw profileError
  return profile
} 