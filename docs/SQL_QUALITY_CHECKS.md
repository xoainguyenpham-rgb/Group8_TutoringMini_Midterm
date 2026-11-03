# SQL quality checks

Run these checks after loading the approved `schema.sql` and `seed.sql` in MySQL.

## Required counts
```sql
USE tutoring_mini;
SELECT 'subjects' AS table_name, COUNT(*) AS row_count FROM subjects
UNION ALL SELECT 'tutors', COUNT(*) FROM tutors
UNION ALL SELECT 'students', COUNT(*) FROM students
UNION ALL SELECT 'lessons', COUNT(*) FROM lessons
UNION ALL SELECT 'lesson_reports', COUNT(*) FROM lesson_reports
UNION ALL SELECT 'payments', COUNT(*) FROM payments;
```
Minimum counts in table order: 5, 6, 10, 12, 10, 10.

## Completed lessons without exactly one report, or non-Completed lessons with a report
```sql
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
HAVING (l.status = 'Completed' AND COUNT(r.report_id) <> 1)
    OR (l.status <> 'Completed' AND COUNT(r.report_id) <> 0);
```
Expected: zero violating rows.

## Invalid payment / aggregate overpayment
```sql
SELECT p.payment_id, p.lesson_id
FROM payments p
JOIN lessons l ON l.lesson_id = p.lesson_id
LEFT JOIN lesson_reports r ON r.lesson_id = p.lesson_id
WHERE l.status <> 'Completed' OR r.report_id IS NULL;

SELECT r.lesson_id, r.fee, COALESCE(SUM(p.amount),0) AS total_paid
FROM lesson_reports r
LEFT JOIN payments p ON p.lesson_id = r.lesson_id
GROUP BY r.lesson_id, r.fee
HAVING COALESCE(SUM(p.amount),0) > r.fee;
```
Expected: zero violating rows for both. Payment must follow confirmed fee; the current report schema does not record a report timestamp, so chronological proof requires additional evidence.

## Avoid fee double counting
Do not calculate total fees from a flat JOIN of `lesson_reports` and `payments`: a lesson may have multiple payments. Aggregate the payments separately before calculating remaining debt.
