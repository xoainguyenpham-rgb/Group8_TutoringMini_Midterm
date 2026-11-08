# Group 08 — Tutoring Centre Management (Topic 01)

**National Economics University (NEU) · Database Management in Business**  
**Database:** MySQL `tutoring_mini`  
**Team:** Mai Anh (schema and integration), Khánh An (seed and QA), Tường Khanh (10 queries), Nhật Linh (views and PDF).

> **Release status — 08 November 2026:** The four SQL deliverables under `sql/` have been refreshed from the team's reviewed sources. **The final combined PDF has not yet been uploaded to `report/`.** T31 was reviewed by Khánh An as *Đạt có lưu ý* (technical acceptance with an evidence-organization note). Do not regard this repository as fully submitted until the final PDF, MySQL evidence, independent repository check and team sign-offs are complete.

## Project

This relational database supports six business entities:

| Table | Role |
| --- | --- |
| `subjects` | Teaching subjects |
| `tutors` | Tutors and their assigned subjects |
| `students` | Registered students |
| `lessons` | Sessions, tutor, student, DATETIME and status |
| `lesson_reports` | Confirmed lesson details and fee; at most one report per lesson |
| `payments` | Payment instalments; potentially multiple per lesson |

The schema defines primary/foreign keys, `UNIQUE`, `CHECK`, `NOT NULL` and `ENUM`. Cross-table rules such as Completed ⇒ exactly one report, payments only after a confirmed report and no overpayment are **validated by SELECTs** in `seed.sql`, not asserted to be automatically enforced by MySQL `CHECK` constraints.

## Required files and execution order

1. `sql/schema.sql` — create database and six tables.
2. `sql/seed.sql` — load 53 sample rows, then run data-integrity checks.
3. `sql/queries.sql` — Q01–Q10, each independently runnable.
4. `sql/views.sql` — create `v_detail`, `v_group_summary`, `v_debt` and display their results.

**Run each file once, in order, on a fresh empty MySQL database.** `schema.sql` uses `CREATE DATABASE IF NOT EXISTS tutoring_mini`, but table creation and seed INSERTs are not idempotent. **Back up any existing `tutoring_mini` database first; do not run these scripts over populated production or prior-test data.** This repository's SQL sources use `USE tutoring_mini;`. For isolated acceptance checks, use the separately prepared T31 test-db scripts rather than changing a database that already contains records.

No `DROP DATABASE`, `DROP TABLE`, `TRUNCATE TABLE` or `DELETE FROM` statement is included in these four release SQL files.

## Expected data checks

| Check | Expected |
| --- | --- |
| Subjects / tutors / students | 5 / 6 / 10 |
| Lessons / lesson reports / payments | 12 / 10 / 10 |
| Lesson statuses | Completed 10; Pending 1; Cancelled 1 |
| Q01 | Completed lessons 1, 2, 3 in January 2025 |
| Q02 | Mathematics 2; Physics 2; Chemistry 0; Literature 0; Biology 1 (Q1 2025) |
| Q03 | Student 4 (Pending lesson without report) |
| Q07 | Students 2, 3, 4, 9, 10 have no payments across all time |
| Q09 | Tutors 1–5: 0%; tutor 6: NULL (no lessons in 2025) |
| Q10 | Student 1: five Completed lessons in 2025 |
| `v_detail`, `v_group_summary`, `v_debt` | 12 / 5 / 10 rows |
| Confirmed fee / payments / debt (all time) | VND 5,000,000 / 4,000,000 / 1,000,000 |

**Scope distinction:** Q06 includes only payments dated in 2025, totalling **VND 3,000,000**; `v_debt` uses payments across **all dates**, totalling **VND 4,000,000**. These results are consistent.

**Coverage limitations:** The official seed has no Cancelled lesson **in 2025**, and no subject without lessons over **all time**. These are test-data coverage gaps, not established SQL defects; separate QA fixtures can cover them without changing the official seed.

## Evidence and report

The team's final MySQL screenshots should show actual **MySQL Workbench** execution: selected database and server version, schema/seed counts, Q01–Q10, three views, validation outputs and the clean-run record. **Illustrations, manually recreated result tables and AI-generated images are not proof of MySQL execution.** Refer to the T31/T32 evidence records and use only authentic execution captures for the final report.

The final reviewed PDF belongs at `report/Group08_TutoringMini_Report.pdf` (A–E, university/department cover, screenshots, conclusion). Its upload and T39 proofread are still pending.

## Final release checklist

- [x] Four reviewed SQL sources are present under their canonical names.
- [ ] Attach MySQL execution evidence and reconcile T31 / T32.
- [ ] Upload the complete, proofread A–E PDF to `report/`.
- [ ] Independent T41 test: download all four SQL files and PDF; verify README and access.
- [ ] Four-person T42 approval and T43 instructor submission/receipt.

**Instructor deadline:** 08 November 2026 at 21:00 (ICT, UTC+07).
