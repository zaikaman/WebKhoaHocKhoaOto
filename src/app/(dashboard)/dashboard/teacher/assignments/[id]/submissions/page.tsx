"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { getCurrentUser, supabase } from "@/lib/supabase"

interface AssignmentSubmission {
  id: string
  student: {
    id: string
    full_name: string
  }
  content: string | null
  file_url: string | null
  answers: Record<string, string> | null
  score: number | null
  submitted_at: string
  graded_at: string | null
  feedback: string | null
}

interface Question {
  id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | null
  correct_answer: string | null
}

interface Assignment {
  id: string
  title: string
  type: 'multiple_choice' | 'essay'
  total_points: number
  questions: Question[] | null
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

export default function AssignmentSubmissionsPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submissions, setSubmissions] = useState<AssignmentSubmission[]>([])
  const [selectedSubmission, setSelectedSubmission] = useState<AssignmentSubmission | null>(null)
  const [showGradeDialog, setShowGradeDialog] = useState(false)
  const [gradeData, setGradeData] = useState({
    score: "",
    feedback: ""
  })

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

      // Lấy thông tin bài tập
      const { data: assignmentData, error: assignmentError } = await supabase
        .from('assignments')
        .select(`
          *,
          questions:assignment_questions(*),
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .eq('id', params.id)
        .single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      // Lấy danh sách bài nộp
      const { data: submissionsData, error: submissionsError } = await supabase
        .from('assignment_submissions')
        .select(`
          *,
          student:profiles(
            id,
            full_name
          )
        `)
        .eq('assignment_id', params.id)
        .order('submitted_at', { ascending: false })

      if (submissionsError) throw submissionsError
      setSubmissions(submissionsData)

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu bài tập"
      })
      router.push('/dashboard/teacher/assignments')
    } finally {
      setIsLoading(false)
    }
  }

  async function handleGradeSubmit() {
    if (!selectedSubmission) return

    try {
      const score = parseFloat(gradeData.score)
      if (isNaN(score) || score < 0 || score > assignment?.total_points!) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Điểm số không hợp lệ"
        })
        return
      }

      const { error } = await supabase
        .from('assignment_submissions')
        .update({
          score,
          feedback: gradeData.feedback,
          graded_at: new Date().toISOString()
        })
        .eq('id', selectedSubmission.id)

      if (error) throw error

      toast({
        title: "Thành công",
        description: "Đã chấm điểm bài làm"
      })

      setShowGradeDialog(false)
      loadData()

    } catch (error) {
      console.error('Lỗi khi chấm điểm:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể chấm điểm bài làm"
      })
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!assignment) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy bài tập</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push('/dashboard/teacher/assignments')}
          >
            Quay lại
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="container py-8 space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">{assignment.title}</h2>
          <p className="text-muted-foreground">
            {assignment.class.subject.name} - {assignment.class.name}
          </p>
        </div>
        <Button onClick={() => router.push('/dashboard/teacher/assignments')}>
          Quay lại
        </Button>
      </div>

      <div className="rounded-lg border">
        <table className="w-full">
          <thead>
            <tr className="border-b">
              <th className="text-left py-3 px-4">Sinh viên</th>
              <th className="text-left py-3 px-4">Thời gian nộp</th>
              <th className="text-left py-3 px-4">Trạng thái</th>
              <th className="text-left py-3 px-4">Điểm</th>
              <th className="text-left py-3 px-4"></th>
            </tr>
          </thead>
          <tbody>
            {submissions.map((submission) => (
              <tr key={submission.id} className="border-b last:border-0">
                <td className="py-3 px-4">
                  <div className="font-medium">{submission.student.full_name}</div>
                </td>
                <td className="py-3 px-4">
                  {new Date(submission.submitted_at).toLocaleString('vi-VN')}
                </td>
                <td className="py-3 px-4">
                  <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${
                    submission.graded_at
                      ? 'bg-green-100 text-green-800'
                      : 'bg-yellow-100 text-yellow-800'
                  }`}>
                    {submission.graded_at ? 'Đã chấm' : 'Chưa chấm'}
                  </span>
                </td>
                <td className="py-3 px-4">
                  {submission.score !== null ? `${submission.score}/${assignment.total_points}` : 'Chưa có điểm'}
                </td>
                <td className="py-3 px-4">
                  <div className="flex items-center gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        setSelectedSubmission(submission)
                        setGradeData({
                          score: submission.score?.toString() || "",
                          feedback: submission.feedback || ""
                        })
                        setShowGradeDialog(true)
                      }}
                    >
                      {submission.graded_at ? 'Sửa điểm' : 'Chấm điểm'}
                    </Button>
                    {assignment.type === 'essay' && (
                      <Button
                        variant="secondary"
                        size="sm"
                        onClick={() => router.push(`/dashboard/teacher/assignments/${assignment.id}/submissions/${submission.id}`)}
                      >
                        Xem chi tiết
                      </Button>
                    )}
                  </div>
                </td>
              </tr>
            ))}

            {submissions.length === 0 && (
              <tr>
                <td colSpan={5} className="py-8 text-center text-muted-foreground">
                  Chưa có bài nộp nào
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      <Dialog open={showGradeDialog} onOpenChange={setShowGradeDialog}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Chấm điểm bài làm</DialogTitle>
          </DialogHeader>
          <div className="space-y-6 py-4">
            {assignment.type === 'multiple_choice' ? (
              <>
                {assignment.questions?.map((question, index) => (
                  <Card key={question.id}>
                    <CardHeader>
                      <CardTitle className="text-base">Câu {index + 1}</CardTitle>
                      <CardDescription>Điểm: {question.points}</CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div>
                          <Label htmlFor={`question-${question.id}`}>Câu hỏi:</Label>
                          <div className="mt-1 text-sm">{question.content}</div>
                        </div>
                        <div>
                          <Label htmlFor={`answer-${question.id}`}>Câu trả lời của sinh viên:</Label>
                          <div className="mt-1 text-sm">
                            {selectedSubmission?.answers?.[question.id] || 'Không có câu trả lời'}
                          </div>
                        </div>
                        <div>
                          <Label htmlFor={`correct-${question.id}`}>Đáp án đúng:</Label>
                          <div className="mt-1 text-sm">{question.correct_answer}</div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </>
            ) : (
              <div className="grid grid-cols-2 gap-6">
                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle>Bài làm của sinh viên</CardTitle>
                      <CardDescription>
                        Nộp lúc: {selectedSubmission && new Date(selectedSubmission.submitted_at).toLocaleString('vi-VN')}
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        {selectedSubmission?.content && (
                          <div>
                            <Label htmlFor="submission-content">Nội dung bài làm:</Label>
                            <div className="mt-2 p-4 rounded-lg bg-muted/50 border text-sm whitespace-pre-wrap">
                              {selectedSubmission.content}
                            </div>
                          </div>
                        )}
                        
                        {selectedSubmission?.file_url && (
                          <div>
                            <Label htmlFor="submission-file">File đính kèm:</Label>
                            <div className="mt-2">
                              <a
                                href={selectedSubmission.file_url}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="inline-flex items-center gap-2 text-sm text-primary hover:underline"
                              >
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                  <polyline points="7 10 12 15 17 10" />
                                  <line x1="12" y1="15" x2="12" y2="3" />
                                </svg>
                                Tải xuống file bài làm
                              </a>
                            </div>
                          </div>
                        )}
                      </div>
                    </CardContent>
                  </Card>
                </div>

                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle>Chấm điểm</CardTitle>
                      <CardDescription>
                        Nhập điểm và nhận xét cho bài làm
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div className="space-y-2">
                          <Label htmlFor="score">Điểm số</Label>
                          <div className="relative">
                            <Input
                              id="score"
                              type="number"
                              min="0"
                              max={assignment.total_points}
                              value={gradeData.score}
                              onChange={(e) => setGradeData(prev => ({ ...prev, score: e.target.value }))}
                              placeholder={`Nhập điểm`}
                              className="pr-16"
                            />
                            <div className="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-sm text-muted-foreground">
                              / {assignment.total_points}
                            </div>
                          </div>
                        </div>

                        <div className="space-y-2">
                          <Label htmlFor="feedback">Nhận xét</Label>
                          <Textarea
                            id="feedback"
                            value={gradeData.feedback}
                            onChange={(e) => setGradeData(prev => ({ ...prev, feedback: e.target.value }))}
                            placeholder="Nhập nhận xét chi tiết về bài làm..."
                            className="min-h-[200px]"
                          />
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <div className="flex justify-end gap-4">
                    <Button variant="outline" onClick={() => setShowGradeDialog(false)}>
                      Hủy
                    </Button>
                    <Button onClick={handleGradeSubmit}>
                      Lưu điểm
                    </Button>
                  </div>
                </div>
              </div>
            )}

            {assignment.type === 'multiple_choice' && (
              <div className="space-y-6">
                <Card>
                  <CardHeader>
                    <CardTitle>Chấm điểm</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-4">
                      <div className="space-y-2">
                        <Label htmlFor="score">Điểm số</Label>
                        <div className="relative">
                          <Input
                            id="score"
                            type="number"
                            min="0"
                            max={assignment.total_points}
                            value={gradeData.score}
                            onChange={(e) => setGradeData(prev => ({ ...prev, score: e.target.value }))}
                            placeholder={`Nhập điểm`}
                            className="pr-16"
                          />
                          <div className="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-sm text-muted-foreground">
                            / {assignment.total_points}
                          </div>
                        </div>
                      </div>

                      <div className="space-y-2">
                        <Label htmlFor="feedback">Nhận xét</Label>
                        <Textarea
                          id="feedback"
                          value={gradeData.feedback}
                          onChange={(e) => setGradeData(prev => ({ ...prev, feedback: e.target.value }))}
                          placeholder="Nhập nhận xét cho bài làm..."
                          rows={4}
                        />
                      </div>
                    </div>
                  </CardContent>
                </Card>

                <div className="flex justify-end gap-4">
                  <Button variant="outline" onClick={() => setShowGradeDialog(false)}>
                    Hủy
                  </Button>
                  <Button onClick={handleGradeSubmit}>
                    Lưu điểm
                  </Button>
                </div>
              </div>
            )}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
} 