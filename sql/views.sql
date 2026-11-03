-- GROUP 08 / DE 01 - views.sql (CANDIDATE)
-- Assembled from [CSDL] Nhat Linh.pdf pages 17-20.
-- Requires final peer review and execution in MySQL Workbench.
USE tutoring_mini;

-- View 1: one row per lesson (fee NULL for lessons without a report)
CREATE OR REPLACE VIEW v_detail AS
SELECT l.lesson_id, l.lesson_date, l.status,
       st.student_id, st.full_name AS student_name,
       t.tutor_id, t.full_name AS tutor_name,
       sb.subject_id, sb.name AS subject_name,
       r.fee
FROM lessons l
JOIN students st ON st.student_id = l.student_id
JOIN tutors t ON t.tutor_id = l.tutor_id
JOIN subjects sb ON sb.subject_id = t.subject_id
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id;

-- View 2: one row per subject, including those without lessons
CREATE OR REPLACE VIEW v_group_summary AS
SELECT sb.subject_id, sb.name AS subject_name,
       COUNT(l.lesson_id) AS total_lessons,
       SUM(CASE WHEN l.status = 'Completed' THEN 1 ELSE 0 END) AS completed_lessons,
       SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_lessons,
       COALESCE(SUM(r.fee), 0) AS total_fee
FROM subjects sb
LEFT JOIN tutors t ON t.subject_id = sb.subject_id
LEFT JOIN lessons l ON l.tutor_id = t.tutor_id
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id
GROUP BY sb.subject_id, sb.name;

-- View 3: one row per student, pre-aggregate fees and payments separately
CREATE OR REPLACE VIEW v_debt AS
SELECT st.student_id, st.full_name AS student_name,
       COALESCE(f.total_fee, 0) AS total_fee,
       COALESCE(p.total_paid, 0) AS total_paid,
       COALESCE(f.total_fee, 0) - COALESCE(p.total_paid, 0) AS debt
FROM students st
LEFT JOIN (
    SELECT l.student_id, SUM(r.fee) AS total_fee
    FROM lessons l
    JOIN lesson_reports r ON r.lesson_id = l.lesson_id
    GROUP BY l.student_id
) f ON f.student_id = st.student_id
LEFT JOIN (
    SELECT l.student_id, SUM(pm.amount) AS total_paid
    FROM lessons l
    JOIN payments pm ON pm.lesson_id = l.lesson_id
    GROUP BY l.student_id
) p ON p.student_id = st.student_id;

-- Smoke test: row counts should match base tables after running all 3 views.
SELECT 'v_detail' AS view_name, COUNT(*) AS actual_rows FROM v_detail
UNION ALL SELECT 'v_group_summary', COUNT(*) FROM v_group_summary
UNION ALL SELECT 'v_debt', COUNT(*) FROM v_debt;