"use client"

import { useState, useEffect } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Crown, Trophy, Medal, Star, Sparkles, Target, SortAsc, Filter } from "lucide-react"

interface LeaderboardEntry {
  id: string
  student: {
    id: string
    full_name: string
  }
  score: number | null
  total_points: number
  submitted_at: string
  graded_at: string | null
  feedback?: string | null
  // For exam submissions
  answers?: Record<string, string> | null
  // For assignment submissions  
  content?: string | null
  file_url?: string | null
}

interface KahootLeaderboardProps {
  submissions: LeaderboardEntry[]
  title: string
  onViewDetails?: (submission: LeaderboardEntry) => void
  className?: string
}

export default function KahootLeaderboard({ submissions, title, onViewDetails, className = "" }: KahootLeaderboardProps) {
  const [isAnimating, setIsAnimating] = useState(false)
  const [showPodium, setShowPodium] = useState(false)
  const [sortBy, setSortBy] = useState<'score' | 'name' | 'time'>('score')
  const [filterBy, setFilterBy] = useState<'all' | 'graded' | 'ungraded'>('graded')

  // Lọc submissions theo filter
  const filteredSubmissions = submissions.filter(s => {
    if (filterBy === 'graded') return s.score !== null && s.graded_at !== null
    if (filterBy === 'ungraded') return s.score === null || s.graded_at === null
    return true // 'all'
  })

  // Sắp xếp submissions theo tiêu chí được chọn
  const sortedSubmissions = [...filteredSubmissions].sort((a, b) => {
    switch (sortBy) {
      case 'score':
        return (b.score || 0) - (a.score || 0)
      case 'name':
        return a.student.full_name.localeCompare(b.student.full_name)
      case 'time':
        return new Date(b.submitted_at).getTime() - new Date(a.submitted_at).getTime()
      default:
        return 0
    }
  })

  // Chỉ hiển thị podium cho những bài đã có điểm và khi không filter "ungraded"
  const gradedSubmissions = sortedSubmissions.filter(s => s.score !== null && s.graded_at !== null)
  const podiumEntries = filterBy !== 'ungraded' ? gradedSubmissions.slice(0, 3) : []
  const otherEntries = filterBy !== 'ungraded' ? gradedSubmissions.slice(3) : sortedSubmissions

  useEffect(() => {
    setIsAnimating(true)
    const timer = setTimeout(() => setShowPodium(true), 500)
    return () => clearTimeout(timer)
  }, [])

  const getPercentage = (score: number | null, total: number) => {
    if (!score) return 0
    return Math.round((score / total) * 100)
  }

  const getPodiumHeight = (position: number) => {
    switch (position) {
      case 0: return "h-32" // 1st place
      case 1: return "h-24" // 2nd place  
      case 2: return "h-20" // 3rd place
      default: return "h-16"
    }
  }

  const getPodiumColor = (position: number) => {
    switch (position) {
      case 0: return "from-yellow-400 via-yellow-500 to-yellow-600" // Gold
      case 1: return "from-gray-300 via-gray-400 to-gray-500" // Silver
      case 2: return "from-orange-400 via-orange-500 to-orange-600" // Bronze
      default: return "from-blue-400 via-blue-500 to-blue-600"
    }
  }

  const getRankIcon = (position: number) => {
    switch (position) {
      case 0: return <Crown className="w-6 h-6 text-yellow-500" />
      case 1: return <Trophy className="w-6 h-6 text-gray-500" />
      case 2: return <Medal className="w-6 h-6 text-orange-500" />
      default: return <Star className="w-5 h-5 text-blue-500" />
    }
  }

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.2
      }
    }
  }

  const itemVariants = {
    hidden: { y: 50, opacity: 0 },
    visible: {
      y: 0,
      opacity: 1,
      transition: {
        type: "spring" as const,
        stiffness: 100,
        damping: 12
      }
    }
  }

  if (sortedSubmissions.length === 0) {
    return (
      <div className={`text-center py-12 ${className}`}>
        <div className="w-24 h-24 mx-auto mb-4 rounded-full bg-gradient-to-br from-purple-400 to-pink-600 flex items-center justify-center">
          <Target className="w-12 h-12 text-white" />
        </div>
        <h3 className="text-xl font-semibold text-gray-700 mb-2">Chưa có bài làm được chấm điểm</h3>
        <p className="text-gray-500">Hãy chấm điểm các bài nộp để xem bảng xếp hạng!</p>
      </div>
    )
  }

  return (
    <div className={`space-y-8 ${className}`}>
      {/* Header */}
      <motion.div 
        initial={{ scale: 0.8, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.6 }}
        className="text-center"
      >
        <div className="inline-flex items-center justify-center w-16 h-16 mb-4 rounded-full bg-gradient-to-br from-purple-500 to-pink-600">
          <Sparkles className="w-8 h-8 text-white" />
        </div>
        <h2 className="text-3xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent mb-2">
          🏆 Bảng Xếp Hạng 🏆
        </h2>
        <p className="text-gray-600 font-medium">{title}</p>
        <div className="mt-2 text-sm text-gray-500">
          {filterBy === 'graded' ? 'Đã chấm điểm' : filterBy === 'ungraded' ? 'Chưa chấm điểm' : 'Tất cả'}: {sortedSubmissions.length}/{submissions.length} bài
        </div>
      </motion.div>

      {/* Controls */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        className="flex flex-col sm:flex-row gap-4 items-center justify-center"
      >
        <div className="flex items-center gap-2">
          <SortAsc className="w-4 h-4 text-gray-600" />
          <span className="text-sm font-medium text-gray-600">Sắp xếp:</span>
          <Select value={sortBy} onValueChange={(value: 'score' | 'name' | 'time') => setSortBy(value)}>
            <SelectTrigger className="w-[150px]">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="score">Theo điểm</SelectItem>
              <SelectItem value="name">Theo tên</SelectItem>
              <SelectItem value="time">Theo thời gian</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div className="flex items-center gap-2">
          <Filter className="w-4 h-4 text-gray-600" />
          <span className="text-sm font-medium text-gray-600">Lọc:</span>
          <Select value={filterBy} onValueChange={(value: 'all' | 'graded' | 'ungraded') => setFilterBy(value)}>
            <SelectTrigger className="w-[150px]">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="graded">Đã chấm điểm</SelectItem>
              <SelectItem value="ungraded">Chưa chấm điểm</SelectItem>
              <SelectItem value="all">Tất cả</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </motion.div>

      {/* Podium for Top 3 - Only show for graded submissions */}
      {showPodium && podiumEntries.length > 0 && filterBy !== 'ungraded' && (
        <motion.div
          initial={{ opacity: 0, y: 50 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.3 }}
          className="relative"
        >
          <div className="flex items-end justify-center gap-4 mb-8">
            {/* 2nd Place */}
            {podiumEntries[1] && (
              <motion.div
                initial={{ y: 100, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.5, duration: 0.6 }}
                className="relative flex flex-col items-center"
              >
                <div className="mb-4 relative">
                  <div className="w-16 h-16 rounded-full bg-gradient-to-br from-gray-300 to-gray-500 flex items-center justify-center border-4 border-white shadow-lg">
                    <Trophy className="w-8 h-8 text-white" />
                  </div>
                  <div className="absolute -top-2 -right-2 w-8 h-8 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center text-xs font-bold text-white">
                    2
                  </div>
                </div>
                <div className="text-center mb-2">
                  <div className="font-bold text-gray-800 text-sm break-words max-w-[120px]">
                    {podiumEntries[1].student.full_name}
                  </div>
                  <div className="text-2xl font-bold text-gray-600">
                    {podiumEntries[1].score}/{podiumEntries[1].total_points}
                  </div>
                  <div className="text-sm text-gray-500">
                    {getPercentage(podiumEntries[1].score, podiumEntries[1].total_points)}%
                  </div>
                </div>
                <div className={`w-24 ${getPodiumHeight(1)} bg-gradient-to-t ${getPodiumColor(1)} rounded-t-lg shadow-lg border-2 border-white`} />
              </motion.div>
            )}

            {/* 1st Place */}
            <motion.div
              initial={{ y: 120, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.7, duration: 0.7 }}
              className="relative flex flex-col items-center"
            >
              <div className="mb-4 relative">
                <motion.div
                  animate={{ rotate: [0, 5, -5, 0] }}
                  transition={{ duration: 2, repeat: Infinity, repeatDelay: 3 }}
                  className="w-20 h-20 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center border-4 border-white shadow-xl"
                >
                  <Crown className="w-10 h-10 text-white" />
                </motion.div>
                <motion.div
                  animate={{ scale: [1, 1.1, 1] }}
                  transition={{ duration: 1.5, repeat: Infinity }}
                  className="absolute -top-3 -right-3 w-10 h-10 rounded-full bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center text-sm font-bold text-white"
                >
                  1
                </motion.div>
              </div>
              <div className="text-center mb-2">
                <div className="font-bold text-gray-800 text-base break-words max-w-[140px]">
                  {podiumEntries[0].student.full_name}
                </div>
                <div className="text-3xl font-bold text-yellow-600">
                  {podiumEntries[0].score}/{podiumEntries[0].total_points}
                </div>
                <div className="text-sm text-yellow-600 font-medium">
                  {getPercentage(podiumEntries[0].score, podiumEntries[0].total_points)}%
                </div>
              </div>
              <div className={`w-28 ${getPodiumHeight(0)} bg-gradient-to-t ${getPodiumColor(0)} rounded-t-lg shadow-xl border-2 border-white`} />
            </motion.div>

            {/* 3rd Place */}
            {podiumEntries[2] && (
              <motion.div
                initial={{ y: 80, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.3, duration: 0.5 }}
                className="relative flex flex-col items-center"
              >
                <div className="mb-4 relative">
                  <div className="w-16 h-16 rounded-full bg-gradient-to-br from-orange-400 to-orange-600 flex items-center justify-center border-4 border-white shadow-lg">
                    <Medal className="w-8 h-8 text-white" />
                  </div>
                  <div className="absolute -top-2 -right-2 w-8 h-8 rounded-full bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center text-xs font-bold text-white">
                    3
                  </div>
                </div>
                <div className="text-center mb-2">
                  <div className="font-bold text-gray-800 text-sm break-words max-w-[120px]">
                    {podiumEntries[2].student.full_name}
                  </div>
                  <div className="text-2xl font-bold text-orange-600">
                    {podiumEntries[2].score}/{podiumEntries[2].total_points}
                  </div>
                  <div className="text-sm text-orange-500">
                    {getPercentage(podiumEntries[2].score, podiumEntries[2].total_points)}%
                  </div>
                </div>
                <div className={`w-24 ${getPodiumHeight(2)} bg-gradient-to-t ${getPodiumColor(2)} rounded-t-lg shadow-lg border-2 border-white`} />
              </motion.div>
            )}
          </div>
        </motion.div>
      )}

      {/* Rest of the leaderboard */}
      {otherEntries.length > 0 && (
        <motion.div
          variants={containerVariants}
          initial="hidden"
          animate="visible"
          className="space-y-3"
        >
          <h3 className="text-xl font-semibold text-center text-gray-700 mb-4">
            {filterBy === 'ungraded' ? 'Danh sách chờ chấm điểm' : 
             filterBy === 'graded' ? 'Bảng xếp hạng chi tiết' :
             'Danh sách tất cả bài nộp'}
          </h3>
          {otherEntries.map((submission, index) => {
            const rank = filterBy !== 'ungraded' ? index + 4 : index + 1 // Since top 3 are in podium for graded
            const percentage = getPercentage(submission.score, submission.total_points)
            
            return (
              <motion.div
                key={submission.id}
                variants={itemVariants}
                className="group"
              >
                <Card className="relative overflow-hidden border-2 hover:border-blue-300 transition-all duration-300 hover:shadow-lg">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-4">
                      {/* Rank */}
                      <div className="flex-shrink-0 w-12 h-12 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center text-white font-bold text-lg">
                        {rank}
                      </div>

                      {/* Student Info */}
                      <div className="flex-grow min-w-0">
                        <div className="font-semibold text-gray-800 text-lg break-words">
                          {submission.student.full_name}
                        </div>
                        <div className="text-sm text-gray-500">
                          Nộp: {new Date(submission.submitted_at).toLocaleString('vi-VN')}
                        </div>
                      </div>

                      {/* Score */}
                      <div className="text-right flex-shrink-0">
                        {submission.score !== null ? (
                          <>
                            <div className="text-2xl font-bold text-blue-600">
                              {submission.score}/{submission.total_points}
                            </div>
                            <div className="text-sm text-gray-600 font-medium">
                              {percentage}%
                            </div>
                          </>
                        ) : (
                          <div className="text-lg font-medium text-gray-400">
                            Chưa chấm
                          </div>
                        )}
                      </div>

                      {/* Progress Bar */}
                      <div className="flex-shrink-0 w-24">
                        {submission.score !== null ? (
                          <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                            <motion.div
                              initial={{ width: 0 }}
                              animate={{ width: `${percentage}%` }}
                              transition={{ duration: 1, delay: index * 0.1 }}
                              className="h-full bg-gradient-to-r from-blue-400 to-blue-600 rounded-full"
                            />
                          </div>
                        ) : (
                          <div className="h-2 bg-gray-200 rounded-full" />
                        )}
                      </div>

                      {/* View Details Button */}
                      {onViewDetails && (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => onViewDetails(submission)}
                          className="flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                        >
                          Chi tiết
                        </Button>
                      )}
                    </div>

                    {/* Achievement Badges & Status */}
                    <div className="mt-3 flex gap-2 flex-wrap">
                      {submission.score !== null ? (
                        <>
                          {percentage === 100 && (
                            <Badge className="bg-gradient-to-r from-green-500 to-green-600 text-white">
                              🎯 Hoàn hảo
                            </Badge>
                          )}
                          {percentage >= 90 && percentage < 100 && (
                            <Badge className="bg-gradient-to-r from-blue-500 to-blue-600 text-white">
                              ⭐ Xuất sắc
                            </Badge>
                          )}
                          {percentage >= 80 && percentage < 90 && (
                            <Badge className="bg-gradient-to-r from-purple-500 to-purple-600 text-white">
                              👍 Giỏi
                            </Badge>
                          )}
                          {percentage >= 70 && percentage < 80 && (
                            <Badge className="bg-gradient-to-r from-orange-500 to-orange-600 text-white">
                              ✓ Khá
                            </Badge>
                          )}
                          {percentage < 70 && percentage > 0 && (
                            <Badge className="bg-gradient-to-r from-gray-500 to-gray-600 text-white">
                              📖 Cần cố gắng
                            </Badge>
                          )}
                        </>
                      ) : (
                        <Badge variant="outline" className="border-yellow-300 text-yellow-700">
                          ⏳ Chờ chấm điểm
                        </Badge>
                      )}
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            )
          })}
        </motion.div>
      )}

      {/* Summary Stats - Only show for graded submissions */}
      {gradedSubmissions.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1, duration: 0.6 }}
          className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-8"
        >
          <Card className="text-center p-4 bg-gradient-to-br from-green-50 to-green-100 border-green-200">
            <div className="text-2xl font-bold text-green-600">
              {Math.round(gradedSubmissions.reduce((sum, s) => sum + (s.score || 0), 0) / gradedSubmissions.length * 100 / gradedSubmissions[0]?.total_points || 0)}%
            </div>
            <div className="text-sm text-green-700 font-medium">Điểm trung bình</div>
          </Card>

          <Card className="text-center p-4 bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200">
            <div className="text-2xl font-bold text-blue-600">
              {Math.max(...gradedSubmissions.map(s => getPercentage(s.score, s.total_points)))}%
            </div>
            <div className="text-sm text-blue-700 font-medium">Điểm cao nhất</div>
          </Card>

          <Card className="text-center p-4 bg-gradient-to-br from-purple-50 to-purple-100 border-purple-200">
            <div className="text-2xl font-bold text-purple-600">
              {gradedSubmissions.filter(s => getPercentage(s.score, s.total_points) >= 80).length}
            </div>
            <div className="text-sm text-purple-700 font-medium">Học sinh đạt từ 80%</div>
          </Card>
        </motion.div>
      )}
    </div>
  )
}