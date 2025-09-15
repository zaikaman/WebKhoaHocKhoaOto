'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import { useToast } from '@/components/ui/use-toast'
import { sanitizeDescription } from '@/lib/utils'
import { getCurrentUser, getTeacherClasses, createAssignmentForClasses, createExamForClasses, createExamQuestion, createAssignmentQuestions } from '@/lib/supabase'
import type { Class, ExamQuestion, AssignmentQuestion } from '@/lib/supabase'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import * as XLSX from 'xlsx'

export default function QuickAddPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [classes, setClasses] = useState<Class[]>([])
  const [selectedClasses, setSelectedClasses] = useState<string[]>([])
  const [addType, setAddType] = useState<'assignment' | 'exam'>('assignment')
  const [questions, setQuestions] = useState<Partial<ExamQuestion | AssignmentQuestion>[]>([])
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [newQuestion, setNewQuestion] = useState<Partial<ExamQuestion | AssignmentQuestion>>({ type: 'multiple_choice', options: ['', '', '', ''] })

  useEffect(() => {
    loadData()
  }, [])

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

    setSelectedFile(file)

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data)
      const worksheet = workbook.Sheets[workbook.SheetNames[0]]
      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      const newQuestions = jsonData.map((row: any) => ({
        content: row['Câu hỏi'] || row['Question'] || '',
        options: [
          row['Phương án A'] || row['Option A'] || '',
          row['Phương án B'] || row['Option B'] || '',
          row['Phương án C'] || row['Option C'] || '',
          row['Phương án D'] || row['Option D'] || ''
        ].filter(option => option.trim() !== ''),
        correct_answer: row['Đáp án đúng'] || row['Correct Answer'] || '',
        points: Number(row['Điểm'] || row['Points'] || 10),
        type: 'multiple_choice' as 'multiple_choice' | 'essay'
      })).filter(q => q.content && q.correct_answer)

      setQuestions(newQuestions)
      
      toast({
        title: "Thành công",
        description: `Đã tải ${newQuestions.length} câu hỏi từ file Excel`
      })
    } catch (error) {
      console.error('Lỗi khi đọc file Excel:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể đọc file Excel. Vui lòng kiểm tra định dạng file."
      })
    }
  }

  const handleDownloadTemplate = () => {
    const templateData = [
      {
        'Câu hỏi': 'Câu hỏi mẫu 1?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'A',
        'Điểm': 10
      },
      {
        'Câu hỏi': 'Câu hỏi mẫu 2?',
        'Phương án A': 'Đáp án A',
        'Phương án B': 'Đáp án B',
        'Phương án C': 'Đáp án C',
        'Phương án D': 'Đáp án D',
        'Đáp án đúng': 'B',
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

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setIsLoading(true)

    try {
      const formData = new FormData(event.currentTarget)
      if (addType === 'assignment') {
        const assignmentData = {
          title: formData.get('title') as string,
          description: sanitizeDescription(formData.get('description') as string),
          due_date: formData.get('due_date') as string,
          total_points: parseInt(formData.get('total_points') as string, 10),
          file_url: null
        }
        const newAssignments = await createAssignmentForClasses(assignmentData, selectedClasses)
        if (newAssignments) {
          for (const assignment of newAssignments) {
            for (const q of questions) {
              await createAssignmentQuestions([{ ...q, assignment_id: assignment.id } as Omit<AssignmentQuestion, 'id' | 'created_at' | 'updated_at'>])
            }
          }
        }
        toast({
          title: 'Thành công',
          description: 'Đã tạo bài tập cho các lớp đã chọn.',
        })
      } else {
        const examData = {
          title: formData.get('title') as string,
          description: sanitizeDescription(formData.get('description') as string),
          type: formData.get('type') as 'quiz' | 'midterm' | 'final',
          duration: parseInt(formData.get('duration') as string, 10),
          total_points: parseInt(formData.get('total_points') as string, 10),
          start_time: formData.get('start_time') as string,
          end_time: formData.get('end_time') as string,
          status: 'upcoming' as const,
        }
        const newExams = await createExamForClasses(examData, selectedClasses)
        if (newExams) {
          for (const exam of newExams) {
            for (const q of questions) {
              await createExamQuestion({ ...q, exam_id: exam.id } as Omit<ExamQuestion, 'id' | 'created_at' | 'updated_at'>)
            }
          }
        }
        toast({
          title: 'Thành công',
          description: 'Đã tạo bài kiểm tra cho các lớp đã chọn.',
        })
      }
      router.push('/dashboard/teacher/classes')
    } catch (error: any) {
      toast({
        variant: 'destructive',
        title: 'Lỗi',
        description: error.message || 'Không thể tạo. Vui lòng thử lại sau.',
      })
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-gray-900"></div>
      </div>
    )
  }

  return (
    <div className='space-y-8 container mx-auto py-10'>
      <div className="flex items-center justify-between">
          <div>
            <h1 className='text-2xl font-bold'>Thêm nhanh bài tập/bài kiểm tra</h1>
            <p className="text-muted-foreground">
              Thêm bài tập hoặc bài kiểm tra cho nhiều lớp học cùng một lúc.
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
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>3. Nhập thông tin</CardTitle>
          </CardHeader>
          <CardContent>
            {addType === 'assignment' ? (
              <div className='space-y-4'>
                <h3 className='text-lg font-medium'>Thông tin bài tập</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor='title'>Tiêu đề</Label>
                    <Input id='title' name='title' required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor='total_points'>Tổng điểm</Label>
                    <Input id='total_points' name='total_points' type='number' required />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor='description'>Mô tả</Label>
                  <Textarea id='description' name='description' />
                </div>
                <div className="space-y-2">
                  <Label htmlFor='due_date'>Hạn nộp</Label>
                  <Input id='due_date' name='due_date' type='datetime-local' required />
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
                        <div className="space-y-2">
                          <Label htmlFor="new-question-points">Điểm</Label>
                          <Input id="new-question-points" type="number" value={newQuestion.points || ''} onChange={(e) => setNewQuestion({ ...newQuestion, points: parseInt(e.target.value) })} />
                        </div>
                      </div>
                      <div className="space-y-2">
                        <Label htmlFor="new-question-content">Nội dung câu hỏi</Label>
                        <Textarea id="new-question-content" value={newQuestion.content || ''} onChange={(e) => setNewQuestion({ ...newQuestion, content: e.target.value })} />
                      </div>
                      {newQuestion.type === 'multiple_choice' && (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div className="space-y-2">
                            <Label>Phương án A</Label>
                            <Input value={newQuestion.options?.[0] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[0] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án B</Label>
                            <Input value={newQuestion.options?.[1] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[1] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án C</Label>
                            <Input value={newQuestion.options?.[2] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[2] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án D</Label>
                            <Input value={newQuestion.options?.[3] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[3] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2 md:col-span-2">
                            <Label>Đáp án đúng</Label>
                            <Input value={newQuestion.correct_answer || ''} onChange={(e) => setNewQuestion({ ...newQuestion, correct_answer: e.target.value })} />
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
                    <p className="text-sm text-muted-foreground">
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
            ) : (
              <div className='space-y-4'>
                <h3 className='text-lg font-medium'>Thông tin bài kiểm tra</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor='title'>Tiêu đề</Label>
                    <Input id='title' name='title' required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor='type'>Loại</Label>
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
                  <div className="space-y-2">
                    <Label htmlFor='duration'>Thời gian làm bài (phút)</Label>
                    <Input id='duration' name='duration' type='number' required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor='total_points'>Tổng điểm</Label>
                    <Input id='total_points' name='total_points' type='number' required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor='start_time'>Thời gian bắt đầu</Label>
                    <Input id='start_time' name='start_time' type='datetime-local' required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor='end_time'>Thời gian kết thúc</Label>
                    <Input id='end_time' name='end_time' type='datetime-local' required />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor='description'>Mô tả</Label>
                  <Textarea id='description' name='description' />
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
                        <div className="space-y-2">
                          <Label htmlFor="new-question-points">Điểm</Label>
                          <Input id="new-question-points" type="number" value={newQuestion.points || ''} onChange={(e) => setNewQuestion({ ...newQuestion, points: parseInt(e.target.value) })} />
                        </div>
                      </div>
                      <div className="space-y-2">
                        <Label htmlFor="new-question-content">Nội dung câu hỏi</Label>
                        <Textarea id="new-question-content" value={newQuestion.content || ''} onChange={(e) => setNewQuestion({ ...newQuestion, content: e.target.value })} />
                      </div>
                      {newQuestion.type === 'multiple_choice' && (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          <div className="space-y-2">
                            <Label>Phương án A</Label>
                            <Input value={newQuestion.options?.[0] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[0] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án B</Label>
                            <Input value={newQuestion.options?.[1] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[1] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án C</Label>
                            <Input value={newQuestion.options?.[2] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[2] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2">
                            <Label>Phương án D</Label>
                            <Input value={newQuestion.options?.[3] || ''} onChange={(e) => {
                              const newOptions = [...newQuestion.options!]
                              newOptions[3] = e.target.value
                              setNewQuestion({ ...newQuestion, options: newOptions })
                            }} />
                          </div>
                          <div className="space-y-2 md:col-span-2">
                            <Label>Đáp án đúng</Label>
                            <Input value={newQuestion.correct_answer || ''} onChange={(e) => setNewQuestion({ ...newQuestion, correct_answer: e.target.value })} />
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
                    <p className="text-sm text-muted-foreground">
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
          </CardContent>
        </Card>

        <Button type='submit' disabled={selectedClasses.length === 0 || isLoading}>
          {isLoading ? 'Đang thêm...' : 'Thêm'}
        </Button>
      </form>
    </div>
  )
}
