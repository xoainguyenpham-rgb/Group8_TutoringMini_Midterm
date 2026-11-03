# T04 — Review checklist & handoff (Group 08, Topic 01)

**Owner:** Mai Anh  
**Reviewer:** Nhật Linh  
**Purpose:** Verify declared single-table constraints and validate cross-table business rules with read-only `SELECT` queries.

## 1. What the current SQL already provides

In `sql/schema.sql`:
- `lesson_reports.lesson_id`: `UNIQUE` (`uq_lesson_reports_lesson`), and FK to `lessons`.
- `lesson_reports.duration_minutes`: `INT UNSIGNED NOT NULL` and `CHECK (duration_minutes > 0)`.
- `lesson_reports.fee`: `DECIMAL(12,2) NOT NULL` and `CHECK (fee >= 0)`.
- `lessons.status`: `ENUM('Pending','Completed','Cancelled') NOT NULL`.
- `payments.amount`: `CHECK (amount > 0)`.

In the existing candidate `sql/seed.sql`, SELECT tests already check FK integrity, the Completed/report relationship, payments not exceeding fees, and other data cases.

## 2. Why T04 needs SELECT for cross-table rules

The rules **Completed -> exactly one report**, **Pending/Cancelled -> no report**, and **total actual payments <= confirmed fee** involve multiple rows or tables. A normal MySQL column/table `CHECK` cannot query another table or perform an aggregate over its rows. The assignment explicitly allows validation queries in `seed.sql` instead of triggers/stored procedures.

## 3. How Nhật Linh can review

1. Start from a clean database in MySQL Workbench.
2. Run `sql/schema.sql`, then `sql/seed.sql`.
3. Run `docs/T04_constraints_validation.sql`.
4. Inspect `SHOW CREATE TABLE`: confirm `UNIQUE`, `CHECK`, and `ENUM` are present.
5. Inspect the seven violation counters: expected **0 for every check**.
6. Inspect the detailed `HAVING` query: expected **zero returned rows**.
7. Inspect lesson status/report counts: Completed must show 1, Pending/Cancelled 0.
8. Capture screenshots of the relevant Workbench Result Grid and note the MySQL server version with `SELECT VERSION();`.

If any violations are returned, do not approve until the seed, schema or business rule interpretation is corrected. The standalone `T04_constraints_validation.sql` is supplementary evidence: the four mandatory submission files remain `schema.sql`, `seed.sql`, `queries.sql`, `views.sql`.

## 4. Evidence / status

- [x] The relevant constraints and validation queries are present in the existing SQL files (code inspection).
- [x] Supplementary read-only T04 SQL and reviewer handoff provided.
- [ ] Tested on the team's own MySQL Workbench using the final approved seed.
- [ ] Result screenshots attached.
- [ ] Nhật Linh approves T04.

**Do not claim that MySQL runtime validation passed without actually running the queries in MySQL.**

## Suggested reviewer comment

> Nhật Linh ơi, mình đã kiểm tra T04: schema.sql có UNIQUE cho lesson_reports.lesson_id, CHECK duration_minutes > 0 và fee >= 0; quan hệ Completed/report được kiểm tra riêng bằng SELECT vì CHECK không thể truy vấn liên bảng. Mình đã bổ sung file docs/T04_constraints_validation.sql để kiểm tra và lấy minh chứng. Nhờ bạn review phần logic và kết quả chạy trên MySQL; nếu các violation đều bằng 0 thì duyệt T04 giúp mình nhé.
