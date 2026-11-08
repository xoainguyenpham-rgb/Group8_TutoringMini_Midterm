-- ------------------------------------------------------------
-- 1) v_detail: one row per lesson
--    Base table: lessons (row count = lessons).
--    INNER JOIN students / tutors / subjects: FKs are NOT NULL,
--    so no lesson is lost. Subject is taken from the tutor.
--    LEFT JOIN lesson_reports: lessons without a report
--    (Pending / Cancelled) are kept with fee = NULL.
--    payments is NOT joined, so a lesson paid several times
--    is still one row.
-- ------------------------------------------------------------
USE tutoring_mini;

CREATE OR REPLACE VIEW v_detail AS
SELECT
    l.lesson_id,
    l.lesson_date,
    l.status,
    st.student_id,
    st.full_name  AS student_name,
    t.tutor_id,
    t.full_name   AS tutor_name,
    sb.subject_id,
    sb.name       AS subject_name,
    r.fee
FROM lessons l
JOIN students       st ON st.student_id = l.student_id
JOIN tutors         t  ON t.tutor_id    = l.tutor_id
JOIN subjects       sb ON sb.subject_id = t.subject_id
LEFT JOIN lesson_reports r ON r.lesson_id = l.lesson_id;
 
-- ------------------------------------------------------------
-- 2) v_group_summary: one row per subject
--    Base table: subjects + LEFT JOIN tutors -> lessons ->
--    lesson_reports, so subjects without lessons are kept.
--    COUNT(l.lesson_id) ignores NULL -> 0 for empty subjects.
--    SUM(CASE ... ELSE 0) and COALESCE return 0, not NULL.
--    UNIQUE(lesson_reports.lesson_id) prevents row duplication;
--    payments is not used.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_group_summary AS
SELECT
    sb.subject_id,
    sb.name                                                 AS subject_name,
    COUNT(l.lesson_id)                                      AS total_lessons,
    SUM(CASE WHEN l.status = 'Completed' THEN 1 ELSE 0 END) AS completed_lessons,
    SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_lessons,
    COALESCE(SUM(r.fee), 0)                                 AS total_fee
FROM subjects sb
LEFT JOIN tutors         t ON t.subject_id = sb.subject_id
LEFT JOIN lessons        l ON l.tutor_id   = t.tutor_id
LEFT JOIN lesson_reports r ON r.lesson_id  = l.lesson_id
GROUP BY sb.subject_id, sb.name;
 
-- ------------------------------------------------------------
-- 3) v_debt: one row per student
--    Confirmed fees and actual payments are aggregated in two
--    SEPARATE subqueries (both GROUP BY student_id) and then
--    LEFT JOINed to students. This avoids double counting the
--    fee when one lesson has several payments.
--    debt = total confirmed fee - total amount paid.
--    Students with no fee or no payment are kept with 0.
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_debt AS
SELECT
    st.student_id,
    st.full_name                                         AS student_name,
    COALESCE(f.total_fee, 0)                             AS total_fee,
    COALESCE(p.total_paid, 0)                            AS total_paid,
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
 
USE tutoring_mini;
SELECT * FROM v_detail        ORDER BY lesson_id;
SELECT * FROM v_group_summary ORDER BY subject_id;
SELECT * FROM v_debt          ORDER BY student_id;