-- T26 TEST COPY ONLY; never run against original tutoring_mini
-- This candidate source may be awaiting final team review.
-- ============================================================
-- GROUP 8 | DE 01 | QUAN LY TRUNG TAM GIA SU
-- File: schema.sql
-- Database: tutoring_mini_t26_20261105 | MySQL (8.0.16+)
-- NOTE: Run on a CLEAN database; no DROP statements are included.
-- SQL execution order: schema.sql -> seed.sql -> queries.sql -> views.sql
-- ============================================================

CREATE DATABASE tutoring_mini_t26_20261105
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE tutoring_mini_t26_20261105;

-- 1. SUBJECTS: each subject may have many tutors.
CREATE TABLE subjects (
    subject_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_subjects_name UNIQUE (name)
) ENGINE = InnoDB;

-- 2. TUTORS: each tutor belongs to exactly one subject.
CREATE TABLE tutors (
    tutor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NULL,
    qualification VARCHAR(200) NULL,
    subject_id INT UNSIGNED NOT NULL,

    CONSTRAINT uq_tutors_email UNIQUE (email),
    CONSTRAINT fk_tutors_subject
        FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 3. STUDENTS: a student may attend many lessons.
CREATE TABLE students (
    student_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    dob DATE NULL,
    phone VARCHAR(20) NULL
) ENGINE = InnoDB;

-- 4. LESSONS: one student and one tutor per lesson.
CREATE TABLE lessons (
    lesson_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNSIGNED NOT NULL,
    tutor_id INT UNSIGNED NOT NULL,
    lesson_date DATETIME NOT NULL,
    status ENUM('Pending', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending',

    INDEX ix_lessons_date (lesson_date),
    INDEX ix_lessons_status_date (status, lesson_date),
    CONSTRAINT fk_lessons_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lessons_tutor
        FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 5. LESSON_REPORTS: 0..1 report per lesson (UNIQUE lesson_id).
-- Business rule: Completed must have exactly one report;
-- Pending/Cancelled must have none. Check in seed.sql (cross-table rule).
CREATE TABLE lesson_reports (
    report_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT UNSIGNED NOT NULL,
    content TEXT NOT NULL,
    feedback TEXT NULL,
    duration_minutes INT UNSIGNED NOT NULL,
    fee DECIMAL(12, 2) NOT NULL,

    CONSTRAINT uq_lesson_reports_lesson UNIQUE (lesson_id),
    CONSTRAINT chk_reports_duration CHECK (duration_minutes > 0),
    CONSTRAINT chk_reports_fee CHECK (fee >= 0),
    CONSTRAINT fk_reports_lesson
        FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 6. PAYMENTS: a lesson can receive multiple actual payments.
-- Business rule: payments only after a confirmed report exists,
-- and SUM(payments.amount) <= lesson_reports.fee.
-- Check in seed.sql (cross-table / aggregation rules).
CREATE TABLE payments (
    payment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT UNSIGNED NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_date DATETIME NOT NULL,
    method ENUM('Cash', 'BankTransfer', 'Card') NOT NULL,

    INDEX ix_payments_date (payment_date),
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT fk_payments_lesson
        FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Ready for seed.sql.
-- All six tables are created in parent-before-child order.