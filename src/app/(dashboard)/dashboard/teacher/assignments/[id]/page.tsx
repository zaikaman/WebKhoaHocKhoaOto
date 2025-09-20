"use client"

import { useState, useEffect } from "react"
import { useParams, useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { getAssignmentById, getAssignmentQuestions, updateAssignment, updateAssignmentQuestion, deleteAssignmentQuestion, createAssignmentQuestion } from "@/lib/supabase"
import type { Assignment, AssignmentQuestion } from "@/lib/supabase"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription, DialogTrigger } from "@/components/ui/dialog"
import { PlusCircle, Trash2, Edit, Save, X, AlertTriangle } from "lucide-react"
import { sanitizeDescription } from "@/lib/utils"

type EditableQuestion = Partial<AssignmentQuestion> & { isEditing?: boolean };

export default function AssignmentDetailPage() {
  const router = useRouter()
  const params = useParams()
  const { toast } = useToast()
  const assignmentId = params.id as string

  const [isLoading, setIsLoading] = useState(true)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [questions, setQuestions] = useState<EditableQuestion[]>([])
  const [isEditingInfo, setIsEditingInfo] = useState(false)
  const [editedInfo, setEditedInfo] = useState<Partial<Assignment>>({})
  const [showAddQuestionDialog, setShowAddQuestionDialog] = useState(false)
  const [newQuestion, setNewQuestion] = useState<Partial<AssignmentQuestion>>({
    content: '',
    type: 'multiple_choice',
    points: 10,
    options: ['', '', '', ''],
    correct_answer: ''
  })
  const [questionToDelete, setQuestionToDelete] = useState<string | null>(null)

  useEffect(() => {
    loadData()
  }, [assignmentId])

  async function loadData() {
    setIsLoading(true)
    try {
      const [assignmentData, questionsData] = await Promise.all([
        getAssignmentById(assignmentId),
        getAssignmentQuestions(assignmentId)
      ])
      
      if (!assignmentData) {
        toast({ variant: "destructive", title: "Lỗi", description: "Không tìm thấy bài tập." })
        router.push("/dashboard/teacher/assignments")
        return
      }

      setAssignment(assignmentData)
      setEditedInfo({
        title: assignmentData.title,
        description: assignmentData.description,
        due_date: new Date(assignmentData.due_date).toISOString().slice(0, 16),
        total_points: assignmentData.total_points,
        max_attempts: (assignmentData as any).max_attempts || 1,
      })
      setQuestions(questionsData.map(q => ({ ...q, isEditing: false })))
    } catch (error: any) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải dữ liệu bài tập." })
      console.error("Failed to load assignment data:", error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleInfoEditToggle = () => {
    if (isEditingInfo) {
      // Reset changes if canceling
      setEditedInfo({
        title: assignment?.title,
        description: assignment?.description,
        due_date: new Date(assignment!.due_date).toISOString().slice(0, 16),
        total_points: assignment?.total_points,
        max_attempts: (assignment as any)?.max_attempts || 1,
      })
    }
    setIsEditingInfo(!isEditingInfo)
  }

  const handleInfoSave = async () => {
    if (!assignment) return
    try {
      const updatedData = {
        ...editedInfo,
        description: sanitizeDescription(editedInfo.description || ''),
        due_date: new Date(editedInfo.due_date!).toISOString(),
      }
      const updatedAssignment = await updateAssignment(assignment.id, updatedData)
      setAssignment(updatedAssignment)
      setIsEditingInfo(false)
      toast({ title: "Thành công", description: "Đã cập nhật thông tin bài tập." })
    } catch (error) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể cập nhật thông tin." })
    }
  }

  const handleQuestionEditToggle = (questionId: string) => {
    setQuestions(questions.map(q => 
      q.id === questionId ? { ...q, isEditing: !q.isEditing } : q
    ))
  }

  const handleQuestionChange = (questionId: string, field: keyof EditableQuestion, value: any) => {
    setQuestions(questions.map(q =>
      q.id === questionId ? { ...q, [field]: value } : q
    ))
  }
  
  const handleOptionChange = (questionId: string, optionIndex: number, value: string) => {
    setQuestions(questions.map(q => {
      if (q.id === questionId && q.options) {
        const newOptions = [...(q.options as string[])]
        newOptions[optionIndex] = value
        return { ...q, options: newOptions }
      }
      return q
    }))
  }

  const handleQuestionSave = async (questionId: string) => {
    const questionToSave = questions.find(q => q.id === questionId)
    if (!questionToSave) return

    try {
      const { isEditing, ...questionData } = questionToSave
      await updateAssignmentQuestion(questionId, questionData as AssignmentQuestion)
      handleQuestionEditToggle(questionId)
      toast({ title: "Thành công", description: "Đã cập nhật câu hỏi." })
    } catch (error) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể cập nhật câu hỏi." })
    }
  }

  const handleAddQuestion = async () => {
    if (!newQuestion.content || !newQuestion.points) {
      toast({ variant: "destructive", title: "Thiếu thông tin", description: "Vui lòng điền nội dung và điểm cho câu hỏi." })
      return
    }
    if (newQuestion.type === 'multiple_choice' && (!newQuestion.correct_answer || (newQuestion.options as string[]).some(opt => !opt))) {
       toast({ variant: "destructive", title: "Thiếu thông tin", description: "Vui lòng điền đầy đủ các phương án và đáp án đúng." })
       return
    }

    try {
      const createdQuestion = await createAssignmentQuestion({
        ...newQuestion,
        assignment_id: assignmentId
      } as Omit<AssignmentQuestion, 'id' | 'created_at' | 'updated_at'>)
      
      setQuestions([...questions, { ...createdQuestion, isEditing: false }])
      setShowAddQuestionDialog(false)
      setNewQuestion({ content: '', type: 'multiple_choice', points: 10, options: ['', '', '', ''], correct_answer: '' })
      toast({ title: "Thành công", description: "Đã thêm câu hỏi mới." })
    } catch (error) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể thêm câu hỏi." })
    }
  }

  const handleDeleteQuestion = async () => {
    if (!questionToDelete) return
    try {
      await deleteAssignmentQuestion(questionToDelete)
      setQuestions(questions.filter(q => q.id !== questionToDelete))
      setQuestionToDelete(null)
      toast({ title: "Thành công", description: "Đã xóa câu hỏi." })
    } catch (error) {
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể xóa câu hỏi." })
    }
  }

  if (isLoading) {
    return <div className="flex justify-center items-center h-screen">Đang tải...</div>
  }

  if (!assignment) {
    return <div className="text-center py-10">Không tìm thấy bài tập.</div>
  }

  return (
    <div className="container mx-auto py-10 space-y-8">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Chi tiết bài tập</h1>
        <Button onClick={() => router.push(`/dashboard/teacher/assignments/${assignmentId}/submissions`)}>
          Xem bài nộp
        </Button>
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Thông tin chung</CardTitle>
          <Button variant="ghost" size="icon" onClick={handleInfoEditToggle}>
            {isEditingInfo ? <X className="h-5 w-5" /> : <Edit className="h-5 w-5" />}
          </Button>
        </CardHeader>
        <CardContent className="space-y-4">
          {isEditingInfo ? (
            <>
              <div className="form-field">
                <Input
                  id="title"
                  value={editedInfo.title || ''}
                  onChange={(e) => setEditedInfo({ ...editedInfo, title: e.target.value })}
                  className="form-input peer"
                  placeholder="Tiêu đề"
                />
                <Label htmlFor="title" className="form-label">Tiêu đề</Label>
              </div>
              <div className="relative pt-5">
                <Textarea
                  id="description"
                  value={editedInfo.description || ''}
                  onChange={(e) => setEditedInfo({ ...editedInfo, description: e.target.value })}
                  className="form-textarea peer"
                  placeholder="Mô tả"
                />
                <Label htmlFor="description" className="form-textarea-label">Mô tả</Label>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="form-field">
                  <Input
                    id="due_date"
                    type="datetime-local"
                    value={editedInfo.due_date || ''}
                    onChange={(e) => setEditedInfo({ ...editedInfo, due_date: e.target.value })}
                    className="form-input peer"
                    placeholder="Hạn nộp"
                  />
                  <Label htmlFor="due_date" className="form-label">Hạn nộp</Label>
                </div>
                <div className="form-field">
                  <Input
                    id="total_points"
                    type="number"
                    value={editedInfo.total_points || ''}
                    onChange={(e) => setEditedInfo({ ...editedInfo, total_points: Number(e.target.value) })}
                    className="form-input peer"
                    placeholder="Tổng điểm"
                  />
                  <Label htmlFor="total_points" className="form-label">Tổng điểm</Label>
                </div>
                <div className="form-field">
                  <Input
                    id="max_attempts"
                    type="number"
                    value={(editedInfo as any).max_attempts || 1}
                    onChange={(e) => setEditedInfo({ ...editedInfo, max_attempts: Number(e.target.value) })}
                    className="form-input peer"
                    placeholder="Số lần làm bài"
                    min={1}
                  />
                  <Label htmlFor="max_attempts" className="form-label">Số lần làm bài</Label>
                </div>
              </div>
              <div className="flex justify-end gap-2">
                <Button variant="outline" onClick={handleInfoEditToggle}>Hủy</Button>
                <Button onClick={handleInfoSave}><Save className="mr-2 h-4 w-4" /> Lưu</Button>
              </div>
            </>
          ) : (
            <>
              <h2 className="text-2xl font-semibold">{assignment.title}</h2>
              <p className="text-muted-foreground" dangerouslySetInnerHTML={{ __html: assignment.description || 'Không có mô tả' }}></p>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div><p className="font-medium">Lớp:</p> {assignment.class?.name}</div>
                <div><p className="font-medium">Môn:</p> {assignment.class?.subject?.name}</div>
                <div><p className="font-medium">Hạn nộp:</p> {new Date(assignment.due_date).toLocaleString('vi-VN')}</div>
                <div><p className="font-medium">Tổng điểm:</p> {assignment.total_points}</div>
                <div><p className="font-medium">Số lần làm bài:</p> {(assignment as any).max_attempts || 1}</div>
                <div><p className="font-medium">Loại:</p> <span className="capitalize">{assignment.type === 'multiple_choice' ? 'Trắc nghiệm' : 'Tự luận'}</span></div>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      {assignment.type === 'multiple_choice' && (
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle>Câu hỏi</CardTitle>
            <Dialog open={showAddQuestionDialog} onOpenChange={setShowAddQuestionDialog}>
              <DialogTrigger asChild>
                <Button><PlusCircle className="mr-2 h-4 w-4" /> Thêm câu hỏi</Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-[600px]">
                <DialogHeader>
                  <DialogTitle>Thêm câu hỏi mới</DialogTitle>
                </DialogHeader>
                <div className="space-y-4 py-4">
                  {/* Add Question Form */}
                  <div className="relative pt-5">
                    <Textarea id="new-q-content" value={newQuestion.content} onChange={(e) => setNewQuestion({...newQuestion, content: e.target.value})} className="form-textarea peer" placeholder="Nội dung câu hỏi" />
                    <Label htmlFor="new-q-content" className="form-textarea-label">Nội dung câu hỏi</Label>
                  </div>
                  <div className="form-field">
                    <Input id="new-q-points" type="number" value={newQuestion.points} onChange={(e) => setNewQuestion({...newQuestion, points: Number(e.target.value)})} className="form-input peer" placeholder="Điểm" />
                    <Label htmlFor="new-q-points" className="form-label">Điểm</Label>
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="form-field">
                      <Input id="new-q-opt-a" value={(newQuestion.options as string[])[0]} onChange={(e) => { const opts = [...newQuestion.options as string[]]; opts[0] = e.target.value; setNewQuestion({...newQuestion, options: opts}) }} className="form-input peer" placeholder="Phương án A" />
                      <Label htmlFor="new-q-opt-a" className="form-label">Phương án A</Label>
                    </div>
                    <div className="form-field">
                      <Input id="new-q-opt-b" value={(newQuestion.options as string[])[1]} onChange={(e) => { const opts = [...newQuestion.options as string[]]; opts[1] = e.target.value; setNewQuestion({...newQuestion, options: opts}) }} className="form-input peer" placeholder="Phương án B" />
                      <Label htmlFor="new-q-opt-b" className="form-label">Phương án B</Label>
                    </div>
                    <div className="form-field">
                      <Input id="new-q-opt-c" value={(newQuestion.options as string[])[2]} onChange={(e) => { const opts = [...newQuestion.options as string[]]; opts[2] = e.target.value; setNewQuestion({...newQuestion, options: opts}) }} className="form-input peer" placeholder="Phương án C" />
                      <Label htmlFor="new-q-opt-c" className="form-label">Phương án C</Label>
                    </div>
                    <div className="form-field">
                      <Input id="new-q-opt-d" value={(newQuestion.options as string[])[3]} onChange={(e) => { const opts = [...newQuestion.options as string[]]; opts[3] = e.target.value; setNewQuestion({...newQuestion, options: opts}) }} className="form-input peer" placeholder="Phương án D" />
                      <Label htmlFor="new-q-opt-d" className="form-label">Phương án D</Label>
                    </div>
                  </div>
                  <div className="form-field">
                    <Input id="new-q-correct" value={newQuestion.correct_answer || ''} onChange={(e) => setNewQuestion({...newQuestion, correct_answer: e.target.value})} className="form-input peer" placeholder="Đáp án đúng" />
                    <Label htmlFor="new-q-correct" className="form-label">Đáp án đúng</Label>
                  </div>
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setShowAddQuestionDialog(false)}>Hủy</Button>
                  <Button onClick={handleAddQuestion}>Thêm</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
          </CardHeader>
          <CardContent className="space-y-4">
            {questions.length > 0 ? questions.map((q, index) => (
              <div key={q.id} className="border p-4 rounded-lg space-y-2">
                {q.isEditing ? (
                  <div className="space-y-4">
                    <div className="relative pt-5">
                      <Textarea value={q.content} onChange={(e) => handleQuestionChange(q.id!, 'content', e.target.value)} className="form-textarea peer" placeholder="Nội dung câu hỏi" />
                      <Label className="form-textarea-label">Câu hỏi {index + 1}</Label>
                    </div>
                    <div className="form-field">
                      <Input type="number" value={q.points} onChange={(e) => handleQuestionChange(q.id!, 'points', Number(e.target.value))} className="form-input peer" placeholder="Điểm" />
                      <Label className="form-label">Điểm</Label>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      {(q.options as string[]).map((opt, i) => (
                        <div className="form-field" key={i}>
                          <Input value={opt} onChange={(e) => handleOptionChange(q.id!, i, e.target.value)} className="form-input peer" placeholder={`Phương án ${String.fromCharCode(65 + i)}`} />
                          <Label className="form-label">Phương án {String.fromCharCode(65 + i)}</Label>
                        </div>
                      ))}
                    </div>
                    <div className="form-field">
                      <Input value={q.correct_answer || ''} onChange={(e) => handleQuestionChange(q.id!, 'correct_answer', e.target.value)} className="form-input peer" placeholder="Đáp án đúng" />
                      <Label className="form-label">Đáp án đúng</Label>
                    </div>
                    <div className="flex justify-end gap-2">
                      <Button variant="outline" size="sm" onClick={() => handleQuestionEditToggle(q.id!)}>Hủy</Button>
                      <Button size="sm" onClick={() => handleQuestionSave(q.id!)}><Save className="mr-2 h-4 w-4" /> Lưu</Button>
                    </div>
                  </div>
                ) : (
                  <div>
                    <div className="flex justify-between items-start">
                      <p className="font-semibold flex-1">Câu {index + 1}: {q.content} ({q.points} điểm)</p>
                      <div className="flex gap-2">
                        <Button variant="ghost" size="icon" onClick={() => handleQuestionEditToggle(q.id!)}><Edit className="h-4 w-4" /></Button>
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button variant="ghost" size="icon" className="text-destructive hover:text-destructive" onClick={() => setQuestionToDelete(q.id!)}><Trash2 className="h-4 w-4" /></Button>
                          </DialogTrigger>
                          <DialogContent>
                            <DialogHeader>
                              <DialogTitle>Xác nhận xóa</DialogTitle>
                              <DialogDescription>
                                <div className="flex items-center gap-4 py-4">
                                  <AlertTriangle className="h-10 w-10 text-destructive"/>
                                  <p>Bạn có chắc chắn muốn xóa câu hỏi này không? Hành động này không thể hoàn tác.</p>
                                </div>
                              </DialogDescription>
                            </DialogHeader>
                            <DialogFooter>
                              <Button variant="outline" onClick={() => setQuestionToDelete(null)}>Hủy</Button>
                              <Button variant="destructive" onClick={handleDeleteQuestion}>Xóa</Button>
                            </DialogFooter>
                          </DialogContent>
                        </Dialog>
                      </div>
                    </div>
                    <ul className="list-disc pl-8 mt-2 space-y-1">
                      {(q.options as string[]).map((opt, i) => (
                        <li key={i} className={opt === q.correct_answer ? 'font-bold text-green-600' : ''}>
                          {opt}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )) : (
              <p className="text-muted-foreground text-center py-4">Chưa có câu hỏi nào cho bài tập này.</p>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  )
}