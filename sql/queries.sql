-- ============================================================
-- GROUP 8 | ASSIGNMENT 01 | TUTORING CENTRE MANAGEMENT
-- File: queries.sql
-- Database: tutoring_mini | MySQL 8.0+
-- Part C: Ten independent queries
--
-- Execution order:
--   schema.sql -> seed.sql -> queries.sql -> views.sql
--
-- Date handling:
--   lesson_date and payment_date are DATETIME columns.
--   Use inclusive start / exclusive end boundaries.
-- ============================================================

SET NAMES utf8mb4;
USE tutoring_mini;

-- ------------------------------------------------------------
-- Query 01: Completed lessons in January 2025
-- ------------------------------------------------------------
SELECT
    l.lesson_id,
    l.lesson_date,
    l.status,
    s.student_id,
    s.full_name AS student_name,
    t.tutor_id,
    t.full_name AS tutor_name
FROM lessons AS l
JOIN students AS s
    ON s.student_id = l.student_id
JOIN tutors AS t
    ON t.tutor_id = l.tutor_id
WHERE l.status = 'Completed'
  AND l.lesson_date >= '2025-01-01'
  AND l.lesson_date <  '2025-02-01'
ORDER BY l.lesson_date, l.lesson_id;


-- ------------------------------------------------------------
-- Query 02: Number of lessons per subject in Q1 2025
--           Include all statuses and subjects with zero lessons
-- ------------------------------------------------------------
SELECT
    sb.subject_id,
    sb.name AS subject_name,
    COUNT(l.lesson_id) AS total_lessons
FROM subjects AS sb
LEFT JOIN tutors AS t
    ON t.subject_id = sb.subject_id
LEFT JOIN lessons AS l
    ON l.tutor_id = t.tutor_id
   AND l.lesson_date >= '2025-01-01'
   AND l.lesson_date <  '2025-04-01'
GROUP BY sb.subject_id, sb.name
ORDER BY sb.subject_id;


-- ------------------------------------------------------------
-- Query 03: Students with at least one lesson without a report,
--           excluding Cancelled lessons. Each student appears once.
-- ------------------------------------------------------------
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students AS s
WHERE EXISTS (
    SELECT 1
    FROM lessons AS l
    LEFT JOIN lesson_reports AS r
        ON r.lesson_id = l.lesson_id
    WHERE l.student_id = s.student_id
      AND l.status <> 'Cancelled'
      AND r.report_id IS NULL
)
ORDER BY s.student_id;


-- ------------------------------------------------------------
-- Query 04: Average fee per Completed lesson by subject
--           across all time; include only subjects with fees
-- ------------------------------------------------------------
SELECT
    sb.subject_id,
    sb.name AS subject_name,
    ROUND(AVG(r.fee), 2) AS avg_fee
FROM subjects AS sb
JOIN tutors AS t
    ON t.subject_id = sb.subject_id
JOIN lessons AS l
    ON l.tutor_id = t.tutor_id
   AND l.status = 'Completed'
JOIN lesson_reports AS r
    ON r.lesson_id = l.lesson_id
GROUP BY sb.subject_id, sb.name
ORDER BY sb.subject_id;


-- ------------------------------------------------------------
-- Query 05: Top 3 tutors by Completed lessons in 2025
--           Break ties by tutor_id ascending; exclude tutors
--           with no Completed lessons in the period
-- ------------------------------------------------------------
SELECT
    t.tutor_id,
    t.full_name AS tutor_name,
    COUNT(*) AS completed_lessons
FROM tutors AS t
JOIN lessons AS l
    ON l.tutor_id = t.tutor_id
   AND l.status = 'Completed'
   AND l.lesson_date >= '2025-01-01'
   AND l.lesson_date <  '2026-01-01'
GROUP BY t.tutor_id, t.full_name
ORDER BY completed_lessons DESC, t.tutor_id ASC
LIMIT 3;


-- ------------------------------------------------------------
-- Query 06: Total amount paid by each student in 2025,
--           based on payment_date; retain students with zero
-- ------------------------------------------------------------
SELECT
    s.student_id,
    s.full_name AS student_name,
    COALESCE(SUM(p.amount), 0) AS total_paid_2025
FROM students AS s
LEFT JOIN lessons AS l
    ON l.student_id = s.student_id
LEFT JOIN payments AS p
    ON p.lesson_id = l.lesson_id
   AND p.payment_date >= '2025-01-01'
   AND p.payment_date <  '2026-01-01'
GROUP BY s.student_id, s.full_name
ORDER BY s.student_id;


-- ------------------------------------------------------------
-- Query 07: Students with no payment record across all time,
--           including students who have no lessons
-- ------------------------------------------------------------
SELECT
    s.student_id,
    s.full_name AS student_name
FROM students AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM lessons AS l
    JOIN payments AS p
        ON p.lesson_id = l.lesson_id
    WHERE l.student_id = s.student_id
)
ORDER BY s.student_id;


-- ------------------------------------------------------------
-- Query 08: All students by total confirmed fee, descending.
--           Payment status is irrelevant; ties by student_id.
-- ------------------------------------------------------------
SELECT
    s.student_id,
    s.full_name AS student_name,
    COALESCE(SUM(r.fee), 0) AS total_confirmed_fee
FROM students AS s
LEFT JOIN lessons AS l
    ON l.student_id = s.student_id
LEFT JOIN lesson_reports AS r
    ON r.lesson_id = l.lesson_id
GROUP BY s.student_id, s.full_name
ORDER BY total_confirmed_fee DESC, s.student_id ASC;


-- ------------------------------------------------------------
-- Query 09: Cancellation rate per tutor in 2025.
--           Rate = Cancelled / all lessons * 100, rounded to
--           2 decimals; NULL if the tutor has no lesson in 2025.
-- ------------------------------------------------------------
SELECT
    t.tutor_id,
    t.full_name AS tutor_name,
    COUNT(l.lesson_id) AS total_lessons,
    SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_lessons,
    ROUND(
        100 * SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(l.lesson_id), 0),
        2
    ) AS cancel_rate_pct
FROM tutors AS t
LEFT JOIN lessons AS l
    ON l.tutor_id = t.tutor_id
   AND l.lesson_date >= '2025-01-01'
   AND l.lesson_date <  '2026-01-01'
GROUP BY t.tutor_id, t.full_name
ORDER BY t.tutor_id;


-- ------------------------------------------------------------
-- Query 10: Students with more than 3 Completed lessons in 2025
-- ------------------------------------------------------------
SELECT
    s.student_id,
    s.full_name AS student_name,
    COUNT(*) AS completed_lessons
FROM students AS s
JOIN lessons AS l
    ON l.student_id = s.student_id
   AND l.status = 'Completed'
   AND l.lesson_date >= '2025-01-01'
   AND l.lesson_date <  '2026-01-01'
GROUP BY s.student_id, s.full_name
HAVING COUNT(*) > 3
ORDER BY completed_lessons DESC, s.student_id ASC;
