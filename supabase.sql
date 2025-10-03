-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.activity_logs (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  activity_type text NOT NULL,
  details text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT activity_logs_pkey PRIMARY KEY (id)
);
CREATE TABLE public.assignment_questions (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  assignment_id uuid,
  content text NOT NULL,
  type text NOT NULL,
  points numeric NOT NULL,
  options jsonb,
  correct_answer text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT assignment_questions_pkey PRIMARY KEY (id),
  CONSTRAINT assignment_questions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assignments(id)
);
CREATE TABLE public.assignment_submissions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  assignment_id uuid,
  student_id uuid,
  content text,
  file_url text,
  score numeric,
  submitted_at timestamp with time zone,
  graded_at timestamp with time zone,
  feedback text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  answers jsonb DEFAULT '{}'::jsonb,
  status text DEFAULT 'completed'::text,
  started_at timestamp with time zone,
  CONSTRAINT assignment_submissions_pkey PRIMARY KEY (id),
  CONSTRAINT assignment_submissions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assignments(id),
  CONSTRAINT assignment_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.assignments (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  class_id uuid,
  title text NOT NULL,
  description text,
  due_date timestamp with time zone NOT NULL,
  total_points numeric DEFAULT 10,
  file_url text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  type text NOT NULL DEFAULT 'multiple_choice'::text,
  max_attempts integer NOT NULL DEFAULT 1,
  questions_to_show integer,
  CONSTRAINT assignments_pkey PRIMARY KEY (id),
  CONSTRAINT assignments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id)
);
CREATE TABLE public.classes (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  subject_id uuid,
  teacher_id uuid,
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  semester text NOT NULL,
  academic_year text NOT NULL,
  status text DEFAULT 'active'::text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT classes_pkey PRIMARY KEY (id),
  CONSTRAINT classes_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id),
  CONSTRAINT classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.enrollments (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  class_id uuid,
  student_id uuid,
  status text DEFAULT 'enrolled'::text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT enrollments_pkey PRIMARY KEY (id),
  CONSTRAINT enrollments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id),
  CONSTRAINT enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.exam_questions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  exam_id uuid,
  content text NOT NULL,
  type text NOT NULL,
  points numeric NOT NULL,
  options jsonb,
  correct_answer text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT exam_questions_pkey PRIMARY KEY (id),
  CONSTRAINT exam_questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id)
);
CREATE TABLE public.exam_submissions (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  exam_id uuid,
  student_id uuid,
  answers jsonb,
  score numeric,
  submitted_at timestamp with time zone,
  graded_at timestamp with time zone,
  feedback text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  file_url text,
  content text,
  started_at timestamp with time zone,
  status text DEFAULT 'in-progress'::text,
  CONSTRAINT exam_submissions_pkey PRIMARY KEY (id),
  CONSTRAINT exam_submissions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id),
  CONSTRAINT exam_submissions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.exams (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  class_id uuid,
  title text NOT NULL,
  description text,
  type text NOT NULL,
  duration integer NOT NULL,
  total_points numeric DEFAULT 10,
  start_time timestamp with time zone NOT NULL,
  end_time timestamp with time zone NOT NULL,
  status text DEFAULT 'upcoming'::text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  max_attempts integer NOT NULL DEFAULT 1,
  questions_to_show integer,
  CONSTRAINT exams_pkey PRIMARY KEY (id),
  CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id)
);
CREATE TABLE public.lecture_files (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  lecture_id uuid,
  file_path text NOT NULL,
  original_filename text,
  file_type text CHECK (file_type = ANY (ARRAY['VIE'::text, 'ENG'::text, 'SIM'::text])),
  download_count integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT lecture_files_pkey PRIMARY KEY (id),
  CONSTRAINT lecture_files_lecture_id_fkey FOREIGN KEY (lecture_id) REFERENCES public.lectures(id)
);
CREATE TABLE public.lectures (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  class_id uuid,
  title text NOT NULL,
  description text,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  video_url text,
  CONSTRAINT lectures_pkey PRIMARY KEY (id),
  CONSTRAINT lectures_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  student_id text NOT NULL UNIQUE,
  full_name text,
  role text NOT NULL CHECK (role = ANY (ARRAY['student'::text, 'teacher'::text, 'admin'::text])),
  class_code text,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  status text NOT NULL DEFAULT 'active'::text CHECK (status = ANY (ARRAY['active'::text, 'inactive'::text])),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.subjects (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  description text,
  credits integer NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  CONSTRAINT subjects_pkey PRIMARY KEY (id)
);