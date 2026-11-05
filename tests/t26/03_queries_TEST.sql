-- T26 TEST COPY ONLY; never run against original tutoring_mini
-- This candidate source may be awaiting final team review.
-- GROUP 08 / DE 01 - queries.sql (CANDIDATE)
-- Transcribed from the final consolidated section (pages 9-12) of [KHANH-CSDL] Queries.pdf.
-- Reviewer sign-off of the exact .sql file is pending; logic has not been re-run in MySQL.
USE tutoring_mini_t26_20261105;

-- Query 01: Completed lessons in January 2025
SELECT l.lesson_id, l.lesson_date, l.status,
       s.student_id, s.full_name AS student_name,
       t.tutor_id, t.full_name AS tutor_name
FROM lessons l
JOIN students s ON s.student_id = l.student_id
JOIN tutors t ON t.tutor_id = l.tutor_id
WHERE l.status = 'Completed'
  AND l.lesson_date >= '2025-01-01'
  AND l.lesson_date < '2025-02-01'
ORDER BY l.lesson_date, l.lesson_id;

-- Query 02: Lesson count per subject, Q1 2025, including zero counts
SELECT sb.subject_id, sb.name AS subject_name,
       COUNT(l.lesson_id) AS total_lessons
FROM subjects sb
LEFT JOIN tutors t ON t.subject_id = sb.subject_id
LEFT JOIN lessons l ON l.tutor_id = t.tutor_id
                   AND l.lesson_date >= '2025-01-01'
                   AND l.lesson_date < '2025-04-01'
GROUP BY sb.subject_id, sb.name
ORDER BY sb.subject_id;

-- Query 03: Students with a non-Cancelled lesson lacking a report
-- The brief excludes Cancelled, so Pending IS included. Do not change to status='Completed' without revising the brief.
SELECT s.student_id, s.full_name AS student_name
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM lessons l
    LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
    WHERE l.student_id = s.student_id
      AND l.status <> 'Cancelled'
      AND r.report_id IS NULL
)
ORDER BY s.student_id;

-- Query 04: Average confirmed fee per Completed lesson, by subject, all dates
SELECT sb.subject_id, sb.name AS subject_name,
       ROUND(AVG(r.fee), 2) AS avg_fee
FROM subjects sb
JOIN tutors t ON t.subject_id = sb.subject_id
JOIN lessons l ON l.tutor_id = t.tutor_id AND l.status = 'Completed'
JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY sb.subject_id, sb.name
ORDER BY sb.subject_id;

-- Query 05: Top 3 tutors by Completed lessons in 2025, tie-break on tutor_id
SELECT t.tutor_id, t.full_name AS tutor_name,
       COUNT(*) AS completed_lessons
FROM tutors t
JOIN lessons l ON l.tutor_id = t.tutor_id
              AND l.status = 'Completed'
              AND l.lesson_date >= '2025-01-01'
              AND l.lesson_date < '2026-01-01'
GROUP BY t.tutor_id, t.full_name
ORDER BY completed_lessons DESC, t.tutor_id ASC
LIMIT 3;

-- Query 06: Total amount paid per student during 2025 by payment_date (include zeros)
SELECT s.student_id, s.full_name AS student_name,
       COALESCE(SUM(p.amount), 0) AS total_paid_2025
FROM students s
LEFT JOIN lessons l ON l.student_id = s.student_id
LEFT JOIN payments p ON p.lesson_id = l.lesson_id
                    AND p.payment_date >= '2025-01-01'
                    AND p.payment_date < '2026-01-01'
GROUP BY s.student_id, s.full_name
ORDER BY s.student_id;

-- Query 07: Students who have never had a payment, including students without lessons
SELECT s.student_id, s.full_name AS student_name
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM lessons l
    JOIN payments p ON p.lesson_id = l.lesson_id
    WHERE l.student_id = s.student_id
)
ORDER BY s.student_id;

-- Query 08: Students sorted by all-time confirmed fee (not payments)
SELECT s.student_id, s.full_name AS student_name,
       COALESCE(SUM(r.fee), 0) AS total_confirmed_fee
FROM students s
LEFT JOIN lessons l ON l.student_id = s.student_id
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY s.student_id, s.full_name
ORDER BY total_confirmed_fee DESC, s.student_id ASC;

-- Query 09: Tutor cancellation rate (%) during 2025; NULL if no lessons
SELECT t.tutor_id, t.full_name AS tutor_name,
       COUNT(l.lesson_id) AS total_lessons,
       SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_lessons,
       ROUND(100 * SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END)
             / NULLIF(COUNT(l.lesson_id), 0), 2) AS cancel_rate_pct
FROM tutors t
LEFT JOIN lessons l ON l.tutor_id = t.tutor_id
                   AND l.lesson_date >= '2025-01-01'
                   AND l.lesson_date < '2026-01-01'
GROUP BY t.tutor_id, t.full_name
ORDER BY t.tutor_id;

-- Query 10: Students with more than 3 Completed lessons in 2025
SELECT s.student_id, s.full_name AS student_name,
       COUNT(*) AS completed_lessons
FROM students s
JOIN lessons l ON l.student_id = s.student_id
              AND l.status = 'Completed'
              AND l.lesson_date >= '2025-01-01'
              AND l.lesson_date < '2026-01-01'
GROUP BY s.student_id, s.full_name
HAVING COUNT(*) > 3
ORDER BY completed_lessons DESC, s.student_id ASC;