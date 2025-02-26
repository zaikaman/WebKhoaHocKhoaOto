import { useRouter } from 'next/router';
import { useEffect } from 'react';

export default function ExamPage() {
  const router = useRouter();
  const { id } = router.query; // Lấy exam_id từ query

  useEffect(() => {
    if (id) {
      // Thực hiện các hành động cần thiết với exam_id
      console.log('Exam ID:', id);
      // Gọi API để lấy thông tin bài kiểm tra nếu cần
    }
  }, [id]);
} 