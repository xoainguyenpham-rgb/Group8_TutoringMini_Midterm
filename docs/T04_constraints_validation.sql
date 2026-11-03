-- =============================================================
-- GROUP 08 | TOPIC 01 | T04: CONSTRAINT VALIDATION
-- Safe read-only checks. Run AFTER schema.sql and seed.sql.
-- MySQL 8.0.16+; does not change tables or data.
-- =============================================================
USE tutoring_mini;

-- 01. STRUCTURAL EVIDENCE (inspect actual DDL)
-- Expect:
--   uq_lesson_reports_lesson UNIQUE (lesson_id)
--   chk_reports_duration CHECK (duration_minutes > 0)
--   chk_reports_fee CHECK (fee >= 0)
--   lessons.status ENUM('Pending','Completed','Cancelled')
SHOW CREATE TABLE lesson_reports;
SHOW CREATE TABLE lessons;
SHOW CREATE TABLE payments;

-- 02. CONSTRAINT DECLARATIONS (table-level evidence)
SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_schema = DATABASE()
  AND (
       (table_name = 'lesson_reports'
        AND constraint_name IN ('uq_lesson_reports_lesson',
                                'chk_reports_duration', 'chk_reports_fee'))
       OR (table_name = 'payments'
        AND constraint_name = 'chk_payments_amount')
      )
ORDER BY table_name, constraint_name;

-- 03. ACTUAL DATA VIOLATIONS: all counters must be 0.
-- A SELECT checking existing rows does NOT prove that a constraint
-- is enforced on future INSERT/UPDATE; inspect the DDL above as well.
SELECT '01_duplicate_reports_per_lesson' AS check_name, COUNT(*) AS violations
FROM (
    SELECT lesson_id FROM lesson_reports
    GROUP BY lesson_id HAVING COUNT(*) > 1
) AS duplicates

UNION ALL
SELECT '02_invalid_report_duration', COUNT(*)
FROM lesson_reports
WHERE duration_minutes IS NULL OR duration_minutes <= 0

UNION ALL
SELECT '03_negative_or_null_fee', COUNT(*)
FROM lesson_reports
WHERE fee IS NULL OR fee < 0

UNION ALL
SELECT '04_completed_without_report', COUNT(*)
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
WHERE l.status = 'Completed' AND r.report_id IS NULL

UNION ALL
SELECT '05_report_on_pending_or_cancelled', COUNT(*)
FROM lesson_reports r
JOIN lessons l ON l.lesson_id = r.lesson_id
WHERE l.status <> 'Completed'

UNION ALL
SELECT '06_payment_without_confirmed_report', COUNT(*)
FROM payments p
JOIN lessons l ON l.lesson_id = p.lesson_id
LEFT JOIN lesson_reports r ON r.lesson_id = p.lesson_id
WHERE l.status <> 'Completed' OR r.report_id IS NULL

UNION ALL
SELECT '07_overpayment', COUNT(*)
FROM (
    SELECT r.lesson_id, r.fee
    FROM lesson_reports r
    LEFT JOIN payments p ON p.lesson_id = r.lesson_id
    GROUP BY r.lesson_id, r.fee
    HAVING COALESCE(SUM(p.amount), 0) > r.fee
) AS overpaid;

-- 04. DETAILED BUSINESS-RULE CHECK FOR REPORT STATUS
-- EXPECTED RESULT: EMPTY (0 ROWS).
-- Completed -> exactly one report; Pending / Cancelled -> none.
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
HAVING (l.status = 'Completed' AND COUNT(r.report_id) <> 1)
    OR (l.status <> 'Completed' AND COUNT(r.report_id) <> 0);

-- 05. VALIDATION OF FOREIGN KEYS RELATED TO REPORTS
-- EXPECTED RESULT: EMPTY (0 ROWS).
SELECT r.report_id, r.lesson_id
FROM lesson_reports r
LEFT JOIN lessons l ON l.lesson_id = r.lesson_id
WHERE l.lesson_id IS NULL;

-- 06. TRANSPARENT SNAPSHOT OF ALL LESSONS / REPORT COUNTS
-- EXPECTED: Completed=1, Pending=0, Cancelled=0 for every row.
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
ORDER BY l.lesson_id;

-- 07. EXPLANATION: cross-table / aggregate rules must not be
-- incorrectly modeled using a MySQL CHECK reading another table.
-- This script uses SELECT; no triggers or stored procedures needed.
