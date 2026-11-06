-- =============================================================
-- GROUP 08 | TOPIC 01 | T04: CONSTRAINTS & CROSS-TABLE VALIDATION
-- Revision after Nhat Linh review (06 Nov 2026)
-- READ ONLY: no INSERT, UPDATE, DELETE, DROP or TRUNCATE.
-- Execute AFTER schema.sql and seed.sql in the SAME target database.
-- =============================================================

-- Run on the isolated T26 test DB. Never assume the MySQL Workbench
-- sidebar's selected schema overrides an explicit USE statement.
USE tutoring_mini_t26_20261105_v2;
SELECT DATABASE() AS active_database, VERSION() AS mysql_version;

-- A. SINGLE-TABLE CONSTRAINTS: INSPECT DDL (NOT cross-table checks)
-- UNIQUE lesson_reports.lesson_id, CHECK duration_minutes > 0,
-- CHECK fee >= 0, CHECK payments.amount > 0, and status ENUM
-- are schema-level constraints; they are NOT counted as
-- cross-table business-rule validation rows.
SHOW CREATE TABLE lesson_reports;
SHOW CREATE TABLE lessons;
SHOW CREATE TABLE payments;

SELECT table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_schema = DATABASE()
  AND (
      (table_name = 'lesson_reports' AND constraint_name IN
           ('uq_lesson_reports_lesson','chk_reports_duration','chk_reports_fee'))
      OR (table_name = 'payments' AND constraint_name = 'chk_payments_amount')
  )
ORDER BY table_name, constraint_name;

-- B. CROSS-TABLE / AGGREGATE RULES: each violations value MUST be 0.
-- 01: Every Completed lesson has EXACTLY one report.
--     (The "at most one" portion is already protected by UNIQUE.)
SELECT '01_completed_report_count_not_one' AS check_name,
       COUNT(*) AS violations
FROM (
    SELECT l.lesson_id
    FROM lessons l
    LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
    WHERE l.status = 'Completed'
    GROUP BY l.lesson_id
    HAVING COUNT(r.report_id) <> 1
) invalid_completed

UNION ALL
-- 02: Pending/Cancelled lessons have no reports.
SELECT '02_report_on_noncompleted', COUNT(*)
FROM lesson_reports r
JOIN lessons l ON l.lesson_id = r.lesson_id
WHERE l.status IN ('Pending', 'Cancelled')

UNION ALL
-- 03: Payments require a Completed lesson AND a confirmed report.
SELECT '03_payment_without_completed_report', COUNT(*)
FROM payments p
JOIN lessons l ON l.lesson_id = p.lesson_id
LEFT JOIN lesson_reports r ON r.lesson_id = p.lesson_id
WHERE l.status <> 'Completed' OR r.report_id IS NULL

UNION ALL
-- 04: Total paid per lesson cannot exceed its confirmed fee.
-- Aggregate payments per lesson; do NOT repeat fees per payment.
SELECT '04_overpayment', COUNT(*)
FROM (
    SELECT r.lesson_id
    FROM lesson_reports r
    LEFT JOIN payments p ON p.lesson_id = r.lesson_id
    GROUP BY r.lesson_id, r.fee
    HAVING COALESCE(SUM(p.amount), 0) > r.fee
) overpaid

UNION ALL
-- 05: No payment may have a date earlier than its lesson date.
SELECT '05_payment_before_lesson', COUNT(*)
FROM payments p
JOIN lessons l ON l.lesson_id = p.lesson_id
WHERE p.payment_date < l.lesson_date;

-- C. DETAIL LISTS: both SELECTs must return NO ROWS.
-- Status <-> report check, including the count for each lesson.
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
HAVING (l.status = 'Completed' AND COUNT(r.report_id) <> 1)
    OR (l.status <> 'Completed' AND COUNT(r.report_id) <> 0);

-- New review-requested date validation with offending rows.
SELECT p.payment_id, p.lesson_id, l.lesson_date, p.payment_date
FROM payments p
JOIN lessons l ON l.lesson_id = p.lesson_id
WHERE p.payment_date < l.lesson_date
ORDER BY p.payment_id;

-- D. STATUS/REPORT SNAPSHOT: Completed=1; Pending/Cancelled=0.
SELECT l.lesson_id, l.status, COUNT(r.report_id) AS report_count
FROM lessons l
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY l.lesson_id, l.status
ORDER BY l.lesson_id;

-- IMPORTANT: These queries validate the EXISTING test dataset.
-- Cross-table CHECK constraints cannot refer to another table
-- in MySQL, so use SELECT to validate these business rules.
-- Do not claim that read-only SELECTs enforce future transactions.
