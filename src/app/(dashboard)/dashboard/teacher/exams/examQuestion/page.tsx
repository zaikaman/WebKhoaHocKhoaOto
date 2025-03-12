"use client"

import { useState, useEffect, useRef } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import * as XLSX from 'xlsx'
import { createExam, updateExamQuestion, deleteExamQuestion, getExamDetails, getExamQuestions, ExamQuestion, createExamQuestion } from "@/lib/supabase"

export default function ExamQuestionPage() {
  const router = useRouter()
  const { toast } = useToast()
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [examId, setExamId] = useState<string | null>(null)
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [isQuestionDialogOpen, setIsQuestionDialogOpen] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState<ExamQuestion | null>(null)
  const [examType, setExamType] = useState<'multiple_choice' | 'essay'>('multiple_choice')

  useEffect(() => {
    const query = new URLSearchParams(window.location.search)
    const id = query.get('examId')
    console.log('ExamId from URL:', id)
    
    if (id) {
      setExamId(id)
      loadExamDetails(id)
    } else {
      console.log('Không tìm thấy examId trong URL')
      if (examId !== null) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Không tìm thấy mã bài kiểm tra"
        })
      }
    }
  }, [])

  useEffect(() => {
    let timeoutId: NodeJS.Timeout

    if (examId === null && window.location.search !== '') {
      console.log('Chuẩn bị chuyển hướng do không có examId')
      timeoutId = setTimeout(() => {
        router.push('/dashboard/teacher/exams/list')
      }, 2000)
    }

    return () => {
      if (timeoutId) {
        clearTimeout(timeoutId)
      }
    }
  }, [examId, router])

  const loadExamDetails = async (id: string) => {
    try {
      console.log('Loading exam details for ID:', id)
      const examDetails = await getExamDetails(id)
      console.log('Exam details:', examDetails)
      const examQuestions = await getExamQuestions(id)
      console.log('Exam questions:', examQuestions)
      
      // Kiểm tra và lọc câu hỏi hợp lệ
      const validQuestions = examQuestions?.filter(q => q && q.content) || []
      setQuestions(validQuestions)
    } catch (error) {
      console.error('Chi tiết lỗi khi tải thông tin bài kiểm tra:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải thông tin bài kiểm tra. Vui lòng thử lại sau."
      })
      router.push('/dashboard/teacher/exams/list')
    }
  }

  const handleAddQuestion = (type: 'multiple_choice' | 'essay') => {
    setCurrentQuestion(null)
    setExamType(type)
    setIsQuestionDialogOpen(true)
  }

  const handleQuestionSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    
    if (!examId) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không tìm thấy mã bài kiểm tra"
      })
      return
    }

    const formData = new FormData(event.currentTarget)

    const options = examType === 'multiple_choice' ? [
      formData.get('option1') as string,
      formData.get('option2') as string,
      formData.get('option3') as string,
      formData.get('option4') as string
    ] : null;

    const newQuestion: Omit<ExamQuestion, 'id'> = {
      exam_id: examId || '',
      type: examType,
      content: formData.get('content') as string,
      points: Number(formData.get('points')),
      options: options ? JSON.stringify(options) : null,
      correct_answer: examType === 'multiple_choice' ? 
        (formData.get(`option${Number(formData.get('correctOption'))}`) as string) :
        (formData.get('correctAnswer') as string),
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }

    console.log("New Question:", newQuestion);

    try {
      if (currentQuestion) {
        const updatedQuestion: ExamQuestion = {
          ...currentQuestion,
          ...newQuestion,
          updated_at: new Date().toISOString()
        }

        const { data, error } = await updateExamQuestion(updatedQuestion)
        if (error) throw error

        // Load lại toàn bộ danh sách câu hỏi
        const updatedQuestions = await getExamQuestions(examId)
        setQuestions(updatedQuestions)
      } else {
        const { data, error } = await createExamQuestion(newQuestion)
        if (error) throw error
        
        // Load lại toàn bộ danh sách câu hỏi
        const updatedQuestions = await getExamQuestions(examId)
        setQuestions(updatedQuestions)
      }
      toast({
        variant: "success",
        title: "Thành công",
        description: "Câu hỏi đã được lưu thành công"
      })
    } catch (error) {
      console.error('Chi tiết lỗi khi lưu câu hỏi:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể lưu câu hỏi"
      })
    } finally {
      setIsQuestionDialogOpen(false)
    }
  }

  const handleDeleteQuestion = async (questionId: string) => {
    try {
      const { error } = await deleteExamQuestion(questionId)
      if (error) throw error
      setQuestions(questions.filter(q => q.id !== questionId))
      toast({
        variant: "success",
        title: "Thành công",
        description: "Câu hỏi đã được xóa thành công"
      })
    } catch (error) {
      console.error('Lỗi khi xóa câu hỏi:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể xóa câu hỏi"
      })
    }
  }

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file) return

    if (!examId) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không tìm thấy mã bài kiểm tra"
      })
      return
    }

    // Kiểm tra định dạng file
    const fileExt = file.name.split('.').pop()?.toLowerCase()
    if (!['xlsx', 'xls'].includes(fileExt || '')) {
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Vui lòng chọn file Excel (.xlsx hoặc .xls)"
      })
      return
    }

    try {
      const data = await file.arrayBuffer()
      const workbook = XLSX.read(data)
      const worksheet = workbook.Sheets[workbook.SheetNames[0]]
      const jsonData = XLSX.utils.sheet_to_json(worksheet)

      console.log('Dữ liệu từ file Excel:', jsonData)

      if (!Array.isArray(jsonData) || jsonData.length === 0) {
        throw new Error('File không có dữ liệu')
      }

      // Validate dữ liệu từ Excel
      const validQuestions = jsonData.filter((row: any) => {
        console.log('Đang kiểm tra dòng:', row)
        
        const validationResults = {
          hasContent: Boolean(row.content),
          hasOptions: Boolean(row.option1 && row.option2 && row.option3 && row.option4),
          hasCorrectOption: Boolean(row.correct_option),
          validCorrectOption: Number(row.correct_option) >= 1 && Number(row.correct_option) <= 4,
          validPoints: !row.points || (Number(row.points) > 0)
        }

        console.log('Kết quả validation:', validationResults)

        const isValid = Object.values(validationResults).every(v => v)

        if (!isValid) {
          console.warn('Câu hỏi không hợp lệ. Chi tiết:', {
            row,
            validationResults
          })
        }
        return isValid
      })

      if (validQuestions.length === 0) {
        throw new Error('Không có câu hỏi hợp lệ trong file')
      }

      console.log('Số câu hỏi hợp lệ:', validQuestions.length)

      const newQuestions = validQuestions.map((row: any) => {
        const question = {
          exam_id: examId || '',
          type: 'multiple_choice',
          content: row.content.trim(),
          points: Number(row.points) || 1,
          options: JSON.stringify([
            row.option1.trim(),
            row.option2.trim(),
            row.option3.trim(),
            row.option4.trim()
          ]),
          correct_answer: row[`option${row.correct_option}`].trim(),
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }
        console.log('Đã chuyển đổi câu hỏi:', question)
        return question
      })

      // Thêm từng câu hỏi vào database
      let successCount = 0
      let errorCount = 0
      let newAddedQuestions: ExamQuestion[] = []

      for (const question of newQuestions) {
        try {
          console.log('Đang thêm câu hỏi:', question)
          const { data, error } = await createExamQuestion(question)
          
          if (error) {
            console.error('Lỗi khi thêm câu hỏi vào database:', {
              error,
              question
            })
            throw error
          }

          console.log('Đã thêm câu hỏi thành công:', data)
          newAddedQuestions.push(data)
          successCount++
        } catch (error) {
          console.error('Chi tiết lỗi khi thêm câu hỏi:', {
            error,
            question,
            errorMessage: error instanceof Error ? error.message : 'Unknown error'
          })
          errorCount++
        }
      }

      // Cập nhật state một lần duy nhất sau khi thêm tất cả câu hỏi
      if (newAddedQuestions.length > 0) {
        // Load lại toàn bộ danh sách câu hỏi từ database
        if (examId) {
          const updatedQuestions = await getExamQuestions(examId)
          setQuestions(updatedQuestions)
        }
      }

      // Hiển thị kết quả
      if (successCount > 0) {
        toast({
          title: "Thành công",
          description: `Đã thêm ${successCount} câu hỏi từ file${errorCount > 0 ? ` (${errorCount} lỗi)` : ''}`,
        })
      } else {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Không thể thêm câu hỏi. Vui lòng kiểm tra console để xem chi tiết lỗi."
        })
      }

      // Reset file input
      if (fileInputRef.current) {
        fileInputRef.current.value = ''
      }
    } catch (error) {
      console.error('Chi tiết lỗi khi xử lý file:', {
        error,
        errorMessage: error instanceof Error ? error.message : 'Unknown error',
        errorStack: error instanceof Error ? error.stack : undefined
      })
      
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: error instanceof Error 
          ? `Lỗi: ${error.message}` 
          : "Không thể import câu hỏi từ file. Vui lòng kiểm tra console để xem chi tiết."
      })
    }
  }

  const handleDownloadTemplate = () => {
    const template = [
      {
        content: 'Câu hỏi: 1 + 1 = ?',
        option1: 'A. 1',
        option2: 'B. 2',
        option3: 'C. 3',
        option4: 'D. 4',
        correct_option: '2',  // Chọn đáp án B (2)
        points: '1'
      },
      {
        content: 'Câu hỏi: 2 x 2 = ?',
        option1: 'A. 2',
        option2: 'B. 3',
        option3: 'C. 4',
        option4: 'D. 5',
        correct_option: '3',  // Chọn đáp án C (3)
        points: '1'
      }
    ]
    
    const ws = XLSX.utils.json_to_sheet(template)
    
    // Thêm validation và định dạng
    ws['!cols'] = [
      { wch: 40 }, // content - độ rộng cột nội dung
      { wch: 20 }, // option1
      { wch: 20 }, // option2
      { wch: 20 }, // option3
      { wch: 20 }, // option4
      { wch: 15 }, // correct_option - chọn số thứ tự đáp án (1,2,3,4)
      { wch: 10 }  // points - điểm số
    ]

    // Thêm ghi chú cho người dùng
    const notes = [
      {
        content: 'Ghi chú:',
        option1: '',
        option2: '',
        option3: '',
        option4: '',
        correct_option: '',
        points: ''
      },
      {
        content: '- Cột correct_option: nhập số thứ tự đáp án đúng (1,2,3,4)',
        option1: '',
        option2: '',
        option3: '',
        option4: '',
        correct_option: '',
        points: ''
      },
      {
        content: '- Cột points: nhập điểm số cho câu hỏi',
        option1: '',
        option2: '',
        option3: '',
        option4: '',
        correct_option: '',
        points: ''
      }
    ]

    // Thêm ghi chú vào cuối sheet
    XLSX.utils.sheet_add_json(ws, notes, { skipHeader: true, origin: -1 })

    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Template')
    XLSX.writeFile(wb, 'mau_cau_hoi_trac_nghiem.xlsx')
  }

  return (
    <div className="space-y-6 p-6 bg-gray-50 rounded-lg shadow-md">
      <div>
        <h2 className="text-3xl font-bold tracking-tight">Tạo câu hỏi cho bài kiểm tra</h2>
      </div>

      <Tabs value={examType} onValueChange={(value) => setExamType(value as 'multiple_choice' | 'essay')}>
        <TabsList>
          <TabsTrigger value="multiple_choice">Trắc nghiệm</TabsTrigger>
          <TabsTrigger value="essay">Tự luận</TabsTrigger>
        </TabsList>

        <div className="mt-4 flex items-center gap-4">
          <Button onClick={() => handleAddQuestion(examType)}>Thêm câu hỏi</Button>
          {examType === 'multiple_choice' && (
            <div className="flex items-center gap-2">
              <input
                type="file"
                ref={fileInputRef}
                onChange={handleFileUpload}
                accept=".xlsx,.xls,.csv"
                className="hidden"
              />
              <Button 
                variant="outline"
                onClick={() => fileInputRef.current?.click()}
              >
                Import từ Excel
              </Button>
              <Button 
                variant="ghost"
                onClick={handleDownloadTemplate}
              >
                Tải mẫu Excel
              </Button>
            </div>
          )}
        </div>

        <div className="mt-4 space-y-4">
          {questions?.filter(q => q && q.content).map((question, index) => (
            <div key={question?.id || index} className="rounded-lg border p-4 bg-white shadow-sm relative">
              <div className="absolute top-2 right-2 flex space-x-2">
                <Button 
                  onClick={() => { 
                    setCurrentQuestion(question); 
                    setExamType(question.type);
                    setIsQuestionDialogOpen(true); 
                  }} 
                >
                  Chỉnh sửa
                </Button>
                <Button 
                  onClick={() => handleDeleteQuestion(question.id)}
                  variant="outline"
                >
                  &times;
                </Button>
              </div>
              <div className="flex-1">
                <h3 className="font-medium">Câu {index + 1}: {question?.content}</h3>
                <div className="mt-2 text-sm text-muted-foreground">Điểm: {question?.points}</div>
                {question?.type === 'multiple_choice' && question?.options && (
                  <div className="mt-2">
                    <h4 className="font-medium">Các đáp án:</h4>
                    <ul className="list-disc pl-5">
                      {JSON.parse(question.options).map((option: string, idx: number) => (
                        <li key={idx}>{option}</li>
                      ))}
                    </ul>
                    <h4 className="font-medium">Đáp án đúng:</h4>
                    <p>{question?.correct_answer}</p>
                  </div>
                )}
                {question?.type === 'essay' && question?.correct_answer && (
                  <div className="mt-2">
                    <h4 className="font-medium">Đáp án đúng:</h4>
                    <p>{question?.correct_answer}</p>
                  </div>
                )}
              </div>
            </div>
          ))}

          <Dialog open={isQuestionDialogOpen} onOpenChange={setIsQuestionDialogOpen}>
            <DialogContent className="max-w-[500px] p-4">
              <DialogHeader className="pb-4">
                <DialogTitle className="text-xl font-semibold">
                  {currentQuestion ? "Cập nhật câu hỏi" : "Thêm câu hỏi"}
                </DialogTitle>
              </DialogHeader>
              <form onSubmit={handleQuestionSubmit} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="content" className="text-sm font-medium flex items-center gap-2">
                    Nội dung câu hỏi <span className="text-red-500">*</span>
                  </Label>
                  <div className="w-full h-[120px]">
                    <Textarea 
                      id="content" 
                      name="content" 
                      defaultValue={currentQuestion?.content || ''} 
                      className="w-full h-full resize-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Nhập nội dung câu hỏi..."
                      required 
                      rows={4}
                    />
                  </div>
                </div>

                {examType === 'multiple_choice' && (
                  <div className="space-y-4 border rounded-lg p-4 bg-gray-50">
                    <div className="grid grid-cols-2 gap-4">
                      {[1, 2, 3, 4].map((num) => (
                        <div key={num} className="space-y-2">
                          <Label className="text-sm font-medium flex items-center gap-2">
                            Đáp án {num} <span className="text-red-500">*</span>
                          </Label>
                          <Input
                            name={`option${num}`}
                            className="w-full focus:ring-2 focus:ring-blue-500"
                            placeholder={`Nhập đáp án ${num}...`}
                            defaultValue={currentQuestion?.options?.[num - 1] || ''}
                            required
                          />
                        </div>
                      ))}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="correctOption" className="text-sm font-medium flex items-center gap-2">
                        Đáp án đúng <span className="text-red-500">*</span>
                      </Label>
                      <select
                        id="correctOption"
                        name="correctOption"
                        className="w-full px-3 py-2 border rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        defaultValue={currentQuestion?.options?.indexOf(currentQuestion.correct_answer || '') || 0}
                        required
                      >
                        {[1, 2, 3, 4].map((num) => (
                          <option key={num} value={num}>Đáp án {num}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                )}

                {examType === 'essay' && (
                  <div className="space-y-2 border rounded-lg p-4 bg-gray-50">
                    <Label htmlFor="correctAnswer" className="text-sm font-medium flex items-center gap-2">
                      Đáp án mẫu <span className="text-red-500">*</span>
                    </Label>
                    <div className="w-full h-[120px]">
                      <Textarea
                        id="correctAnswer"
                        name="correctAnswer"
                        className="w-full h-full resize-none focus:ring-2 focus:ring-blue-500"
                        defaultValue={currentQuestion?.correct_answer || ''}
                        placeholder="Nhập đáp án mẫu cho câu hỏi tự luận..."
                        required
                        rows={4}
                      />
                    </div>
                  </div>
                )}

                <div className="space-y-2">
                  <Label htmlFor="points" className="text-sm font-medium flex items-center gap-2">
                    Điểm <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    type="number"
                    id="points"
                    name="points"
                    min="0"
                    step="0.5"
                    className="w-full focus:ring-2 focus:ring-blue-500"
                    defaultValue={currentQuestion?.points || 1}
                    required
                  />
                </div>

                <DialogFooter className="flex justify-end gap-2 pt-4">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => setIsQuestionDialogOpen(false)}
                  >
                    Hủy
                  </Button>
                  <Button type="submit" className="bg-blue-600 hover:bg-blue-700">
                    {currentQuestion ? "Cập nhật" : "Thêm"}
                  </Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        </div>
      </Tabs>

      <div className="flex justify-end space-x-4">
        <Button variant="outline" onClick={() => router.back()}>Hủy</Button>
        <Button onClick={() => router.push('/dashboard/teacher/exams/list')}>Hoàn tất</Button>
      </div>
    </div>
  )
}
