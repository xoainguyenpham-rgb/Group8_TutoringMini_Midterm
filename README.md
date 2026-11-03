# Group 08 — Midterm Project | Topic 01: Tutoring Center Management

**Course:** Database Management in Business  
**Project:** Tutoring Mini (`tutoring_mini`)  
**Database:** MySQL  
**Institution:** National Economics University (NEU) — AEP  
**Project type:** Relational database design, SQL querying, and reporting views

> **Integration status (02 Nov 2026):** Repository structure and `sql/schema.sql` are available. The team-reviewed `seed.sql`, `queries.sql`, `views.sql`, and final PDF report will be uploaded after approval. The complete four-file execution has **not yet been verified**. This notice must be updated before submission.

## 1. Project overview

The project implements a relational database for an individual tutoring center. Each tutor belongs to one principal subject; each lesson involves exactly one tutor and one student. The database records lesson scheduling and status, at most one lesson report per lesson, and potentially multiple payments for a confirmed fee.

The scope covers six tables:

| Table | Purpose | Key relationships |
|---|---|---|
| `subjects` | Subjects offered by the center | 1 subject → many tutors |
| `tutors` | Tutors and their principal subjects | `subject_id` → `subjects.subject_id` |
| `students` | Student information | 1 student → many lessons |
| `lessons` | Individual sessions and their status | `student_id` → `students`; `tutor_id` → `tutors` |
| `lesson_reports` | Results, duration and confirmed lesson fee | `lesson_id` → `lessons`, `UNIQUE` |
| `payments` | Individual payment transactions | `lesson_id` → `lessons`; multiple payments allowed |

### Database design

**Chen-style ERD**  
[View the ERD diagram (GitHub Mermaid)](diagrams/ERD.md). The editable ERDPlus source is in `diagrams/ERD_Source.erdplus`.

**Relational schema**  
![Relational schema and data types](diagrams/Relational_Schema.png)

Source diagram files are also available under `diagrams/` for future edits.

## 2. Submission structure

```text
Group8_TutoringMini_Midterm/
├── README.md                         # Main project documentation
├── .gitignore                        # Keeps local secrets/temp files out of Git
├── sql/
│   ├── schema.sql                    # Available: database + six tables
│   ├── seed.sql                      # TO ADD: approved sample data + validation
│   ├── queries.sql                   # TO ADD: 10 independent numbered queries
│   ├── views.sql                     # TO ADD: three required views
│   └── README.md                     # SQL file status and handoff rules
├── diagrams/
│   ├── ERD.md
│   ├── Relational_Schema.svg
│   ├── ERD_Source.erdplus
│   └── Relational_Schema_Source.drawio
├── report/
│   ├── README.md                     # PDF handoff instructions
│   └── Group08_TutoringMini_Report.pdf   # TO ADD: final report
└── docs/
    ├── TEAM_GUIDE_VI.md             # Repository setup/upload guide (Vietnamese)
    ├── INTEGRATION_STATUS.md             # Release status and known review items
    ├── SQL_QUALITY_CHECKS.md         # Manual SQL validation and tricky query semantics
    ├── T05_HANDOFF_AND_RELEASE.md    # T05 deliverables and release signoff
    └── SUBMISSION_CHECKLIST.md       # Final release review
```

**Required SQL filenames are exactly:** `schema.sql`, `seed.sql`, `queries.sql`, and `views.sql` (inside `sql/`). Files marked **TO ADD** are not included yet; do not confuse this scaffold with a completed submission.

## 3. Prerequisites

- A running **MySQL Community Server**. The provided schema uses `CHECK` constraints and `utf8mb4_0900_ai_ci`; **MySQL 8.0.16+** is the intended minimum version for this script. Compatibility with every release has not been tested.
- **MySQL Workbench** (recommended for class) or the MySQL command-line client.
- An existing local MySQL connection with sufficient privileges to create a database and tables.

The group's local setup displayed **MySQL Community Server 26.7.0** in the terminal. This is an environment observation, **not** proof that the complete project has been tested on that version. MySQL Workbench may show a version-support warning while basic SQL editing still works.

Check your own server version:

```sql
SELECT VERSION();
```

> **Security:** Do not upload passwords, local configuration containing credentials, `.env` files, or server logs. Each person connects with their own credentials. Never put a password in `README.md`, `.sql` files or screenshots.

## 4. Running the project

### Option A — MySQL Workbench (recommended)

1. Start MySQL Server and open your own **local connection** in MySQL Workbench.
2. Use a **fresh database**. Back up any existing `tutoring_mini` database before doing anything destructive.
3. Select **File → Open SQL Script**, open `sql/schema.sql`, and execute the **entire script** (lightning-bolt command). It creates `tutoring_mini` and six tables.
4. Open `sql/seed.sql`, then execute the entire script to insert sample records and run validation checks. **This file will be added after team approval.**
5. Open and run `sql/queries.sql` (ten independent numbered queries).
6. Open and run `sql/views.sql` (creates the three required views).
7. Refresh **SCHEMAS** in the left sidebar to inspect the database objects.

**Strict execution order:**

```text
1. sql/schema.sql
2. sql/seed.sql
3. sql/queries.sql
4. sql/views.sql
```

The provided `schema.sql` intentionally contains **no `DROP` statements**, and its `CREATE TABLE` statements are **not idempotent**. Execute it only once against a clean database. Running it a second time against the same tables will fail with “table already exists”; do not assume a failed rerun means the original initialization failed.

### Option B — MySQL command line

After authenticating with your own account, use the MySQL client with **interactive password prompts** (do not embed passwords in the command):

```bash
mysql -h 127.0.0.1 -P 3306 -u YOUR_USER -p < sql/schema.sql
mysql -h 127.0.0.1 -P 3306 -u YOUR_USER -p < sql/seed.sql
mysql -h 127.0.0.1 -P 3306 -u YOUR_USER -p < sql/queries.sql
mysql -h 127.0.0.1 -P 3306 -u YOUR_USER -p < sql/views.sql
```

Run these commands from the repository's top-level folder, **after the three remaining SQL files have been added**. Replace `YOUR_USER` with your MySQL username; do not type your password after `-p`. The script runs use the `USE tutoring_mini;` context where defined; verify that the final three files also select the intended database.

## 5. Verify the database

After running `schema.sql`:

```sql
USE tutoring_mini;
SHOW TABLES;
```

There should be six base tables: `subjects`, `tutors`, `students`, `lessons`, `lesson_reports`, `payments`.

After running the **approved** `seed.sql`, check the minimum required row counts:

```sql
SELECT 'subjects' AS table_name, COUNT(*) AS row_count FROM subjects
UNION ALL SELECT 'tutors', COUNT(*) FROM tutors
UNION ALL SELECT 'students', COUNT(*) FROM students
UNION ALL SELECT 'lessons', COUNT(*) FROM lessons
UNION ALL SELECT 'lesson_reports', COUNT(*) FROM lesson_reports
UNION ALL SELECT 'payments', COUNT(*) FROM payments;
```

| Table | Required minimum rows |
|---|---:|
| `subjects` | 5 |
| `tutors` | 6 |
| `students` | 10 |
| `lessons` | 12 |
| `lesson_reports` | 10 |
| `payments` | 10 |

The source assignment also requires **2025 Q1 data**, months outside Q1, dates outside 2025, all three lesson statuses, split and partial payments, an unpaid customer, a tutor with no 2025 lessons, and a subject with no Q1 lessons. Check these in the *final* dataset; row counts alone are not sufficient.

Once the approved `views.sql` has run:

```sql
SHOW FULL TABLES IN tutoring_mini WHERE Table_type = 'VIEW';
SELECT * FROM tutoring_mini.v_detail LIMIT 5;
SELECT * FROM tutoring_mini.v_group_summary LIMIT 5;
SELECT * FROM tutoring_mini.v_debt LIMIT 5;
```

Expected views: `v_detail`, `v_group_summary`, and `v_debt`. Their detailed output must be reviewed against the official project brief; empty/NULL/zero cases matter.

## 6. Core business rules

1. `lessons.status` is one of `Pending`, `Completed`, `Cancelled`.
2. Every **Completed** lesson must have exactly one report; `Pending`/`Cancelled` lessons must have none.
3. `lesson_reports.lesson_id` is a foreign key with a **unique** constraint, allowing at most one report per lesson.
4. `duration_minutes > 0` and `fee >= 0`.
5. Each payment has a strictly positive amount, a date, and method in `Cash`, `BankTransfer`, `Card`.
6. Payments must relate to an existing confirmed lesson report; the **sum of payments** for a lesson must not exceed its confirmed fee.
7. Financial summaries must not multiply the confirmed fee when a lesson has multiple payments. Reported debt is **confirmed fees minus actual payments**.

**Important enforcement distinction:** primary/foreign keys, `UNIQUE`, `CHECK` and `ENUM` are implemented in `schema.sql`. Conditions spanning multiple tables or summed payments **cannot be enforced by these single-row constraints alone**; the official assignment allows them to be **validated with SQL checks in `seed.sql`**, without requiring triggers or stored procedures.

## 7. Queries and views

The assignment requires **10 separate, numbered queries** in `queries.sql` and **three all-time views** in `views.sql`:

- `v_detail`: one row per lesson, including lessons without a report (fee is `NULL` in that case).
- `v_group_summary`: per-subject lesson count, Completed/Cancelled counts and total confirmed fee, including subjects with zero lessons.
- `v_debt`: per-student confirmed fee, actual amount paid and remaining debt, including students with no activity (zero totals).

When combining `lesson_reports` with `payments`, pre-aggregate payments **by `lesson_id`** or use an equivalent method to avoid counting the same report fee multiple times.

## 8. Team handoff and submission

| Component | Primary role | Review / release requirement |
|---|---|---|
| ERD, schema, repository | Mai Anh | Confirm schema and documentation agree |
| Sample data (`seed.sql`) | Khánh An | Confirm row counts and business-rule tests |
| SQL queries (`queries.sql`) | Tường Khanh | Confirm 10 requirements, evidence after final seed |
| Views and report compilation | Nhật Linh | Confirm three views and final report |

Only upload **approved** versions of team files. When a file is revised, rerun the integration sequence from a clean test database and update the report evidence. Detailed instructions, SQL QA checks, status of T05, and the final release checklist are in `docs/`.

**Team internal target:** 06 Nov 2026, 20:00 (ICT).  
**Instructor deadline:** Sunday, **08 Nov 2026, 21:00 (ICT)**.  
The final PDF report must display both the **NEU and AEP logos** on its cover, as instructed by the lecturer.

**Current release state:** Documentation scaffold ready; SQL integration and GitHub publication awaiting final team files and local checks.