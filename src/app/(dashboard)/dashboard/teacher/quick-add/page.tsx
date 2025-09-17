'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { useToast } from '@/components/ui/use-toast'
import { sanitizeDescription } from '@/lib/utils'
import { getCurrentUser, getTeacherClasses, createAssignmentForClasses, createExamForClasses, createExamQuestion, createAssignmentQuestions, createLectureForClasses } from '@/lib/supabase'
import type { Class, ExamQuestion, AssignmentQuestion } from '@/lib/supabase'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import * as XLSX from 'xlsx'
import { FileUpIcon, XIcon } from 'lucide-react'
import { QuickAddSkeleton } from "../components/QuickAddSkeleton";

// Define student type for creation
interface Student {
  student_code: string;
  full_name: string;
  email: string;
  date_of_birth?: string;
}

export default function QuickAddPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [classes, setClasses] = useState<Class[]>([])
  const [selectedClasses, setSelectedClasses] = useState<string[]>([])
  const [addType, setAddType] = useState<'assignment' | 'exam' | 'student' | 'lecture'>('assignment')
  
  // State for questions
  const [questions, setQuestions] = useState<Partial<ExamQuestion | AssignmentQuestion>[]>([])
  const [newQuestion, setNewQuestion] = useState<Partial<ExamQuestion | AssignmentQuestion>>({ type: 'multiple_choice', options: ['', '', '', ''] })

  // State for student management
  const [studentAddMode, setStudentAddMode] = useState('import'); // 'import' or 'enroll'
  const [studentsToCreate, setStudentsToCreate] = useState<Student[]>([])
  const [studentIdInput, setStudentIdInput] = useState('');
  const [studentsToEnroll, setStudentsToEnroll] = useState<string[]>([]);

  // State for lectures
  const [lectures, setLectures] = useState<any[]>([])
  const [newLecture, setNewLecture] = useState<any>({ title: '', description: '', video_url: '', files: { vie: null, eng: null, sim: null } })

  const [selectedFile, setSelectedFile] = useState<File | null>(null)

    useEffect(() => {
    loadData()
  }, [])

  // Reset states when addType changes
  useEffect(() => {
    setSelectedFile(null);
    setQuestions([]);
    setStudentsToCreate([]);
    setStudentsToEnroll([]);
    setStudentIdInput('');
    setNewQuestion({ type: 'multiple_choice', options: ['', '', '', ''] });
    setLectures([]);
    setNewLecture({ title: '', description: '', video_url: '', files: { vie: null, eng: null, sim: null } });
  }, [addType]);

  async function loadData() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'teacher') {
        router.push('/login')
        return
      }
      const teacherClasses = await getTeacherClasses(currentUser.profile.id)
      setClasses(teacherClasses)
    } catch (error: any) {
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: 'Không thể tải danh sách lớp học.',
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleClassSelection = (classId: string) => {
    setSelectedClasses(prev =>
      prev.includes(classId)
        ? prev.filter(id => id !== classId)
        : [...prev, classId]
    )
  }

  const handleSelectAllClasses = () => {
    if (selectedClasses.length === classes.length) {
      setSelectedClasses([])
    } else {
      setSelectedClasses(classes.map(c => c.id))
    }
  }

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    setQuestions([]); // Reset questions on new file selection
    setSelectedFile(file)

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data, { type: 'buffer' });

      if (!workbook || !workbook.SheetNames || workbook.SheetNames.length === 0) {
          throw new Error("File Excel không hợp lệ hoặc không có trang tính (sheet) nào.");
      }

      const worksheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[worksheetName];

      if (!worksheet) {
          throw new Error(`Không thể tìm thấy trang tính có tên "${worksheetName}".`);
      }

      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      if (jsonData.length === 0) {
        setQuestions([]);
        toast({
            variant: "default",
            title: "File trống",
            description: "File Excel không có dữ liệu hoặc các cột không được đặt tên đúng."
        });
        return;
      }

      const newQuestions = jsonData.map((row: any) => ({
        content: String(row['Câu hỏi'] || row['Question'] || ''),
        options: [
          row['Phương án A'] || row['Option A'],
          row['Phương án B'] || row['Option B'],
          row['Phương án C'] || row['Option C'],
          row['Phương án D'] || row['Option D']
        ].map(option => String(option || '')).filter(option => option.trim() !== ''),
        correct_answer: String(row['Đáp án đúng'] || row['Correct Answer'] || ''),
        points: Number(row['Điểm'] || row['Points'] || 10),
        type: 'multiple_choice' as 'multiple_choice' | 'essay'
      })).filter(q => q.content && q.correct_answer)

      if (newQuestions.length === 0) {
        setQuestions([]);
        toast({
            variant: "default",
            title: "Không tìm thấy câu hỏi",
            description: "Không tìm thấy câu hỏi hợp lệ nào. Vui lòng kiểm tra lại tên các cột trong file Excel."
        });
        return;
      }

      setQuestions(newQuestions)
      
      toast({
        title: "Thành công",
        description: `Đã tải ${newQuestions.length} câu hỏi từ file Excel`
      })
    } catch (error: any) {
      console.error('Lỗi khi đọc file Excel:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error.message || "Không thể đọc file Excel. Vui lòng kiểm tra định dạng file."
      })
    }
  }

  const handleStudentCreateFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setSelectedFile(file);
    try {
      const data = await file.arrayBuffer();
      const workbook = XLSX.read(data);
      const worksheetName = workbook.SheetNames[0];
      const worksheet = workbook.Sheets[worksheetName];
      const json = XLSX.utils.sheet_to_json<Student>(worksheet);
      setStudentsToCreate(json);
      toast({
        title: "Thành công",
        description: `Đã phân tích ${json.length} sinh viên từ file. Nhấn nút gửi để hoàn tất.`,
      });
    } catch (error) {
      console.error("Error reading student file:", error);
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể đọc file." });
    }
  };

  const handleAddStudentToEnrollList = () => {
    if (studentIdInput && !studentsToEnroll.includes(studentIdInput)) {
      setStudentsToEnroll([...studentsToEnroll, studentIdInput]);
      setStudentIdInput('');
    }
  };

  const handleRemoveStudentFromEnrollList = (idToRemove: string) => {
    setStudentsToEnroll(studentsToEnroll.filter(id => id !== idToRemove));
  };

  const handleDownloadStudentTemplate = () => {
    const templateData = [
      {
        student_code: '20240001',
        full_name: 'Nguyễn Văn A',
        email: 'a.nv@example.com',
        date_of_birth: '2002-01-15'
      },
      {
        student_code: '20240002',
        full_name: 'Trần Thị B',
        email: 'b.tt@example.com',
        date_of_birth: '2002-03-20'
      }
    ];
    const worksheet = XLSX.utils.json_to_sheet(templateData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Danh sách sinh viên');
    XLSX.writeFile(workbook, 'mau_danh_sach_sinh_vien.xlsx');
  };

  const handleDownloadTemplate = () => {
    const templateData = [
      {
        'Câu hỏi': 'Câu hỏi mẫu 1?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'Đáp án A',
        'Điểm': 10
      },
      {
        'Câu hỏi': 'Câu hỏi mẫu 2?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'Đáp án B',
        'Điểm': 10
      }
    ]

    const worksheet = XLSX.utils.json_to_sheet(templateData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Template')
    XLSX.writeFile(workbook, 'template_bai_tap.xlsx')
  }

  const handleAddQuestion = () => {
    if (newQuestion.content && (newQuestion.type === 'essay' || newQuestion.correct_answer)) {
      setQuestions([...questions, newQuestion])
      setNewQuestion({ type: newQuestion.type, options: ['', '', '', ''] })
    }
  }

  const handleAddLecture = () => {
    if (newLecture.title) {
      setLectures([...lectures, newLecture]);
      setNewLecture({ title: '', description: '', video_url: '', files: { vie: null, eng: null, sim: null } });
    }
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (selectedClasses.length === 0) {
      toast({ variant: 'destructive', title: 'Lỗi', description: 'Vui lòng chọn ít nhất một lớp học.' });
      return;
    }
    setIsLoading(true);

    try {
      if (addType === 'student') {
        if (studentAddMode === 'import') {
          if (studentsToCreate.length === 0) {
            toast({ variant: "destructive", title: "Lỗi", description: "Không có sinh viên nào trong file để tạo mới." });
            setIsLoading(false);
            return;
          }
          const response = await fetch('/api/students/import', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ students: studentsToCreate, classIds: selectedClasses }),
          });
          const result = await response.json();

          if (!response.ok) {
            let errorMessage = result.message || 'Có lỗi xảy ra khi tạo sinh viên.';
            if (result.errors && Array.isArray(result.errors)) {
              const errorDetails = result.errors.map((err: { student: any; error: any; }) => `
- Sinh viên ${err.student}: ${err.error}`).join('');
              errorMessage += ` Chi tiết:${errorDetails}`;
            }
            throw new Error(errorMessage);
          }
          
          toast({ title: 'Thành công', description: result.message });

        } else if (studentAddMode === 'enroll') {
          if (studentsToEnroll.length === 0) {
            toast({ variant: "destructive", title: "Lỗi", description: "Chưa có mã số sinh viên nào trong danh sách để ghi danh." });
            setIsLoading(false);
            return;
          }
          const response = await fetch('/api/enrollments', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ studentIds: studentsToEnroll, classIds: selectedClasses }),
          });
          const result = await response.json();
          if (!response.ok) throw new Error(result.message || 'Có lỗi xảy ra khi ghi danh.');
          toast({ title: 'Thành công', description: result.message });
        }
        router.push('/dashboard/teacher/classes');

      } else if (addType === 'lecture') {
        if (lectures.length === 0) {
          toast({ variant: "destructive", title: "Lỗi", description: "Vui lòng thêm ít nhất một bài giảng." });
          setIsLoading(false);
          return;
        }
        for (const lecture of lectures) {
          await createLectureForClasses({ title: lecture.title, description: lecture.description, video_url: lecture.video_url }, selectedClasses, lecture.files);
        }
        toast({ title: 'Thành công', description: `Đã tạo ${lectures.length} bài giảng cho các lớp đã chọn.` })
        router.push('/dashboard/teacher/classes');
      } else {
        const formData = new FormData(event.currentTarget)
        if (addType === 'assignment') {
          const assignmentData = { title: formData.get('title') as string, description: sanitizeDescription(formData.get('description') as string), due_date: formData.get('due_date') as string, total_points: parseInt(formData.get('total_points') as string, 10), file_url: null }
          const newAssignments = await createAssignmentForClasses(assignmentData, selectedClasses)
          if (newAssignments) {
            for (const assignment of newAssignments) {
              if (questions.length > 0) {
                await createAssignmentQuestions(questions.map(q => ({ ...q, assignment_id: assignment.id })) as Omit<AssignmentQuestion, 'id' | 'created_at' | 'updated_at'>[])
              }
            }
          }
          toast({ title: 'Thành công', description: 'Đã tạo bài tập cho các lớp đã chọn.' })
        } else if (addType === 'exam') {
          const examData = { title: formData.get('title') as string, description: sanitizeDescription(formData.get('description') as string), type: formData.get('type') as 'quiz' | 'midterm' | 'final', duration: parseInt(formData.get('duration') as string, 10), total_points: parseInt(formData.get('total_points') as string, 10), start_time: formData.get('start_time') as string, end_time: formData.get('end_time') as string, status: 'upcoming' as const, max_attempts: parseInt(formData.get('max_attempts') as string, 10) || 1, }
          const newExams = await createExamForClasses(examData, selectedClasses)
          if (newExams) {
            for (const exam of newExams) {
              for (const q of questions) {
                 await createExamQuestion({ ...q, exam_id: exam.id } as Omit<ExamQuestion, 'id' | 'created_at' | 'updated_at'>)
              }
            }
          }
          toast({ title: 'Thành công', description: 'Đã tạo bài kiểm tra cho các lớp đã chọn.' })
        }
        router.push('/dashboard/teacher/classes')
      }
    } catch (error: any) {
      toast({ variant: 'destructive', title: 'Lỗi', description: error.message || 'Thao tác thất bại.' })
    } finally {
      setIsLoading(false)
    }
  }

  const FileUploadSlot = ({ title, accept, file, setFile, disabled }: { title: string, accept: string, file: File | null, setFile: (file: File | null) => void, disabled: boolean }) => {
    const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      const selectedFile = event.target.files?.[0] || null;
      setFile(selectedFile);
    };
  
    const handleRemoveFile = () => {
      setFile(null);
    };
  
    return (
      <div className="space-y-1">
        <label className="text-sm font-medium">{title}</label>
        <div className="mt-1">
          {!file ? (
            <label className="flex items-center justify-center w-full h-24 px-4 transition bg-white border-2 border-dashed rounded-lg appearance-none cursor-pointer hover:border-gray-400 focus:outline-none">
              <div className="flex flex-col items-center space-y-1">
                <FileUpIcon className="w-5 h-5 text-gray-500"/>
                <span className="font-medium text-xs text-gray-600">Kéo thả hoặc chọn file</span>
              </div>
              <Input type="file" className="hidden" accept={accept} onChange={handleFileChange} disabled={disabled} />
            </label>
          ) : (
            <div className="p-3 bg-gray-50 border border-gray-200 rounded-lg">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <FileUpIcon className="w-6 h-6 text-gray-600"/>
                  <div>
                    <p className="text-sm font-medium text-gray-700 truncate max-w-[200px]">{file.name}</p>
                    <p className="text-xs text-gray-500">{(file.size / (1024 * 1024)).toFixed(2)} MB</p>
                  </div>
                </div>
                <Button type="button" variant="ghost" size="icon" onClick={handleRemoveFile} disabled={disabled} className="text-red-500 hover:text-red-700">
                  <XIcon size={16} />
                </Button>
              </div>
            </div>
          )}
        </div>
      </div>
    );
  };

  if (isLoading) {
    return <QuickAddSkeleton />;
  }

  return (
    <div className='space-y-8 container mx-auto py-10'>
      <div className="flex items-center justify-between">
        <div>
          <h1 className='text-2xl font-bold'>Thêm nhanh</h1>
          <p className="text-muted-foreground">
            Thêm bài tập, bài kiểm tra, hoặc sinh viên cho nhiều lớp học cùng một lúc.
          </p>
        </div>
      </div>
      <form onSubmit={handleSubmit} className="space-y-8">
        <Card>
          <CardHeader>
            <CardTitle>1. Chọn lớp học</CardTitle>
          </CardHeader>
          <CardContent>
            <div className='flex items-center mb-4'>
              <Checkbox
                id='select-all'
                checked={selectedClasses.length === classes.length && classes.length > 0}
                onCheckedChange={handleSelectAllClasses}
                className='mr-2'
              />
              <Label htmlFor='select-all'>Chọn tất cả</Label>
            </div>
            <div className='grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4'>
              {classes.map(classItem => (
                <div key={classItem.id} className={'border rounded-lg p-4 flex items-center transition-all ' + (selectedClasses.includes(classItem.id) ? 'bg-blue-50 border-blue-200' : '')}>
                  <Checkbox
                    id={classItem.id}
                    checked={selectedClasses.includes(classItem.id)}
                    onCheckedChange={() => handleClassSelection(classItem.id)}
                    className='mr-2'
                  />
                  <Label htmlFor={classItem.id} className="w-full">{classItem.name}</Label>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>2. Chọn loại</CardTitle>
          </CardHeader>
          <CardContent>
            <div className='flex gap-4'>
              <Button
                type='button'
                variant={addType === 'assignment' ? 'default' : 'outline'}
                onClick={() => setAddType('assignment')}
              >
                Bài tập
              </Button>
              <Button
                type='button'
                variant={addType === 'exam' ? 'default' : 'outline'}
                onClick={() => setAddType('exam')}
              >
                Bài kiểm tra
              </Button>
              <Button
                type='button'
                variant={addType === 'student' ? 'default' : 'outline'}
                onClick={() => setAddType('student')}
              >
                Sinh viên
              </Button>
              <Button
                type='button'
                variant={addType === 'lecture' ? 'default' : 'outline'}
                onClick={() => setAddType('lecture')}
              >
                Bài giảng
              </Button>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>3. Nhập thông tin</CardTitle>
          </CardHeader>
          <CardContent>
            {addType === 'assignment' && (
              <div className='space-y-4'>
                <h3 className='text-lg font-medium'>Thông tin bài tập</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="form-field">
                    <Input id='title' name='title' required className="form-input peer" placeholder="Tiêu đề" />
                    <Label htmlFor='title' className="form-label">Tiêu đề</Label>
                  </div>
                  <div className="form-field">
                    <Input id='total_points' name='total_points' type='number' required className="form-input peer" placeholder="Tổng điểm" />
                    <Label htmlFor='total_points' className="form-label">Tổng điểm</Label>
                  </div>
                </div>
                <div className="relative pt-5">
                  <Textarea id='description' name='description' className="form-textarea peer" placeholder="Mô tả" />
                  <Label htmlFor='description' className="form-textarea-label">Mô tả</Label>
                </div>
                <div className="form-field">
                  <Input id='due_date' name='due_date' type='datetime-local' required className="form-input peer" placeholder="Hạn nộp" />
                  <Label htmlFor='due_date' className="form-label">Hạn nộp</Label>
                </div>
                <Tabs defaultValue="manual">
                  <TabsList>
                    <TabsTrigger value="manual">Nhập tay</TabsTrigger>
                    <TabsTrigger value="import">Import Excel</TabsTrigger>
                  </TabsList>
                  <TabsContent value="manual">
                    <div className="space-y-4 pt-4">
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-end">
                        <div className="space-y-2">
                          <Label>Loại câu hỏi</Label>
                          <Select onValueChange={(value) => setNewQuestion({ ...newQuestion, type: value as 'multiple_choice' | 'essay', options: value === 'multiple_choice' ? ['', '', '', ''] : undefined })}>
                            <SelectTrigger>
                              <SelectValue placeholder="Chọn loại câu hỏi" />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="multiple_choice">Trắc nghiệm</SelectItem>
                              <SelectItem value="essay">Tự luận</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="form-field">
                          <Input id="new-question-points" type="number" value={newQuestion.points || ''} onChange={(e) => setNewQuestion({ ...newQuestion, points: parseInt(e.target.value) })} className="form-input peer" placeholder="Điểm" />
                          <Label htmlFor="new-question-points" className="form-label">Điểm</Label>
                        </div>
                      </div>
                      <div className="relative pt-5">
                        <Textarea id="new-question-content" value={newQuestion.content || ''} onChange={(e) => setNewQuestion({ ...newQuestion, content: e.target.value })} className="form-textarea peer" placeholder="Nội dung câu hỏi" />
                        <Label htmlFor="new-question-content" className="form-textarea-label">Nội dung câu hỏi</Label>
                      </div>
                      {newQuestion.type === 'multiple_choice' && (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div className="form-field">
                            <Input value={newQuestion.options?.[0] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[0] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án A" />
                            <Label className="form-label">Phương án A</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[1] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[1] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án B" />
                            <Label className="form-label">Phương án B</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[2] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[2] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án C" />
                            <Label className="form-label">Phương án C</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[3] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[3] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án D" />
                            <Label className="form-label">Phương án D</Label>
                          </div>
                          <div className="form-field md:col-span-2">
                            <Input value={newQuestion.correct_answer || ''} onChange={(e) => setNewQuestion({ ...newQuestion, correct_answer: e.target.value })} className="form-input peer" placeholder="Đáp án đúng" />
                            <Label className="form-label">Đáp án đúng</Label>
                          </div>
                        </div>
                      )}
                      <Button type="button" onClick={handleAddQuestion}>Thêm câu hỏi</Button>
                    </div>
                    <div className="space-y-2 pt-4">
                      <h4 className="font-medium">Danh sách câu hỏi</h4>
                      {questions.map((q, i) => (
                        <div key={i} className="border p-4 rounded-md">
                          <p>{i + 1}. {q.content}</p>
                          {q.type === 'multiple_choice' && (
                            <ul className="list-disc pl-5">
                              {q.options?.map((opt: string, j: number) => (
                                <li key={j} className={q.correct_answer === opt ? 'font-bold' : ''}>{opt}</li>
                              ))}
                            </ul>
                          )}
                        </div>
                      ))}
                    </div>
                  </TabsContent>
                  <TabsContent value="import">
                    <div className="space-y-2">
                      {selectedFile ? (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors flex flex-col items-center justify-center space-y-4">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Đã chọn file:</p>
                            <p className="text-sm font-medium mt-1">{selectedFile.name}</p>
                            <p className="text-xs text-muted-foreground mt-1">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</p>
                          </div>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => setSelectedFile(null)}
                          >
                            Xóa file
                          </Button>
                        </div>
                      ) : (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors text-center flex flex-col items-center justify-center space-y-4">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Chọn file Excel để tải lên</p>
                            <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                            <p className="text-xs text-muted-foreground mt-2">
                              Định dạng hỗ trợ: XLSX, XLS
                            </p>
                          </div>
                          <input
                            id="file-upload"
                            type="file"
                            accept=".xlsx,.xls"
                            onChange={handleFileUpload}
                            className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                          />
                        </div>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground mt-4">
                      File Excel của bạn phải có định dạng với các cột "Câu hỏi", "Phương án A", "Phương án B", "Phương án C", "Phương án D" và "Đáp án đúng".{' '}
                      <Button
                        variant="link"
                        className="h-auto p-0 text-blue-600 underline"
                        onClick={handleDownloadTemplate}
                        type="button"
                      >
                        Tải mẫu
                      </Button>
                    </p>
                  </TabsContent>
                </Tabs>
              </div>
            )}

            {addType === 'exam' && (
              <div className='space-y-4'>
                <h3 className='text-lg font-medium'>Thông tin bài kiểm tra</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="form-field">
                    <Input id='title' name='title' required className="form-input peer" placeholder="Tiêu đề" />
                    <Label htmlFor='title' className="form-label">Tiêu đề</Label>
                  </div>
                  <div className="form-field">
                    <Label htmlFor='type' className="absolute -top-3 left-3 text-sm text-blue-500">Loại</Label>
                    <Select name="type">
                      <SelectTrigger>
                        <SelectValue placeholder="Chọn loại bài kiểm tra" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="quiz">Quiz</SelectItem>
                        <SelectItem value="midterm">Giữa kỳ</SelectItem>
                        <SelectItem value="final">Cuối kỳ</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="form-field">
                    <Input id='duration' name='duration' type='number' required className="form-input peer" placeholder="Thời gian làm bài (phút)" />
                    <Label htmlFor='duration' className="form-label">Thời gian làm bài (phút)</Label>
                  </div>
                  <div className="form-field">
                    <Input id='total_points' name='total_points' type='number' required className="form-input peer" placeholder="Tổng điểm" />
                    <Label htmlFor='total_points' className="form-label">Tổng điểm</Label>
                  </div>
                  <div className="form-field">
                    <Input id='max_attempts' name='max_attempts' type='number' defaultValue={1} required className="form-input peer" placeholder="Số lần làm bài" />
                    <Label htmlFor='max_attempts' className="form-label">Số lần làm bài</Label>
                  </div>
                  <div className="form-field">
                    <Input id='start_time' name='start_time' type='datetime-local' required className="form-input peer" placeholder="Thời gian bắt đầu" />
                    <Label htmlFor='start_time' className="form-label">Thời gian bắt đầu</Label>
                  </div>
                  <div className="form-field">
                    <Input id='end_time' name='end_time' type='datetime-local' required className="form-input peer" placeholder="Thời gian kết thúc" />
                    <Label htmlFor='end_time' className="form-label">Thời gian kết thúc</Label>
                  </div>
                </div>
                <div className="relative pt-5">
                  <Textarea id='description' name='description' className="form-textarea peer" placeholder="Mô tả" />
                  <Label htmlFor='description' className="form-textarea-label">Mô tả</Label>
                </div>
                <Tabs defaultValue="manual">
                  <TabsList>
                    <TabsTrigger value="manual">Nhập tay</TabsTrigger>
                    <TabsTrigger value="import">Import Excel</TabsTrigger>
                  </TabsList>
                  <TabsContent value="manual">
                    <div className="space-y-4 pt-4">
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-end">
                        <div className="space-y-2">
                          <Label>Loại câu hỏi</Label>
                          <Select onValueChange={(value) => setNewQuestion({ ...newQuestion, type: value as 'multiple_choice' | 'essay', options: value === 'multiple_choice' ? ['', '', '', ''] : undefined })}>
                            <SelectTrigger>
                              <SelectValue placeholder="Chọn loại câu hỏi" />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="multiple_choice">Trắc nghiệm</SelectItem>
                              <SelectItem value="essay">Tự luận</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="form-field">
                          <Input id="new-question-points" type="number" value={newQuestion.points || ''} onChange={(e) => setNewQuestion({ ...newQuestion, points: parseInt(e.target.value) })} className="form-input peer" placeholder="Điểm" />
                          <Label htmlFor="new-question-points" className="form-label">Điểm</Label>
                        </div>
                      </div>
                      <div className="relative pt-5">
                        <Textarea id="new-question-content" value={newQuestion.content || ''} onChange={(e) => setNewQuestion({ ...newQuestion, content: e.target.value })} className="form-textarea peer" placeholder="Nội dung câu hỏi" />
                        <Label htmlFor="new-question-content" className="form-textarea-label">Nội dung câu hỏi</Label>
                      </div>
                      {newQuestion.type === 'multiple_choice' && (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div className="form-field">
                            <Input value={newQuestion.options?.[0] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[0] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án A" />
                            <Label className="form-label">Phương án A</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[1] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[1] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án B" />
                            <Label className="form-label">Phương án B</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[2] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[2] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án C" />
                            <Label className="form-label">Phương án C</Label>
                          </div>
                          <div className="form-field">
                            <Input value={newQuestion.options?.[3] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[3] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} className="form-input peer" placeholder="Phương án D" />
                            <Label className="form-label">Phương án D</Label>
                          </div>
                          <div className="form-field md:col-span-2">
                            <Input value={newQuestion.correct_answer || ''} onChange={(e) => setNewQuestion({ ...newQuestion, correct_answer: e.target.value })} className="form-input peer" placeholder="Đáp án đúng" />
                            <Label className="form-label">Đáp án đúng</Label>
                          </div>
                        </div>
                      )}
                      <Button type="button" onClick={handleAddQuestion}>Thêm câu hỏi</Button>
                    </div>
                    <div className="space-y-2 pt-4">
                      <h4 className="font-medium">Danh sách câu hỏi</h4>
                      {questions.map((q, i) => (
                        <div key={i} className="border p-4 rounded-md">
                          <p>{i + 1}. {q.content}</p>
                          {q.type === 'multiple_choice' && (
                            <ul className="list-disc pl-5">
                              {q.options?.map((opt: string, j: number) => (
                                <li key={j} className={q.correct_answer === opt ? 'font-bold' : ''}>{opt}</li>
                              ))}
                            </ul>
                          )}
                        </div>
                      ))}
                    </div>
                  </TabsContent>
                  <TabsContent value="import">
                    <div className="space-y-2">
                      {selectedFile ? (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors flex flex-col items-center justify-center space-y-4">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Đã chọn file:</p>
                            <p className="text-sm font-medium mt-1">{selectedFile.name}</p>
                            <p className="text-xs text-muted-foreground mt-1">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</p>
                          </div>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => setSelectedFile(null)}
                          >
                            Xóa file
                          </Button>
                        </div>
                      ) : (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors text-center flex flex-col items-center justify-center space-y-4">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Chọn file Excel để tải lên</p>
                            <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                            <p className="text-xs text-muted-foreground mt-2">
                              Định dạng hỗ trợ: XLSX, XLS
                            </p>
                          </div>
                          <input
                            id="file-upload"
                            type="file"
                            accept=".xlsx,.xls"
                            onChange={handleFileUpload}
                            className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                          />
                        </div>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground mt-4">
                      File Excel của bạn phải có định dạng với các cột "Câu hỏi", "Phương án A", "Phương án B", "Phương án C", "Phương án D" và "Đáp án đúng".{' '}
                      <Button
                        variant="link"
                        className="h-auto p-0 text-blue-600 underline"
                        onClick={handleDownloadTemplate}
                        type="button"
                      >
                        Tải mẫu
                      </Button>
                    </p>
                  </TabsContent>
                </Tabs>
              </div>
            )}

            {addType === 'lecture' && (
              <div className='space-y-4'>
                <h3 className='text-lg font-medium'>Thông tin bài giảng</h3>
                <div className="form-field">
                  <Input id='new-lecture-title' value={newLecture.title} onChange={(e) => setNewLecture({ ...newLecture, title: e.target.value })} className="form-input peer" placeholder="Tiêu đề" />
                  <Label htmlFor='new-lecture-title' className="form-label">Tiêu đề</Label>
                </div>
                <div className="relative pt-5">
                  <Textarea id='new-lecture-description' value={newLecture.description} onChange={(e) => setNewLecture({ ...newLecture, description: e.target.value })} className="form-textarea peer" placeholder="Mô tả" />
                  <Label htmlFor='new-lecture-description' className="form-textarea-label">Mô tả</Label>
                </div>
                <div className="form-field">
                  <Input id='new-lecture-video-url' value={newLecture.video_url} onChange={(e) => setNewLecture({ ...newLecture, video_url: e.target.value })} className="form-input peer" placeholder="Link video YouTube" />
                  <Label htmlFor='new-lecture-video-url' className="form-label">Link video YouTube</Label>
                </div>
                
                <div className="space-y-4 pt-4 border-t">
                  <FileUploadSlot title="File Tiếng Việt (VIE)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={newLecture.files.vie} setFile={(file) => setNewLecture({ ...newLecture, files: { ...newLecture.files, vie: file } })} disabled={isLoading} />
                  <FileUploadSlot title="File Tiếng Anh (ENG)" accept=".pdf,.doc,.docx,.ppt,.pptx" file={newLecture.files.eng} setFile={(file) => setNewLecture({ ...newLecture, files: { ...newLecture.files, eng: file } })} disabled={isLoading} />
                  <FileUploadSlot title="File Mô phỏng (SIM)" accept=".html,.swf" file={newLecture.files.sim} setFile={(file) => setNewLecture({ ...newLecture, files: { ...newLecture.files, sim: file } })} disabled={isLoading} />
                </div>

                <Button type="button" onClick={handleAddLecture}>Thêm bài giảng vào danh sách</Button>

                <div className="space-y-2 pt-4">
                  <h4 className="font-medium">Danh sách bài giảng sẽ được tạo</h4>
                  {lectures.map((lecture, i) => (
                    <div key={i} className="border p-4 rounded-md">
                      <p className="font-bold">{i + 1}. {lecture.title}</p>
                      <p className="text-sm text-muted-foreground">{lecture.description}</p>
                      {lecture.video_url && <p className="text-sm text-blue-500">Video: {lecture.video_url}</p>}
                      <ul className="list-disc pl-5 mt-2">
                        {lecture.files.vie && <li>VIE: {lecture.files.vie.name}</li>}
                        {lecture.files.eng && <li>ENG: {lecture.files.eng.name}</li>}
                        {lecture.files.sim && <li>SIM: {lecture.files.sim.name}</li>}
                      </ul>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {addType === 'student' && (
              <Tabs defaultValue="import" onValueChange={(value) => setStudentAddMode(value)}>
                <TabsList>
                  <TabsTrigger value="import">Tạo & Ghi danh bằng File</TabsTrigger>
                  <TabsTrigger value="enroll">Ghi danh bằng MSSV</TabsTrigger>
                </TabsList>
                <TabsContent value="import">
                  <div className="space-y-4 pt-4">
                    <h3 className="text-lg font-medium">Tạo mới và ghi danh sinh viên vào các lớp đã chọn</h3>
                    <div className="space-y-2">
                      {selectedFile ? (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors flex flex-col items-center justify-center space-y-4">
                           <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Đã chọn file:</p>
                            <p className="text-sm font-medium mt-1">{selectedFile.name}</p>
                            <p className="text-xs text-muted-foreground mt-1">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</p>
                             <p className="text-sm font-medium mt-2 text-green-600">{studentsToCreate.length} sinh viên đã được phân tích.</p>
                          </div>
                          <Button variant="outline" size="sm" onClick={() => { setSelectedFile(null); setStudentsToCreate([]); }}>
                            Xóa file
                          </Button>
                        </div>
                      ) : (
                        <div className="relative border-2 border-dashed border-blue-400 rounded-lg p-8 hover:border-blue-500 transition-colors text-center flex flex-col items-center justify-center space-y-4">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5-5m0 0l5 5m-5-5v12" />
                          </svg>
                          <div className="text-center">
                            <p className="text-base font-medium text-blue-600">Chọn file Excel để tải lên</p>
                            <p className="text-sm text-muted-foreground mt-1">hoặc kéo thả file vào đây</p>
                          </div>
                          <input id="student-file-upload" type="file" accept=".xlsx,.xls,.csv" onChange={handleStudentCreateFileUpload} className="absolute inset-0 w-full h-full opacity-0 cursor-pointer" />
                        </div>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground mt-4">
                      File phải có các cột: <code>student_code</code>, <code>full_name</code>, <code>email</code>, và (tùy chọn) <code>date_of_birth</code>.{' '}
                      <Button variant="link" className="h-auto p-0 text-blue-600 underline" onClick={handleDownloadStudentTemplate} type="button">
                        Tải file mẫu (.xlsx)
                      </Button>
                    </p>
                  </div>
                </TabsContent>
                <TabsContent value="enroll">
                  <div className="space-y-4 pt-4">
                    <h3 className="text-lg font-medium">Ghi danh sinh viên đã có tài khoản vào các lớp đã chọn</h3>
                    <div className="flex items-center space-x-2">
                      <div className="form-field flex-grow">
                        <Input
                          type="text"
                          placeholder="Nhập Mã số sinh viên"
                          value={studentIdInput}
                          onChange={(e) => setStudentIdInput(e.target.value)}
                          onKeyDown={(e) => e.key === 'Enter' && handleAddStudentToEnrollList()}
                          className="form-input peer"
                        />
                        <Label className="form-label">Nhập Mã số sinh viên</Label>
                      </div>
                      <Button type="button" onClick={handleAddStudentToEnrollList}>Thêm</Button>
                    </div>
                    <div className="space-y-2">
                      <Label>Danh sách sinh viên sẽ được ghi danh:</Label>
                      {studentsToEnroll.length > 0 ? (
                        <ul className="border rounded-md p-2 space-y-1">
                          {studentsToEnroll.map((studentId) => (
                            <li key={studentId} className="flex items-center justify-between bg-gray-50 p-2 rounded">
                              <span>{studentId}</span>
                              <Button variant="ghost" size="sm" onClick={() => handleRemoveStudentFromEnrollList(studentId)}>Xóa</Button>
                            </li>
                          ))}
                        </ul>
                      ) : (
                        <p className="text-sm text-muted-foreground">Chưa có sinh viên nào trong danh sách.</p>
                      )}
                    </div>
                  </div>
                </TabsContent>
              </Tabs>
            )}
          </CardContent>
        </Card>

        <Button type='submit' disabled={selectedClasses.length === 0 || isLoading}>
          {isLoading ? 'Đang xử lý...' : (addType === 'student' ? 'Ghi danh/Tạo sinh viên' : 'Thêm')}
        </Button>
      </form>
    </div>
  )
}