-- T26 isolated test DB validation, READ ONLY
USE tutoring_mini_t26_20261105;

SELECT VERSION() AS mysql_version, DATABASE() AS active_database;

-- Required row counts; expected 5/6/10/12/10/10 for this current dataset.
SELECT 'subjects' AS table_name, COUNT(*) AS actual_rows, 5 AS min_rows FROM subjects
UNION ALL SELECT 'tutors', COUNT(*), 6 FROM tutors
UNION ALL SELECT 'students', COUNT(*), 10 FROM students
UNION ALL SELECT 'lessons', COUNT(*), 12 FROM lessons
UNION ALL SELECT 'lesson_reports', COUNT(*), 10 FROM lesson_reports
UNION ALL SELECT 'payments', COUNT(*), 10 FROM payments;

SELECT status, COUNT(*) AS lesson_count FROM lessons GROUP BY status;
SHOW CREATE TABLE lesson_reports;
SHOW CREATE TABLE lessons;
SHOW CREATE TABLE payments;

-- All seven violation counts must be ZERO.
SELECT 'duplicate_reports' AS test_case, COUNT(*) AS violations
FROM (SELECT lesson_id FROM lesson_reports GROUP BY lesson_id HAVING COUNT(*)>1) x
UNION ALL
SELECT 'invalid_duration_or_fee', COUNT(*)
FROM lesson_reports WHERE duration_minutes<=0 OR fee<0 OR duration_minutes IS NULL OR fee IS NULL
UNION ALL
SELECT 'completed_without_report', COUNT(*)
FROM lessons l LEFT JOIN lesson_reports r ON r.lesson_id=l.lesson_id
WHERE l.status='Completed' AND r.report_id IS NULL
UNION ALL
SELECT 'report_on_noncompleted', COUNT(*)
FROM lessons l JOIN lesson_reports r ON r.lesson_id=l.lesson_id
WHERE l.status<>'Completed'
UNION ALL
SELECT 'payment_without_report', COUNT(*)
FROM payments p JOIN lessons l ON l.lesson_id=p.lesson_id
LEFT JOIN lesson_reports r ON r.lesson_id=p.lesson_id
WHERE l.status<>'Completed' OR r.report_id IS NULL
UNION ALL
SELECT 'overpayment', COUNT(*)
FROM (
 SELECT r.lesson_id FROM lesson_reports r LEFT JOIN payments p ON p.lesson_id=r.lesson_id
 GROUP BY r.lesson_id,r.fee HAVING COALESCE(SUM(p.amount),0)>r.fee
) x
UNION ALL
SELECT 'invalid_payment_amount', COUNT(*)
FROM payments WHERE amount<=0 OR amount IS NULL;

-- Views should count 12 / 5 / 10.
SELECT 'v_detail' AS view_name, COUNT(*) AS actual, (SELECT COUNT(*) FROM lessons) AS expected FROM v_detail
UNION ALL SELECT 'v_group_summary', COUNT(*), (SELECT COUNT(*) FROM subjects) FROM v_group_summary
UNION ALL SELECT 'v_debt', COUNT(*), (SELECT COUNT(*) FROM students) FROM v_debt;

-- Independent fee / payment / debt totals should match view.
SELECT 'fee' AS metric, (SELECT SUM(fee) FROM lesson_reports) AS original_sum, (SELECT SUM(total_fee) FROM v_debt) AS view_sum
UNION ALL
SELECT 'paid', (SELECT SUM(amount) FROM payments), (SELECT SUM(total_paid) FROM v_debt)
UNION ALL
SELECT 'debt', (SELECT SUM(fee) FROM lesson_reports) - (SELECT SUM(amount) FROM payments), (SELECT SUM(debt) FROM v_debt);

-- Partial-payment example
SELECT r.lesson_id, r.fee, COALESCE(SUM(p.amount),0) AS paid,
r.fee-COALESCE(SUM(p.amount),0) AS debt
FROM lesson_reports r LEFT JOIN payments p ON p.lesson_id=r.lesson_id
WHERE r.lesson_id=2
GROUP BY r.lesson_id,r.fee;

-- QA coverage gaps in candidate seed (not necessarily implementation errors).
SELECT
  (SELECT COUNT(*) FROM lessons WHERE status='Cancelled'
   AND lesson_date>='2025-01-01' AND lesson_date<'2026-01-01') AS cancelled_in_2025,
  (SELECT COUNT(*) FROM subjects sb WHERE NOT EXISTS
   (SELECT 1 FROM tutors t JOIN lessons l ON l.tutor_id=t.tutor_id
    WHERE t.subject_id=sb.subject_id)) AS subjects_without_any_lessons;
