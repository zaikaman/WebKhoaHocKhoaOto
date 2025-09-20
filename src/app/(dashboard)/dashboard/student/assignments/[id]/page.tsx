"use client"

import { useEffect, useState, useRef } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { useToast } from "@/components/ui/use-toast"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { getCurrentUser, supabase } from "@/lib/supabase"
import { Bookmark } from "lucide-react"

function shuffleArray<T>(array: T[]): T[] {
  let currentIndex = array.length,  randomIndex;
  while (currentIndex != 0) {
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;
    [array[currentIndex], array[randomIndex]] = [array[randomIndex], array[currentIndex]];
  }
  return array;
}

interface Assignment {
  id: string
  title: string
  description: string | null
  due_date: string
  total_points: number
  class_id: string
  class: { name: string; subject: { name: string } }
}

interface AssignmentQuestion {
  id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | string | null
  correct_answer: string | null
}

interface AssignmentSubmission {
  id: string
  answers: Record<string, string>
  score: number | null
  submitted_at: string | null
  status: 'in-progress' | 'completed'
}

function SubmissionHistory({ submissions, totalPoints }: { submissions: AssignmentSubmission[], totalPoints: number }) {
  const completedSubmissions = submissions.filter(s => s.status === 'completed');
  if (completedSubmissions.length === 0) return null;

  const highestScore = Math.max(...completedSubmissions.map(s => s.score || 0));

  return (
    <Card className="mb-6">
      <CardHeader>
        <CardTitle>Lịch sử nộp bài</CardTitle>
        <CardDescription>Điểm cao nhất của bạn là: {highestScore}/{totalPoints}</CardDescription>
      </CardHeader>
      <CardContent>
        <ul className="space-y-4">
          {completedSubmissions.map((submission, index) => (
            <li key={submission.id} className="flex justify-between items-center p-4 rounded-md border">
              <div>
                <p className="font-semibold">Lần {completedSubmissions.length - index}</p>
                <p className="text-sm text-muted-foreground">
                  Nộp lúc: {submission.submitted_at ? new Date(submission.submitted_at).toLocaleString('vi-VN') : 'Chưa có'}
                </p>
              </div>
              <p className={`font-bold text-lg ${submission.score === highestScore ? 'text-primary' : ''}`}>
                {submission.score ?? 'Chưa chấm'}/{totalPoints}
              </p>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}

export default function AssignmentTakingPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showConfirmDialog, setShowConfirmDialog] = useState(false)
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [questions, setQuestions] = useState<AssignmentQuestion[]>([])
  const [submissions, setSubmissions] = useState<AssignmentSubmission[]>([])
  const [currentAttempt, setCurrentAttempt] = useState<AssignmentSubmission | null>(null);
  const [answers, setAnswers] = useState<Record<string, string>>({})
  const [markedQuestions, setMarkedQuestions] = useState<string[]>([]);
  const questionRefs = useRef<(HTMLDivElement | null)[]>([]);

  useEffect(() => {
    loadAssignmentData()
  }, [])

  async function loadAssignmentData() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'student') {
        router.push('/login'); return;
      }

      const { data: assignmentData, error: assignmentError } = await supabase
        .from('assignments').select(`*, class:classes(name, subject:subjects(name))`).eq('id', params.id).single()

      if (assignmentError) throw assignmentError
      setAssignment(assignmentData)

      const { data: allSubmissions, error: submissionError } = await supabase
        .from('assignment_submissions').select('*').eq('assignment_id', params.id).eq('student_id', currentUser.profile.id).order('submitted_at', { ascending: false });

      if (submissionError) throw submissionError
      setSubmissions(allSubmissions || []);

      const inProgressSubmission = allSubmissions?.find(s => s.status === 'in-progress');
      if (inProgressSubmission) {
        setCurrentAttempt(inProgressSubmission);
        setAnswers(inProgressSubmission.answers || {});
      } else {
        setCurrentAttempt(null);
      }

      const { data: questionsData, error: questionsError } = await supabase.from('assignment_questions').select('*').eq('assignment_id', params.id)
      if (questionsError) throw questionsError

      if (questionsData) {
        const shuffledQuestions = shuffleArray(questionsData).map(q => {
          if (q.type === 'multiple_choice' && q.options) {
            try {
              let options = typeof q.options === 'string' ? JSON.parse(q.options) : q.options;
              if (Array.isArray(options)) q.options = shuffleArray(options);
            } catch (e) { console.error("Failed to parse/shuffle options:", q.id, e); }
          }
          return q;
        });
        setQuestions(shuffledQuestions);
      } else {
        setQuestions([]);
      }

    } catch (error) {
      console.error('Lỗi khi tải bài tập:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải thông tin bài tập" })
      router.push('/dashboard/student/assignments')
    } finally {
      setIsLoading(false)
    }
  }

  async function startNewAttempt() {
    try {
      setIsLoading(true);
      const currentUser = await getCurrentUser();
      if (!currentUser) { router.push('/login'); return; }

      const { data: newSubmission, error } = await supabase
        .from('assignment_submissions')
        .insert({ 
          assignment_id: params.id, 
          student_id: currentUser.profile.id, 
          status: 'in-progress' 
        })
        .select()
        .single();

      if (error) throw error;
      await loadAssignmentData();
    } catch (error) {
      console.error('Lỗi khi bắt đầu lượt làm bài mới:', error);
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể bắt đầu lượt làm bài mới." });
    } finally {
      setIsLoading(false);
    }
  }

  async function handleSubmit() {
    if (!currentAttempt) return;

    try {
      setIsSubmitting(true)
      const currentUser = await getCurrentUser()
      if (!currentUser) { router.push('/login'); return; }

      const unansweredQuestions = questions.filter(q => !answers[q.id])
      if (unansweredQuestions.length > 0) {
        toast({ variant: "destructive", title: "Chưa hoàn thành", description: `Bạn chưa trả lời ${unansweredQuestions.length} câu hỏi` })
        setShowConfirmDialog(false);
        return;
      }

      const hasEssayQuestion = questions.some(q => q.type === 'essay')
      let score = null
      if (!hasEssayQuestion) {
        score = questions.reduce((total, q) => total + (answers[q.id] === q.correct_answer ? q.points : 0), 0)
      }

      const { error } = await supabase
        .from('assignment_submissions')
        .update({
          answers,
          score,
          submitted_at: new Date().toISOString(),
          status: 'completed',
          graded_at: !hasEssayQuestion ? new Date().toISOString() : null
        })
        .eq('id', currentAttempt.id)

      if (error) throw error

      toast({ title: "Thành công", description: `Đã nộp bài. ${!hasEssayQuestion && score !== null ? `Điểm của bạn: ${score}/${assignment?.total_points}` : ''}` })
      
      setAnswers({});
      await loadAssignmentData();

    } catch (error) {
      console.error('Lỗi khi nộp bài:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể nộp bài tập" })
    } finally {
      setIsSubmitting(false)
      setShowConfirmDialog(false)
    }
  }

  const toggleMarkQuestion = (questionId: string) => {
    setMarkedQuestions(prev =>
        prev.includes(questionId)
            ? prev.filter(id => id !== questionId)
            : [...prev, questionId]
    );
  };

  const scrollToQuestion = (index: number) => {
      questionRefs.current[index]?.scrollIntoView({
          behavior: 'smooth',
          block: 'start',
      });
  };

  if (isLoading && !assignment) {
    return (
      <div className="flex h-screen">
        <div className="flex-1 overflow-y-auto p-4 sm:p-6 md:p-8">
          <div className="h-8 w-1/2 bg-muted rounded animate-pulse mb-4" />
          <div className="space-y-6">
            {[...Array(3)].map((_, index) => (
              <div key={index} className="rounded-lg border bg-card text-card-foreground shadow-sm w-full">
                <div className="p-6 space-y-4">
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="h-6 w-24 bg-muted rounded animate-pulse mb-2" />
                      <div className="h-4 w-16 bg-muted rounded animate-pulse" />
                    </div>
                    <div className="h-8 w-8 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="space-y-2">
                    <div className="h-4 w-full bg-muted rounded animate-pulse" />
                    <div className="h-4 w-3/4 bg-muted rounded animate-pulse" />
                  </div>
                  <div className="h-24 bg-muted rounded animate-pulse" />
                </div>
              </div>
            ))}
          </div>
        </div>
        <div className="w-64 border-l bg-gray-50 p-4 flex flex-col h-screen sticky top-0">
          <div className="h-6 w-3/4 bg-muted rounded animate-pulse mb-4" />
          <div className="flex-1 overflow-y-auto grid grid-cols-4 gap-2">
            {[...Array(12)].map((_, i) => (
              <div key={i} className="h-10 w-full bg-muted rounded animate-pulse" />
            ))}
          </div>
        </div>
      </div>
    )
  }

  if (!assignment) {
    return <div className="text-center"><h2 className="text-xl font-semibold">Không tìm thấy bài tập</h2><Button className="mt-4" onClick={() => router.push('/dashboard/student/assignments')}>Quay lại</Button></div>
  }

  const isOverdue = new Date() > new Date(new Date(assignment.due_date).getTime() - 7 * 60 * 60 * 1000);

  if (!currentAttempt) {
    return (
      <div className="space-y-8">
         <div className="sticky top-0 z-50 bg-background border-b"><div className="container max-w-screen-2xl py-4"><h2 className="text-2xl font-bold tracking-tight">{assignment.title}</h2><p className="text-muted-foreground">{assignment.class.subject.name} - {assignment.class.name}</p></div></div>
        <div className="container max-w-screen-2xl pb-8">
          <SubmissionHistory submissions={submissions} totalPoints={assignment.total_points} />
          {!isOverdue ? (
            <div className="text-center mt-8">
              <Button onClick={startNewAttempt} disabled={isLoading}>
                {isLoading ? 'Đang tải...' : (submissions.length > 0 ? 'Làm lại' : 'Bắt đầu làm bài')}
              </Button>
            </div>
          ) : (
             <div className="text-center mt-8"><p className="text-red-500">Bài tập đã quá hạn nộp.</p></div>
          )}
        </div>
      </div>
    );
  }

  if (!questions.length) {
    return <div className="text-center"><h2 className="text-xl font-semibold">Bài tập chưa có câu hỏi</h2><p className="mt-2">Vui lòng liên hệ giảng viên.</p><Button className="mt-4" onClick={() => router.push(`/dashboard/student/courses/${assignment.class_id}`)}>Quay lại</Button></div>
  }

  return (
    <div className="flex h-screen">
      <div className="flex-1 overflow-y-auto p-4 sm:p-6 md:p-8">
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight mb-4">{assignment.title}</h2>
        <div className="space-y-6">
          {questions.map((question, index) => (
            <Card key={question.id} ref={el => { questionRefs.current[index] = el }} className="w-full">
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle>Câu {index + 1}</CardTitle>
                    <CardDescription>Điểm: {question.points}</CardDescription>
                  </div>
                  <Button variant="outline" size="icon" onClick={() => toggleMarkQuestion(question.id)} className={markedQuestions.includes(question.id) ? 'bg-yellow-200' : ''}>
                    <Bookmark className="h-4 w-4" />
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="text-sm">{question.content}</div>
                {question.type === 'multiple_choice' ? (
                  <div className="space-y-3">
                    {(() => {
                      try {
                        const options = Array.isArray(question.options) ? question.options : JSON.parse(question.options as string || '[]');
                        return options.map((option: string, i: number) => (
                          <div key={i} className="flex items-center space-x-3">
                            <input type="radio" id={`${question.id}-${i}`} name={`question-${question.id}`} value={option} checked={answers[question.id] === option} onChange={e => setAnswers(prev => ({ ...prev, [question.id]: e.target.value }))} className="h-4 w-4" />
                            <label htmlFor={`${question.id}-${i}`} className="text-sm font-medium">{option}</label>
                          </div>
                        ));
                      } catch (e) { return <div className="text-red-500">Lỗi hiển thị câu hỏi</div>; }
                    })()}
                  </div>
                ) : (
                  <Textarea value={answers[question.id] || ''} onChange={e => setAnswers(prev => ({ ...prev, [question.id]: e.target.value }))} placeholder="Nhập câu trả lời..." className="min-h-[150px]" />
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <div className="w-64 border-l bg-gray-50 p-4 flex flex-col h-screen sticky top-0">
        <h3 className="text-lg font-semibold mb-4">Danh sách câu hỏi</h3>
        <div className="flex-1 overflow-y-auto grid grid-cols-4 gap-2">
          {questions.map((q, i) => (
            <Button
              key={q.id}
              variant={answers[q.id] ? "default" : "outline"}
              size="sm"
              onClick={() => scrollToQuestion(i)}
              className={`w-full h-10 ${markedQuestions.includes(q.id) ? 'ring-2 ring-yellow-400' : ''}`}>
              {i + 1}
            </Button>
          ))}
        </div>
      </div>

      <div className="fixed bottom-0 left-0 right-0 bg-background border-t p-4 flex items-center justify-end">
        <Button disabled={isSubmitting || isOverdue} onClick={() => setShowConfirmDialog(true)}>{isOverdue ? "Đã quá hạn" : "Nộp bài"}</Button>
      </div>

      <Dialog open={showConfirmDialog} onOpenChange={setShowConfirmDialog}>
        <DialogContent><DialogHeader><DialogTitle>Xác nhận nộp bài</DialogTitle><DialogDescription>Bạn có chắc chắn muốn nộp bài?</DialogDescription></DialogHeader>
          <div className="flex justify-end gap-4">
            <Button variant="outline" onClick={() => setShowConfirmDialog(false)} disabled={isSubmitting}>Hủy</Button>
            <Button onClick={handleSubmit} disabled={isSubmitting}>{isSubmitting ? 'Đang xử lý...' : 'Nộp bài'}</Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
