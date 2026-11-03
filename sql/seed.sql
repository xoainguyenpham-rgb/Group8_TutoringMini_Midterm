-- GROUP 08 / DE 01 - WORKING DRAFT FROM schemas.sql (02 Nov 2026)
-- Reviewer approval pending. Source data is preserved without modifications.
-- The teacher requires all four SQL scripts in the order schema -> seed -> queries -> views.
-- Run once on a CLEAN tutoring_mini database after schema.sql.
USE tutoring_mini;

INSERT INTO subjects (subject_id, name) VALUES
(1, 'Mathematics'),
(2, 'English'),
(3, 'Physics'),
(4, 'Chemistry'),
(5, 'Biology');

INSERT INTO tutors
    (tutor_id, full_name, email, qualification, subject_id)
VALUES
(1, 'Nguyen Minh Anh', 'minhanh.nguyen@example.com',
 'MSc in Mathematics', 1),

(2, 'Tran Thu Ha', 'thuha.tran@example.com',
 'BA in English Language', 2),

(3, 'Le Quang Huy', 'quanghuy.le@example.com',
 'MSc in Physics', 3),

(4, 'Pham Ngoc Linh', 'ngoclinh.pham@example.com',
 'BSc in Chemistry', 4),

(5, 'Do Thanh Tung', 'thanhtung.do@example.com',
 'MSc in Biology', 1),

(6, 'Hoang Mai Phuong', 'maiphuong.hoang@example.com',
 'BSc in Biology', 5);

INSERT INTO students
    (student_id, full_name, dob, phone)
VALUES
(1, 'Nguyen Bao An', '2008-03-15', '0901000001'),
(2, 'Tran Gia Han', '2009-07-22', '0901000002'),
(3, 'Le Duc Minh', '2007-11-08', '0901000003'),
(4, 'Pham Khanh Linh', '2008-05-19', '0901000004'),
(5, 'Hoang Tuan Kiet', '2009-01-30', '0901000005'),
(6, 'Do Ngoc Anh', '2007-09-12', '0901000006'),
(7, 'Vu Minh Quan', '2008-12-03', '0901000007'),
(8, 'Bui Phuong Thao', '2009-04-25', '0901000008'),
(9, 'Dang Hoai Nam', '2007-06-17', '0901000009'),
(10, 'Ngo Thu Trang', '2008-10-11', '0901000010');

INSERT INTO lessons
    (lesson_id, student_id, tutor_id, lesson_date, status)
VALUES
(1, 1, 1, '2025-01-05 09:00:00', 'Completed'),
(2, 1, 2, '2025-01-12 09:00:00', 'Completed'),
(3, 2, 3, '2025-01-20 10:00:00', 'Completed'),
(4, 1, 1, '2025-02-10 09:00:00', 'Completed'),
(5, 1, 5, '2025-03-15 14:00:00', 'Completed'),
(6, 1, 2, '2025-04-10 09:00:00', 'Completed'),
(7, 3, 3, '2025-06-20 10:00:00', 'Pending'),
(8, 4, 4, '2025-09-15 14:00:00', 'Completed'),
(9, 5, 5, '2025-12-10 09:00:00', 'Completed'),
(10, 6, 1, '2024-12-15 09:00:00', 'Completed'),
(11, 7, 2, '2026-01-10 10:00:00', 'Completed'),
(12, 8, 6, '2026-04-15 14:00:00', 'Cancelled');

INSERT INTO lesson_reports
    (report_id, lesson_id, content, feedback, duration_minutes, fee)
VALUES
(1, 1, 'Introduction to algebra and basic equations',
 'The student understood the fundamental concepts well.',
 90, 500000),

(2, 2, 'English grammar and vocabulary practice',
 'The student showed good progress in vocabulary.',
 90, 500000),

(3, 3, 'Fundamental physics concepts and motion',
 'The student needs more practice with problem solving.',
 90, 500000),

(4, 4, 'Linear equations and mathematical problem solving',
 'The student improved accuracy when solving equations.',
 90, 500000),

(5, 5, 'Biology: cell structure and basic functions',
 'The student participated actively in the lesson.',
 90, 500000),

(6, 6, 'English reading comprehension and writing',
 'The student demonstrated better reading skills.',
 90, 500000),

(7, 8, 'Chemistry: atomic structure and chemical bonds',
 'The student understood the main concepts.',
 90, 500000),

(8, 9, 'Biology: genetics and inheritance',
 'The student should review key terminology.',
 90, 500000),

(9, 10, 'Mathematics review and practice exercises',
 'The student completed most exercises correctly.',
 90, 500000),

(10, 11, 'English speaking and communication practice',
 'The student communicated confidently.',
 90, 500000);

INSERT INTO payments
    (payment_id, lesson_id, amount, payment_date, method)
VALUES
(1, 1, 500000, '2025-01-06 10:00:00', 'Cash'),
(2, 2, 200000, '2025-01-13 10:00:00', 'BankTransfer'),
(3, 2, 300000, '2025-01-14 10:00:00', 'Card'),
(4, 4, 300000, '2025-02-11 10:00:00', 'BankTransfer'),
(5, 5, 500000, '2025-03-16 10:00:00', 'Cash'),
(6, 6, 500000, '2025-04-11 10:00:00', 'Card'),
(7, 8, 200000, '2025-09-16 10:00:00', 'BankTransfer'),
(8, 9, 500000, '2025-12-11 10:00:00', 'Cash'),
(9, 10, 500000, '2024-12-16 10:00:00', 'BankTransfer'),
(10, 11, 500000, '2026-01-11 10:00:00', 'Card');

-- Validation checks; violation queries A-C should return 0 rows.
-- A. FK integrity. Database FKs should already enforce this.
SELECT 'tutors.subject_id' AS violation, t.tutor_id AS record_id
FROM tutors t LEFT JOIN subjects s ON s.subject_id = t.subject_id
WHERE s.subject_id IS NULL
UNION ALL
SELECT 'lessons.student_id', l.lesson_id
FROM lessons l LEFT JOIN students s ON s.student_id = l.student_id
WHERE s.student_id IS NULL
UNION ALL
SELECT 'lessons.tutor_id', l.lesson_id
FROM lessons l LEFT JOIN tutors t ON t.tutor_id = l.tutor_id
WHERE t.tutor_id IS NULL
UNION ALL
SELECT 'lesson_reports.lesson_id', r.report_id
FROM lesson_reports r LEFT JOIN lessons l ON l.lesson_id = r.lesson_id
WHERE l.lesson_id IS NULL
UNION ALL
SELECT 'payments.lesson_id', p.payment_id
FROM payments p LEFT JOIN lessons l ON l.lesson_id = p.lesson_id
WHERE l.lesson_id IS NULL;

-- B. Completed must have EXACTLY one report; other states must have NONE.
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
HAVING (l.status = 'Completed' AND COUNT(r.report_id) <> 1)
    OR (l.status <> 'Completed' AND COUNT(r.report_id) <> 0);

-- C. No payment before confirmed fee; no overpayment.
SELECT l.lesson_id, l.status, r.fee AS confirmed_fee,
       COALESCE(SUM(p.amount), 0) AS total_paid
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
LEFT JOIN payments p ON p.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status, r.report_id, r.fee
HAVING total_paid > COALESCE(r.fee, 0)
    OR (total_paid > 0 AND (l.status <> 'Completed' OR r.report_id IS NULL));

-- D. Required row-counts (read counts; verify each minimum).
SELECT 'subjects' AS table_name, COUNT(*) AS actual_rows, 5 AS min_rows FROM subjects
UNION ALL SELECT 'tutors', COUNT(*), 6 FROM tutors
UNION ALL SELECT 'students', COUNT(*), 10 FROM students
UNION ALL SELECT 'lessons', COUNT(*), 12 FROM lessons
UNION ALL SELECT 'lesson_reports', COUNT(*), 10 FROM lesson_reports
UNION ALL SELECT 'payments', COUNT(*), 10 FROM payments;

-- E. Status distribution: requires all 3 statuses.
SELECT status, COUNT(*) AS lesson_count FROM lessons GROUP BY status;

-- F. Business scenarios. Verify at least one returned row per requirement.
-- Student has >3 Completed lessons in 2025:
SELECT student_id, COUNT(*) AS completed_2025
FROM lessons
WHERE status = 'Completed' AND lesson_date >= '2025-01-01'
  AND lesson_date < '2026-01-01'
GROUP BY student_id HAVING COUNT(*) > 3;

-- Multiple payments for at least one lesson:
SELECT lesson_id, COUNT(*) AS payment_count
FROM payments GROUP BY lesson_id HAVING COUNT(*) > 1;

-- At least one Completed lesson has unpaid balance:
SELECT l.lesson_id, r.fee,
       COALESCE(SUM(p.amount),0) AS paid,
       r.fee - COALESCE(SUM(p.amount),0) AS debt
FROM lessons l JOIN lesson_reports r ON r.lesson_id = l.lesson_id
LEFT JOIN payments p ON p.lesson_id = l.lesson_id
WHERE l.status = 'Completed'
GROUP BY l.lesson_id, r.fee
HAVING debt > 0;