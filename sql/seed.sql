
-- ============================================================
-- GROUP 8 | DE 01 | QUAN LY TRUNG TAM GIA SU
-- File: seed.sql
-- T07: INSERT SUBJECTS, TUTORS, STUDENTS
-- ============================================================

USE tutoring_mini;

-- ------------------------------------------------------------
-- T07.1. INSERT SUBJECTS (5 records)
-- ------------------------------------------------------------

INSERT INTO subjects (subject_id, name)
VALUES
(1, 'Mathematics'),
(2, 'Physics'),
(3, 'Chemistry'),
(4, 'Literature'),
(5, 'Biology');


-- ------------------------------------------------------------
-- T07.2. INSERT TUTORS (6 records)
-- Each tutor belongs to one existing subject.
-- Tutor 5 teaches Biology (subject_id = 5).
-- Tutor 6 teaches Literature (subject_id = 4).
-- ------------------------------------------------------------

INSERT INTO tutors
(tutor_id, full_name, email, qualification, subject_id)
VALUES
(1, 'Nguyen Van Minh', 'minh.nguyen@example.com', 'MSc in Mathematics', 1),
(2, 'Tran Thi Lan', 'lan.tran@example.com', 'MSc in Physics', 2),
(3, 'Le Quang Huy', 'huy.le@example.com', 'BSc in Chemistry', 3),
(4, 'Pham Thu Ha', 'ha.pham@example.com', 'MA in Mathematics', 1),
(5, 'Do Thanh Tung', 'tung.do@example.com', 'MSc in Biology', 5),
(6, 'Hoang Mai Anh', 'anh.hoang@example.com', 'MA in Literature', 4);


-- ------------------------------------------------------------
-- T07.3. INSERT STUDENTS (10 records)
-- ------------------------------------------------------------

INSERT INTO students
(student_id, full_name, dob, phone)
VALUES
(1, 'Nguyen Minh Anh', '2008-03-15', '0901000001'),
(2, 'Tran Gia Bao', '2009-06-20', '0901000002'),
(3, 'Le Khanh Linh', '2007-11-08', '0901000003'),
(4, 'Pham Duc Anh', '2008-09-12', '0901000004'),
(5, 'Hoang Thu Trang', '2009-01-25', '0901000005'),
(6, 'Vu Quoc Bao', '2007-05-17', '0901000006'),
(7, 'Do Ngoc Ha', '2008-12-03', '0901000007'),
(8, 'Bui Thanh Nam', '2009-07-29', '0901000008'),
(9, 'Dang Phuong Thao', '2007-04-11', '0901000009'),
(10, 'Ngo Tuan Kiet', '2008-10-22', '0901000010');


-- ------------------------------------------------------------
-- T07.4. VALIDATION QUERIES
-- Expected counts: 5 subjects, 6 tutors, 10 students.
-- ------------------------------------------------------------

SELECT COUNT(*) AS total_subjects FROM subjects;

SELECT COUNT(*) AS total_tutors FROM tutors;

SELECT COUNT(*) AS total_students FROM students;

-- Check tutor-subject relationships
SELECT
    t.tutor_id,
    t.full_name AS tutor_name,
    t.qualification,
    s.subject_id,
    s.name AS subject_name
FROM tutors t
JOIN subjects s ON t.subject_id = s.subject_id
ORDER BY t.tutor_id;

-- Check for tutors referencing non-existing subjects
SELECT t.tutor_id, t.full_name, t.subject_id
FROM tutors t
LEFT JOIN subjects s ON t.subject_id = s.subject_id
WHERE s.subject_id IS NULL;
-- Expected result: 0 rows.


-- ============================================================
-- T08. INSERT LESSONS AND LESSON_REPORTS
-- ============================================================

-- ------------------------------------------------------------
-- T08.1. INSERT LESSONS (12 records)
-- ------------------------------------------------------------

INSERT INTO lessons
(lesson_id, student_id, tutor_id, lesson_date, status)
VALUES
-- January 2025
(1,  1, 1, '2025-01-05 09:00:00', 'Completed'),
(2,  1, 2, '2025-01-12 14:00:00', 'Completed'),
(3,  2, 1, '2025-01-20 10:00:00', 'Completed'),

-- Other months in Q1 2025
(4,  1, 2, '2025-02-10 15:00:00', 'Completed'),
(5,  1, 5, '2025-03-15 09:00:00', 'Completed'),

-- Outside Q1 2025
(6,  1, 3, '2025-04-10 14:00:00', 'Completed'),
(7,  4, 4, '2025-06-20 10:00:00', 'Pending'),
(8,  5, 3, '2025-09-15 15:00:00', 'Completed'),
(9,  6, 5, '2025-12-10 09:00:00', 'Completed'),

-- Outside 2025
(10, 7, 1, '2024-12-15 14:00:00', 'Completed'),
(11, 8, 2, '2026-01-10 10:00:00', 'Completed'),
(12, 9, 6, '2026-04-15 15:00:00', 'Cancelled');


-- ------------------------------------------------------------
-- T08.2. INSERT LESSON_REPORTS (10 records)
-- Every Completed lesson has exactly one report.
-- Pending and Cancelled lessons have no report.
-- ------------------------------------------------------------

INSERT INTO lesson_reports
(report_id, lesson_id, content, feedback, duration_minutes, fee)
VALUES
(1,  1, 'Mathematics: Basic algebra and equations',
 'Good understanding of the lesson', 90, 500000),

(2,  2, 'Physics: Introduction to mechanics',
 'Needs more practice with exercises', 90, 500000),

(3,  3, 'Mathematics: Linear equations',
 'Completed the exercises successfully', 90, 500000),

(4,  4, 'Physics: Motion and forces',
 'Good progress during the lesson', 90, 500000),

(5,  5, 'Biology: Cell structure and functions',
 'Understands the main concepts', 90, 500000),

(6,  6, 'Chemistry: Introduction to chemical reactions',
 'Needs additional revision', 90, 500000),

(7,  8, 'Chemistry: Acids and bases',
 'Completed most exercises', 90, 500000),

(8,  9, 'Biology: Human biology',
 'Good participation and understanding', 90, 500000),

(9,  10, 'Mathematics: Geometry revision',
 'Completed the lesson objectives', 90, 500000),

(10, 11, 'Physics: Electricity fundamentals',
 'Good performance in the lesson', 90, 500000);

-- ------------------------------------------------------------
-- T08.3. VALIDATION QUERIES
-- ------------------------------------------------------------

-- Check total lessons
SELECT COUNT(*) AS total_lessons
FROM lessons;

-- Check total lesson reports
SELECT COUNT(*) AS total_reports
FROM lesson_reports;

-- Check lesson status distribution
SELECT status, COUNT(*) AS total
FROM lessons
GROUP BY status
ORDER BY status;

-- Check Completed lessons missing reports
SELECT l.lesson_id, l.status
FROM lessons l
LEFT JOIN lesson_reports r ON l.lesson_id = r.lesson_id
WHERE l.status = 'Completed'
  AND r.report_id IS NULL;

-- Check reports belonging to non-Completed lessons
SELECT l.lesson_id, l.status, r.report_id
FROM lessons l
JOIN lesson_reports r ON l.lesson_id = r.lesson_id
WHERE l.status <> 'Completed';

-- Check lessons and their reports
SELECT
    l.lesson_id,
    l.lesson_date,
    l.status,
    r.report_id,
    r.fee
FROM lessons l
LEFT JOIN lesson_reports r ON l.lesson_id = r.lesson_id
ORDER BY l.lesson_id;


-- ============================================================
-- T09. INSERT PAYMENTS (10 records)
-- ============================================================

INSERT INTO payments
(payment_id, lesson_id, amount, payment_date, method)
VALUES
-- L001: Fully paid
(1, 1, 500000, '2025-01-05 11:00:00', 'Cash'),

-- L002: Multiple payments (200000 + 300000)
(2, 2, 200000, '2025-01-12 16:00:00', 'BankTransfer'),
(3, 2, 300000, '2025-01-13 09:00:00', 'Card'),

-- L003: Unpaid lesson (no payment)

-- L004: Partially paid (300000 / 500000)
(4, 4, 300000, '2025-02-10 17:00:00', 'BankTransfer'),

-- L005: Fully paid
(5, 5, 500000, '2025-03-15 11:00:00', 'Cash'),

-- L006: Fully paid
(6, 6, 500000, '2025-04-10 16:00:00', 'Card'),

-- L008: Partially paid (200000 / 500000)
(7, 8, 200000, '2025-09-15 17:00:00', 'BankTransfer'),

-- L009: Fully paid
(8, 9, 500000, '2025-12-10 11:00:00', 'Cash'),

-- L010: Fully paid
(9, 10, 500000, '2024-12-15 16:00:00', 'BankTransfer'),

-- L011: Fully paid
(10, 11, 500000, '2026-01-10 12:00:00', 'Card');


-- ============================================================
-- T09. VALIDATION QUERIES
-- ============================================================

-- 1. Check total payments
SELECT COUNT(*) AS total_payments
FROM payments;

-- 2. Check payment details
SELECT
    payment_id,
    lesson_id,
    amount,
    payment_date,
    method
FROM payments
ORDER BY payment_id;

-- 3. Check total paid and outstanding balance per lesson
-- Aggregate payments before joining to avoid duplicate fees.
SELECT
    l.lesson_id,
    r.fee,
    COALESCE(p.total_paid, 0) AS total_paid,
    r.fee - COALESCE(p.total_paid, 0) AS outstanding_balance
FROM lessons l
JOIN lesson_reports r
    ON l.lesson_id = r.lesson_id
LEFT JOIN (
    SELECT lesson_id, SUM(amount) AS total_paid
    FROM payments
    GROUP BY lesson_id
) p ON l.lesson_id = p.lesson_id
ORDER BY l.lesson_id;

-- 4. Find lessons with multiple payments
SELECT
    lesson_id,
    COUNT(*) AS payment_count,
    SUM(amount) AS total_paid
FROM payments
GROUP BY lesson_id
HAVING COUNT(*) > 1;

-- 5. Find completed lessons without payments
SELECT
    l.lesson_id,
    l.student_id,
    r.fee
FROM lessons l
JOIN lesson_reports r
    ON l.lesson_id = r.lesson_id
LEFT JOIN payments p
    ON l.lesson_id = p.lesson_id
WHERE l.status = 'Completed'
  AND p.payment_id IS NULL;

-- 6. Find students who have lessons but no payments
-- Expected: Student 2 - Tran Gia Bao and Student 4 - Pham Duc Anh.
SELECT
    s.student_id,
    s.full_name
FROM students s
JOIN lessons l
    ON s.student_id = l.student_id
LEFT JOIN payments p
    ON l.lesson_id = p.lesson_id
GROUP BY s.student_id, s.full_name
HAVING COUNT(p.payment_id) = 0;

-- 7. Check payment totals do not exceed lesson fees
SELECT
    r.lesson_id,
    r.fee,
    SUM(p.amount) AS total_paid
FROM lesson_reports r
JOIN payments p
    ON r.lesson_id = p.lesson_id
GROUP BY r.lesson_id, r.fee
HAVING SUM(p.amount) > r.fee;

-- 8. Check payment dates are not earlier than lesson dates
SELECT
    p.payment_id,
    p.lesson_id,
    p.payment_date,
    l.lesson_date
FROM payments p
JOIN lessons l
    ON p.lesson_id = l.lesson_id
WHERE p.payment_date < l.lesson_date;


-- ============================================================
-- T10. FINAL VALIDATION OF SEED DATA
-- ============================================================

USE tutoring_mini;


-- ------------------------------------------------------------
-- 1. CHECK MINIMUM RECORD COUNTS
-- Expected: 5, 6, 10, 12, 10, 10
-- ------------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM subjects) AS total_subjects,
    (SELECT COUNT(*) FROM tutors) AS total_tutors,
    (SELECT COUNT(*) FROM students) AS total_students,
    (SELECT COUNT(*) FROM lessons) AS total_lessons,
    (SELECT COUNT(*) FROM lesson_reports) AS total_reports,
    (SELECT COUNT(*) FROM payments) AS total_payments;


-- ------------------------------------------------------------
-- 2. CHECK LESSON STATUS DISTRIBUTION
-- Expected: Completed 10, Pending 1, Cancelled 1
-- ------------------------------------------------------------

SELECT
    status,
    COUNT(*) AS total_lessons
FROM lessons
GROUP BY status
ORDER BY status;


-- ------------------------------------------------------------
-- 3. CHECK FOREIGN KEY INTEGRITY
-- Each query should return 0 rows.
-- ------------------------------------------------------------

-- Tutors without valid subjects
SELECT t.tutor_id
FROM tutors t
LEFT JOIN subjects s ON t.subject_id = s.subject_id
WHERE s.subject_id IS NULL;

-- Lessons without valid students
SELECT l.lesson_id
FROM lessons l
LEFT JOIN students s ON l.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Lessons without valid tutors
SELECT l.lesson_id
FROM lessons l
LEFT JOIN tutors t ON l.tutor_id = t.tutor_id
WHERE t.tutor_id IS NULL;

-- Reports without valid lessons
SELECT r.report_id
FROM lesson_reports r
LEFT JOIN lessons l ON r.lesson_id = l.lesson_id
WHERE l.lesson_id IS NULL;

-- Payments without valid lessons
SELECT p.payment_id
FROM payments p
LEFT JOIN lessons l ON p.lesson_id = l.lesson_id
WHERE l.lesson_id IS NULL;


-- ------------------------------------------------------------
-- 4. CHECK COMPLETED LESSONS MUST HAVE EXACTLY ONE REPORT
-- Expected: 0 rows
-- ------------------------------------------------------------

SELECT
    l.lesson_id,
    COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON l.lesson_id = r.lesson_id
WHERE l.status = 'Completed'
GROUP BY l.lesson_id
HAVING COUNT(r.report_id) <> 1;


-- ------------------------------------------------------------
-- 5. CHECK PENDING/CANCELLED LESSONS HAVE NO REPORT
-- Expected: 0 rows
-- ------------------------------------------------------------

SELECT
    l.lesson_id,
    l.status,
    r.report_id
FROM lessons l
JOIN lesson_reports r ON l.lesson_id = r.lesson_id
WHERE l.status IN ('Pending', 'Cancelled');


-- ------------------------------------------------------------
-- 6. CHECK PAYMENTS ONLY EXIST FOR LESSONS WITH REPORTS
-- Expected: 0 rows
-- ------------------------------------------------------------

SELECT
    p.payment_id,
    p.lesson_id
FROM payments p
LEFT JOIN lesson_reports r ON p.lesson_id = r.lesson_id
WHERE r.report_id IS NULL;


-- ------------------------------------------------------------
-- 7. CHECK TOTAL PAYMENTS DO NOT EXCEED REPORT FEE
-- Expected: 0 rows
-- ------------------------------------------------------------

SELECT
    r.lesson_id,
    r.fee,
    SUM(p.amount) AS total_paid
FROM lesson_reports r
JOIN payments p ON r.lesson_id = p.lesson_id
GROUP BY r.lesson_id, r.fee
HAVING SUM(p.amount) > r.fee;


-- ------------------------------------------------------------
-- 8. CHECK PAYMENT DATES
-- Payment date must not be earlier than lesson date.
-- Expected: 0 rows
-- ------------------------------------------------------------

SELECT
    p.payment_id,
    p.payment_date,
    l.lesson_date
FROM payments p
JOIN lessons l ON p.lesson_id = l.lesson_id
WHERE p.payment_date < l.lesson_date;


-- ------------------------------------------------------------
-- 9. CHECK STUDENT WITH MORE THAN 3 COMPLETED LESSONS IN 2025
-- Expected: Student 1 appears with 5 lessons.
-- ------------------------------------------------------------

SELECT
    s.student_id,
    s.full_name,
    COUNT(l.lesson_id) AS completed_lessons
FROM students s
JOIN lessons l ON s.student_id = l.student_id
WHERE l.status = 'Completed'
  AND l.lesson_date >= '2025-01-01'
  AND l.lesson_date < '2026-01-01'
GROUP BY s.student_id, s.full_name
HAVING COUNT(l.lesson_id) > 3;


-- ------------------------------------------------------------
-- 10. CHECK STUDENT WITH LESSONS BUT NO PAYMENTS
-- Expected: Student 2 - Tran Gia Bao and Student 4 - Pham Duc Anh.
-- ------------------------------------------------------------

SELECT
    s.student_id,
    s.full_name
FROM students s
JOIN lessons l ON s.student_id = l.student_id
LEFT JOIN payments p ON l.lesson_id = p.lesson_id
GROUP BY s.student_id, s.full_name
HAVING COUNT(p.payment_id) = 0;


-- ------------------------------------------------------------
-- 11. CHECK SUBJECT WITHOUT Q1 2025 TRANSACTIONS
-- Expected: Subject 3 - Chemistry and Subject 4 - Literature (both zero in Q1 2025).
-- ------------------------------------------------------------

SELECT
    s.subject_id,
    s.name
FROM subjects s
WHERE NOT EXISTS (
    SELECT 1
    FROM tutors t
    JOIN lessons l ON t.tutor_id = l.tutor_id
    WHERE t.subject_id = s.subject_id
      AND l.lesson_date >= '2025-01-01'
      AND l.lesson_date < '2025-04-01'
);


-- ------------------------------------------------------------
-- 12. CHECK TUTOR WITHOUT 2025 LESSONS
-- Expected: Tutor 6 - Hoang Mai Anh.
-- ------------------------------------------------------------

SELECT
    t.tutor_id,
    t.full_name
FROM tutors t
WHERE NOT EXISTS (
    SELECT 1
    FROM lessons l
    WHERE l.tutor_id = t.tutor_id
      AND l.lesson_date >= '2025-01-01'
      AND l.lesson_date < '2026-01-01'
);


-- ------------------------------------------------------------
-- 13. CHECK DATE COVERAGE
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN lesson_date >= '2025-01-01'
         AND lesson_date < '2025-02-01'
            THEN 'January 2025'
        WHEN lesson_date >= '2025-02-01'
         AND lesson_date < '2025-04-01'
            THEN 'Other months in Q1 2025'
        WHEN lesson_date >= '2025-04-01'
         AND lesson_date < '2026-01-01'
            THEN 'Outside Q1 2025'
        ELSE 'Outside 2025'
    END AS date_period,
    COUNT(*) AS total_lessons
FROM lessons
GROUP BY date_period
ORDER BY date_period;

SELECT
    (SELECT COUNT(*) FROM subjects) AS total_subjects,
    (SELECT COUNT(*) FROM tutors) AS total_tutors,
    (SELECT COUNT(*) FROM students) AS total_students,
    (SELECT COUNT(*) FROM lessons) AS total_lessons,
    (SELECT COUNT(*) FROM lesson_reports) AS total_reports,
    (SELECT COUNT(*) FROM payments) AS total_payments;
