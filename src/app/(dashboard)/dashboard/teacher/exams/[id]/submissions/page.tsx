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
import { ArrowUpDown, ArrowUp, ArrowDown } from "lucide-react"
import { getCurrentUser, supabase } from "@/lib/supabase"
import KahootLeaderboard from "@/app/(dashboard)/dashboard/components/KahootLeaderboard"

interface ExamSubmission {
  id: string
  student: {
    id: string
    full_name: string
  }
  answers: Record<string, string>
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

interface Exam {
  id: string
  title: string
  total_points: number
  class: {
    name: string
    subject: {
      name: string
    }
  }
}

export default function ExamSubmissionsPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [exam, setExam] = useState<Exam | null>(null)
  const [questions, setQuestions] = useState<Question[]>([])
  const [submissions, setSubmissions] = useState<ExamSubmission[]>([])
  const [selectedSubmission, setSelectedSubmission] = useState<ExamSubmission | null>(null)
  const [showGradeDialog, setShowGradeDialog] = useState(false)
  const [gradeData, setGradeData] = useState({
    score: "",
    feedback: ""
  })
  const [viewMode, setViewMode] = useState<'leaderboard' | 'table'>('leaderboard')
  const [sortDirection, setSortDirection] = useState<'desc' | 'asc' | 'none'>('none')

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

      // Lấy thông tin bài kiểm tra
      const { data: examData, error: examError } = await supabase
        .from('exams')
        .select(`
          *,
          class:classes(
            name,
            subject:subjects(name)
          )
        `)
        .eq('id', params.id)
        .single()

      if (examError) throw examError
      setExam(examData)

      // Lấy danh sách câu hỏi
      const { data: questionsData, error: questionsError } = await supabase
        .from('exam_questions')
        .select('*')
        .eq('exam_id', params.id)
        .order('created_at', { ascending: true })

      if (questionsError) throw questionsError
      setQuestions(questionsData)

      // Lấy danh sách bài nộp
      const { data: submissionsData, error: submissionsError } = await supabase
        .from('exam_submissions')
        .select(`
          *,
          student:profiles(
            id,
            full_name
          )
        `)
        .eq('exam_id', params.id)
        .order('submitted_at', { ascending: false })

      if (submissionsError) throw submissionsError
      setSubmissions(submissionsData)

    } catch (error) {
      console.error('Lỗi khi tải dữ liệu:', error)
      toast({
        variant: "destructive",
        title: "Lỗi",
        description: "Không thể tải dữ liệu bài kiểm tra"
      })
      router.push('/dashboard/teacher/exams/list')
    } finally {
      setIsLoading(false)
    }
  }

  async function handleGradeSubmit() {
    if (!selectedSubmission) return

    try {
      const score = parseFloat(gradeData.score)
      if (isNaN(score) || score < 0 || score > exam?.total_points!) {
        toast({
          variant: "destructive",
          title: "Lỗi",
          description: "Điểm số không hợp lệ"
        })
        return
      }

      const { error } = await supabase
        .from('exam_submissions')
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
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    )
  }

  if (!exam) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-xl font-semibold">Không tìm thấy bài kiểm tra</h2>
          <Button 
            className="mt-4" 
            onClick={() => router.push('/dashboard/teacher/exams/list')}
          >
            Quay lại
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="container py-8 space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight break-words">{exam.title}</h2>
          <p className="text-muted-foreground break-words">
            {exam.class.subject.name} - {exam.class.name}
          </p>
        </div>
        <div className="flex gap-2 flex-col sm:flex-row">
          <div className="flex bg-gray-100 rounded-lg p-1">
            <Button
              variant={viewMode === 'leaderboard' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setViewMode('leaderboard')}
              className="text-sm"
            >
              🏆 Bảng xếp hạng
            </Button>
            <Button
              variant={viewMode === 'table' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setViewMode('table')}
              className="text-sm"
            >
              📊 Bảng chi tiết
            </Button>
          </div>
          <Button className="w-full sm:w-auto" onClick={() => router.push('/dashboard/teacher/exams/list')}>
            Quay lại
          </Button>
        </div>
      </div>

      {viewMode === 'leaderboard' ? (
        <KahootLeaderboard
          submissions={submissions.map(s => ({
            ...s,
            total_points: exam.total_points
          }))}
          title={`${exam.class.subject.name} - ${exam.class.name}`}
          onViewDetails={(leaderboardEntry) => {
            // Find the original submission from submissions array
            const originalSubmission = submissions.find(s => s.id === leaderboardEntry.id)
            if (originalSubmission) {
              setSelectedSubmission(originalSubmission)
              setGradeData({
                score: originalSubmission.score?.toString() || "",
                feedback: originalSubmission.feedback || ""
              })
              setShowGradeDialog(true)
            }
          }}
        />
      ) : (
        <div className="rounded-lg border overflow-x-auto">
          {sortDirection !== 'none' && (
            <div className="px-4 py-2 bg-blue-50 border-b text-sm text-blue-700 flex items-center gap-2">
              {sortDirection === 'desc' ? '↓' : '↑'} Đang sắp xếp theo điểm {sortDirection === 'desc' ? 'từ cao đến thấp' : 'từ thấp đến cao'}
            </div>
          )}
          <table className="w-full min-w-[750px]">
            <thead>
              <tr className="border-b">
              <th className="text-left py-3 px-4 break-words whitespace-nowrap w-[250px]">Sinh viên</th>


                <th className="text-left py-3 px-4 whitespace-nowrap">Thời gian nộp</th>
                <th className="text-left py-3 px-4 whitespace-nowrap">Trạng thái</th>
                <th className="text-left py-3 px-4 whitespace-nowrap">
                  <div className="flex items-center gap-2">
                    <span>Điểm</span>
                    <Button
                      variant="ghost"
                      size="sm"
                      className="h-6 w-6 p-0 hover:bg-gray-100"
                      title={sortDirection === 'none' ? 'Sắp xếp theo điểm' : sortDirection === 'desc' ? 'Điểm cao đến thấp - Click để đảo ngược' : 'Điểm thấp đến cao - Click để reset'}
                      onClick={() => {
                        if (sortDirection === 'none') {
                          setSortDirection('desc')
                        } else if (sortDirection === 'desc') {
                          setSortDirection('asc')
                        } else {
                          setSortDirection('none')
                        }
                      }}
                    >
                      {sortDirection === 'none' && <ArrowUpDown className="h-4 w-4 text-gray-400" />}
                      {sortDirection === 'desc' && <ArrowDown className="h-4 w-4 text-blue-600" />}
                      {sortDirection === 'asc' && <ArrowUp className="h-4 w-4 text-blue-600" />}
                    </Button>
                  </div>
                </th>
                <th className="text-left py-3 px-4"></th>
              </tr>
            </thead>
            <tbody>
              {(sortDirection === 'none' ? submissions : [...submissions].sort((a, b) => {
                if (sortDirection === 'desc') {
                  return (b.score || 0) - (a.score || 0)
                }
                return (a.score || 0) - (b.score || 0)
              })).map((submission) => (
                <tr key={submission.id} className="border-b last:border-0">
                  <td className="py-3 px-4 break-words w-[250px]">
                    <div className="font-medium">{submission.student.full_name}</div>
                  </td>
                  <td className="py-3 px-4 whitespace-nowrap">
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
                  <td className="py-3 px-4 whitespace-nowrap">
                    {submission.score !== null ? `${submission.score}/${exam.total_points}` : 'Chưa có điểm'}
                  </td>
                  <td className="py-3 px-4">
                    <Button
                      variant="outline"
                      size="sm"
                      className="w-full sm:w-auto"
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
      )}

      <Dialog open={showGradeDialog} onOpenChange={setShowGradeDialog}>
        <DialogContent className="max-w-[95vw] sm:max-w-2xl w-full max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Chấm điểm bài làm</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-4">
            {questions.map((question, index) => (
              <Card key={question.id}>
                <CardHeader>
                  <CardTitle className="text-base">Câu {index + 1}</CardTitle>
                  <CardDescription>Điểm: {question.points}</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <Label htmlFor={`question-${question.id}`}>Câu hỏi:</Label>
                      <div className="mt-1 text-sm break-words">{question.content}</div>
                    </div>
                    <div>
                      <Label htmlFor={`answer-${question.id}`}>Câu trả lời của sinh viên:</Label>
                      <div className="mt-1 text-sm whitespace-pre-wrap break-words">
                        {selectedSubmission?.answers[question.id] || 'Không có câu trả lời'}
                      </div>
                    </div>
                    {question.type === 'multiple_choice' && (
                      <div>
                        <Label htmlFor={`correct-${question.id}`}>Đáp án đúng:</Label>
                        <div className="mt-1 text-sm break-words">{question.correct_answer}</div>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))}

            <Card>
              <CardHeader>
                <CardTitle className="text-base">Chấm điểm & Nhận xét</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
              <div className="flex items-center gap-4">
  <Label htmlFor="score">Điểm số :</Label>
  <Input
    id="score"
    type="number"
    min="0"
    max={exam.total_points}
    value={gradeData.score}
    onChange={(e) => setGradeData(prev => ({ ...prev, score: e.target.value }))}
    placeholder={`Nhập điểm (tối đa ${exam.total_points})`}
  />
</div>

    
                <div className="space-y-2">
                  <Label htmlFor="feedback">Nhận xét : </Label>
                  <div className="m-15"></div>
                  <Textarea
                    id="feedback"
                    value={gradeData.feedback}
                    onChange={(e) => setGradeData(prev => ({ ...prev, feedback: e.target.value }))}
                    placeholder="Nhập nhận xét cho bài làm..."
                    rows={4}
                    className="w-full"
                  />
                </div>
              </CardContent>
            </Card>
          </div>
          <DialogFooter className="flex-col sm:flex-row sm:justify-end gap-2 pt-4">
            <Button variant="outline" className="w-full sm:w-auto" onClick={() => setShowGradeDialog(false)}>
              Hủy
            </Button>
            <Button className="w-full sm:w-auto" onClick={handleGradeSubmit}>
              Lưu điểm
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
} 