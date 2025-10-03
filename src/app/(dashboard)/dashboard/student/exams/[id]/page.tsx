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

// Helper function to shuffle an array in-place using Fisher-Yates algorithm
function shuffleArray<T>(array: T[]): T[] {
  let currentIndex = array.length,  randomIndex;
  while (currentIndex != 0) {
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;
    [array[currentIndex], array[randomIndex]] = [array[randomIndex], array[currentIndex]];
  }
  return array;
}

interface Exam {
  id: string
  title: string
  description: string | null
  type: 'quiz' | 'midterm' | 'final'
  duration: number
  total_points: number
  start_time: string
  end_time: string
  class_id: string
  class: {
    name: string
    subject: {
      name: string
    }
  }
  max_attempts?: number
  show_answers?: boolean
}

interface ExamQuestion {
  id: string
  content: string
  type: 'multiple_choice' | 'essay'
  points: number
  options: string[] | string | null
  correct_answer: string | null
}

interface ExamSubmission {
  id: string
  answers: Record<string, string>
  score: number | null
  submitted_at: string | null
  started_at: string
  status: 'in-progress' | 'completed'
  graded_at: string | null
  feedback: string | null
}

function ExamSubmissionHistory({ submissions, exam, allQuestions }: { submissions: ExamSubmission[], exam: Exam, allQuestions: ExamQuestion[] }) {
  const [submissionToReview, setSubmissionToReview] = useState<ExamSubmission | null>(null);
  const completedSubmissions = submissions.filter(s => s.status === 'completed');

  if (completedSubmissions.length === 0) {
    return null;
  }

  const highestScore = Math.max(...completedSubmissions.map(s => s.score || 0));

  return (
    <>
      <Card className="mb-6">
        <CardHeader>
          <CardTitle>Lịch sử nộp bài kiểm tra</CardTitle>
          <CardDescription>
            Điểm cao nhất của bạn là: {highestScore.toFixed(1)}/{exam.total_points} ({completedSubmissions.length}/{exam.max_attempts || 1} lần làm)
          </CardDescription>
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
                <div className="flex items-center gap-4">
                  <p className={`font-bold text-lg ${submission.score === highestScore ? 'text-primary' : ''}`}>
                    {submission.score?.toFixed(1) ?? 'Chưa chấm'}/{exam.total_points}
                  </p>
                  <Button 
                    variant="outline" 
                    size="sm"
                    disabled={!exam.show_answers}
                    onClick={() => setSubmissionToReview(submission)}
                  >
                    Xem chi tiết
                  </Button>
                </div>
              </li>
            ))}
          </ul>
          {!exam.show_answers && (
            <p className="text-sm text-muted-foreground mt-4">Giảng viên không cho phép xem lại đáp án chi tiết cho bài kiểm tra này.</p>
          )}
        </CardContent>
      </Card>

      <Dialog open={!!submissionToReview} onOpenChange={(isOpen) => !isOpen && setSubmissionToReview(null)}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>Chi tiết bài làm</DialogTitle>
            <DialogDescription>
              Xem lại chi tiết các câu trả lời của bạn.
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[70vh] overflow-y-auto p-4 space-y-6">
            {submissionToReview && allQuestions.map((question, index) => {
              const userAnswer = submissionToReview.answers[question.id];
              const isCorrect = userAnswer === question.correct_answer;

              return (
                <Card key={question.id}>
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div>
                        <CardTitle>Câu {index + 1}</CardTitle>
                        <CardDescription>Điểm: {question.points}</CardDescription>
                      </div>
                      {question.type === 'multiple_choice' && (
                        <div className={`px-2 py-1 rounded text-sm ${
                          isCorrect ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                        }`}>
                          {isCorrect ? 'Đúng' : 'Sai'}
                        </div>
                      )}
                    </div>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="font-medium">{question.content}</div>
                    {question.type === 'multiple_choice' && (
                      <div className="space-y-3">
                        {(() => {
                          const options = typeof question.options === 'string' 
                            ? JSON.parse(question.options) 
                            : (Array.isArray(question.options) ? question.options : []);

                          return options.map((option: string, optionIndex: number) => (
                            <div key={optionIndex} className="flex items-center space-x-3">
                              <input
                                type="radio"
                                checked={userAnswer === option}
                                readOnly
                                className="h-4 w-4 border-gray-300 text-primary"
                              />
                              <label className={`text-sm ${
                                option === question.correct_answer
                                  ? 'font-bold text-green-700'
                                  : userAnswer === option
                                  ? 'font-bold text-red-700'
                                  : ''
                              }`}>
                                {option}
                                {option === question.correct_answer && ' (Đáp án đúng)'}
                              </label>
                            </div>
                          ));
                        })()}
                      </div>
                    )}
                    {question.type === 'essay' && (
                      <div>
                        <p className="font-medium text-sm text-muted-foreground">Câu trả lời của bạn:</p>
                        <p className="text-sm p-3 border rounded-md bg-muted min-h-[60px]">{userAnswer || 'Không có câu trả lời'}</p>
                      </div>
                    )}
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}


export default function ExamDetailPage({ params }: { params: { id: string } }) {
  const router = useRouter()
  const { toast } = useToast()
  const [isLoading, setIsLoading] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showConfirmDialog, setShowConfirmDialog] = useState(false)
  const [exam, setExam] = useState<Exam | null>(null)
  const [questions, setQuestions] = useState<ExamQuestion[]>([])
  const [allQuestions, setAllQuestions] = useState<ExamQuestion[]>([])
  const [submissions, setSubmissions] = useState<ExamSubmission[]>([])
  const [completedSubmissions, setCompletedSubmissions] = useState<ExamSubmission[]>([]);
  const [currentAttempt, setCurrentAttempt] = useState<ExamSubmission | null>(null)
  const [answers, setAnswers] = useState<Record<string, string>>({})
  const [timeLeft, setTimeLeft] = useState<number | null>(null)
  const [markedQuestions, setMarkedQuestions] = useState<string[]>([]);
  const questionRefs = useRef<(HTMLDivElement | null)[]>([]);

  useEffect(() => {
    loadExam()
  }, [])

  useEffect(() => {
    if (timeLeft === null) return;

    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev === null || prev <= 1) {
          clearInterval(timer)
          toast({ title: "Hết giờ", description: "Bài thi của bạn sẽ được nộp tự động." });
          handleSubmit(true); // Auto-submit
          return 0
        }
        return prev - 1
      })
    }, 1000)

    return () => clearInterval(timer)
  }, [timeLeft])

  async function loadExam() {
    try {
      setIsLoading(true)
      const currentUser = await getCurrentUser()
      if (!currentUser || currentUser.profile.role !== 'student') {
        router.push('/login'); return;
      }

      const { data: examData, error: examError } = await supabase
        .from('exams')
        .select(`*, class:classes(name, subject:subjects(name)) `)
        .eq('id', params.id)
        .single()

      if (examError) throw examError
      setExam(examData)

      const now = new Date()
      const startTime = new Date(new Date(examData.start_time).getTime() - 7 * 60 * 60 * 1000)
      const endTime = new Date(new Date(examData.end_time).getTime() - 7 * 60 * 60 * 1000)

      if (now < startTime || now > endTime) {
        toast({ variant: "destructive", title: "Lỗi", description: "Bài kiểm tra không trong thời gian làm bài." })
        router.push('/dashboard/student/exams'); return;
      }

      const { data: allSubmissions, error: submissionsError } = await supabase
        .from('exam_submissions')
        .select('*')
        .eq('exam_id', params.id)
        .eq('student_id', currentUser.profile.id)
        .order('submitted_at', { ascending: false });

      if (submissionsError) throw submissionsError;
      setSubmissions(allSubmissions || []);

      const completed = allSubmissions?.filter(s => s.status === 'completed') || [];
      setCompletedSubmissions(completed);
      const inProgressSubmission = allSubmissions?.find(s => s.status === 'in-progress');

      if (inProgressSubmission) {
        setCurrentAttempt(inProgressSubmission);
        setAnswers(inProgressSubmission.answers || {});
        const timeElapsed = (new Date().getTime() - new Date(inProgressSubmission.started_at).getTime()) / 1000;
        const remaining = (examData.duration * 60) - timeElapsed;
        setTimeLeft(remaining > 0 ? remaining : 0);
      } else if (completed.length >= (examData.max_attempts || 1)) {
        toast({ title: "Thông báo", description: `Bạn đã đạt số lần làm bài tối đa (${examData.max_attempts || 1}).` });
        setCurrentAttempt(null);
      } else {
        setCurrentAttempt(null);
      }

      const { data: questionsData, error: questionsError } = await supabase
        .from('exam_questions')
        .select('*')
        .eq('exam_id', params.id)

      if (questionsError) throw questionsError

      if (questionsData) {
        setAllQuestions(questionsData);
        let processedQuestions = shuffleArray(questionsData);

        // Check if we need to select a subset of questions
        const questionsToShow = (examData as any).questions_to_show;
        if (questionsToShow > 0 && questionsToShow < processedQuestions.length) {
          processedQuestions = processedQuestions.slice(0, questionsToShow);
        }

        const finalQuestions = processedQuestions.map(question => {
          if (question.type === 'multiple_choice' && question.options) {
            try {
                let options = typeof question.options === 'string' ? JSON.parse(question.options) : question.options;
                if (Array.isArray(options)) question.options = shuffleArray(options);
            } catch (e) {
                console.error("Failed to parse/shuffle options for question:", question.id, e);
            }
          }
          return question;
        });
        setQuestions(finalQuestions);
      } else {
        setQuestions([]);
      }

    } catch (error) {
      console.error('Lỗi khi tải bài kiểm tra:', error)
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể tải thông tin bài kiểm tra" })
      router.push('/dashboard/student/exams')
    } finally {
      setIsLoading(false)
    }
  }

  async function startNewAttempt() {
    try {
      setIsLoading(true);
      const currentUser = await getCurrentUser();
      if (!currentUser) { router.push('/login'); return; }

      if (!exam) {
        toast({ variant: "destructive", title: "Lỗi", description: "Không tìm thấy thông tin bài kiểm tra." });
        return;
      }

      if (completedSubmissions.length >= (exam.max_attempts || 1)) {
        toast({ title: "Thông báo", description: "Bạn đã hết lượt làm bài." });
        return;
      }

      const { data: newSubmission, error: newSubmissionError } = await supabase
        .from('exam_submissions')
        .insert({
          exam_id: params.id,
          student_id: currentUser.profile.id,
          status: 'in-progress',
          started_at: new Date().toISOString(),
        })
        .select()
        .single();
      
      if (newSubmissionError) throw newSubmissionError;
      
      await loadExam();

    } catch (error) {
      console.error('Lỗi khi bắt đầu lượt làm bài mới:', error);
      toast({ variant: "destructive", title: "Lỗi", description: "Không thể bắt đầu lượt làm bài mới." });
    } finally {
      setIsLoading(false);
    }
  }

  async function handleSubmit(isAutoSubmit = false) {
    if (!currentAttempt) return;

    if (!isAutoSubmit) {
        const unansweredQuestions = questions.filter(q => !answers[q.id]);
        if (unansweredQuestions.length > 0) {
            toast({ variant: "destructive", title: "Chưa hoàn thành", description: `Bạn chưa trả lời ${unansweredQuestions.length} câu hỏi` });
            setShowConfirmDialog(false);
            return;
        }
    }

    try {
      setIsSubmitting(true)
      const currentUser = await getCurrentUser()
      if (!currentUser) {
        router.push('/login'); return;
      }

      const hasEssayQuestion = questions.some(q => q.type === 'essay')
      let score = null
      if (!hasEssayQuestion) {
        score = questions.reduce((total, question) => {
          const isCorrect = answers[question.id] === question.correct_answer
          return total + (isCorrect ? question.points : 0)
        }, 0)
      }

      const { error: updateError } = await supabase
        .from('exam_submissions')
        .update({
          answers,
          score,
          submitted_at: new Date().toISOString(),
          status: 'completed',
          graded_at: !hasEssayQuestion ? new Date().toISOString() : null
        })
        .eq('id', currentAttempt.id)
        .eq('student_id', currentUser.profile.id)

      if (updateError) throw updateError

      toast({ title: "Thành công", description: `Đã nộp bài. ${!hasEssayQuestion && score !== null ? `Điểm của bạn: ${score}/${exam?.total_points}` : ''}` })
      
      setCurrentAttempt(null);
      setTimeLeft(null);
      setAnswers({});
      await loadExam();

    } catch (error: any) {
      console.error('Lỗi khi nộp bài:', error)
      toast({
        variant: "destructive",
        title: "Lỗi khi nộp bài",
        description: error.message || "Không thể nộp bài kiểm tra"
      })
    } finally {
      setIsSubmitting(false)
      setShowConfirmDialog(false)
    }
  }

  function formatTime(seconds: number) {
    if (seconds < 0) seconds = 0;
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
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

  if (isLoading && !exam) {
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

  if (!exam) {
    return <div className="flex items-center justify-center min-h-screen"><div className="text-center"><h2 className="text-xl font-semibold">Không tìm thấy bài kiểm tra</h2><Button className="mt-4" onClick={() => router.push('/dashboard/student/exams')}>Quay lại</Button></div></div>
  }

  if (!currentAttempt) {
    return (
      <div className="space-y-8">
        <div className="sticky top-0 z-50 bg-background border-b">
          <div className="container max-w-screen-2xl py-2 sm:py-4">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0">
              <div className="w-full sm:w-auto">
                <h2 className="text-xl sm:text-2xl font-bold tracking-tight">Bài kiểm tra : {exam.title}</h2>
                <p className="text-muted-foreground">{exam.class.subject.name} - {exam.class.name}</p>
              </div>
            </div>
          </div>
        </div>
        <div className="container max-w-screen-2xl pb-8 px-2 sm:px-0">
          <ExamSubmissionHistory 
            submissions={submissions} 
            exam={exam}
            allQuestions={allQuestions}
          />
          {completedSubmissions.length < (exam.max_attempts || 1) && (
            <div className="text-center mt-8">
              <Button onClick={startNewAttempt} disabled={isLoading}>
                {isLoading ? 'Đang tải...' : `Bắt đầu lần làm bài thứ ${completedSubmissions.length + 1}`}
              </Button>
            </div>
          )}
        </div>
      </div>
    );
  }

  if (!questions.length) {
    return <div className="flex items-center justify-center min-h-screen"><div className="text-center"><h2 className="text-xl font-semibold">Bài kiểm tra chưa có câu hỏi</h2><p className="mt-2 text-muted-foreground">Vui lòng liên hệ giảng viên.</p><Button className="mt-4" onClick={() => router.push('/dashboard/student/exams')}>Quay lại</Button></div></div>
  }

  return (
    <div className="flex h-screen">
      <div className="flex-1 overflow-y-auto p-4 sm:p-6 md:p-8">
        <h2 className="text-2xl sm:text-3xl font-bold tracking-tight mb-4">{exam.title}</h2>
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
                <div className="space-y-2"><Label htmlFor={`question-${question.id}`}>Câu hỏi</Label><div className="text-sm">{question.content}</div></div>
                {question.type === 'multiple_choice' ? (
                  <div className="space-y-3 w-full">
                    {(() => {
                      try {
                        const options: string[] = Array.isArray(question.options) ? question.options : (typeof question.options === 'string' ? JSON.parse(question.options) : []);
                        return options.map((option: string, optionIndex: number) => (
                          <div key={optionIndex} className="flex items-center space-x-3">
                            <input type="radio" id={`${question.id}-${optionIndex}`} name={`question-${question.id}`} value={option} checked={answers[question.id] === option} onChange={(e) => setAnswers(prev => ({...prev, [question.id]: e.target.value}))} className="h-4 w-4 border-gray-300 text-primary focus:ring-2 focus:ring-primary" />
                            <label htmlFor={`${question.id}-${optionIndex}`} className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">{option}</label>
                          </div>
                        ));
                      } catch (error) {
                        return <div className="text-red-500">Lỗi hiển thị câu hỏi</div>;
                      }
                    })()}
                  </div>
                ) : (
                  <div className="space-y-4 w-full">
                    <Textarea value={answers[question.id] || ''} onChange={(e) => setAnswers(prev => ({...prev, [question.id]: e.target.value}))} placeholder="Nhập câu trả lời của bạn vào đây..." className="min-h-[200px] text-base w-full" />
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <div className="w-64 border-l bg-gray-50 p-4 flex flex-col h-screen sticky top-0">
        <h3 className="text-lg font-semibold mb-4">Danh sách câu hỏi</h3>
        <div className="flex-1 overflow-y-auto flex flex-wrap content-start gap-2">
          {questions.map((q, i) => (
            <Button
              key={q.id}
              variant={answers[q.id] ? "default" : "outline"}
              size="sm"
              onClick={() => scrollToQuestion(i)}
              className={`w-10 h-10 ${markedQuestions.includes(q.id) ? 'ring-2 ring-yellow-400' : ''}`}>
              {i + 1}
            </Button>
          ))}
        </div>
      </div>

      <div className="fixed bottom-0 left-0 right-0 bg-background border-t p-4 flex items-center justify-between">
        {timeLeft !== null && <div className="text-lg font-semibold">Thời gian còn lại: {formatTime(timeLeft)}</div>}
        <Button disabled={isSubmitting} onClick={() => setShowConfirmDialog(true)}>Nộp bài</Button>
      </div>

      <Dialog open={showConfirmDialog} onOpenChange={setShowConfirmDialog}>
        <DialogContent>
          <DialogHeader><DialogTitle>Xác nhận nộp bài</DialogTitle><DialogDescription>Bạn có chắc chắn muốn nộp bài? Bạn sẽ không thể chỉnh sửa bài làm này sau khi nộp.</DialogDescription></DialogHeader>
          <div className="flex flex-col sm:flex-row justify-end gap-2 sm:gap-4">
            <Button variant="outline" onClick={() => setShowConfirmDialog(false)} disabled={isSubmitting} className="w-full sm:w-auto">Hủy</Button>
            <Button onClick={() => handleSubmit(false)} disabled={isSubmitting} className="w-full sm:w-auto">{isSubmitting ? 'Đang xử lý...' : 'Nộp bài'}</Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
