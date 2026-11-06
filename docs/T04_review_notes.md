# T04 — Re-review & handoff (Group 08, Topic 01)

**Owner:** Mai Anh  
**Reviewer:** Nhật Linh  
**Updated:** 06/11/2026, incorporating review feedback.  
**Scope:** T04 focuses on what a MySQL single-table `CHECK` cannot enforce across tables.

## 1. What Nhật Linh commented, and the fix

1. **Old checks 01–03 were not cross-table rules.** They checked duplicate `lesson_reports.lesson_id`, nonpositive `duration_minutes`, and negative `fee`. Those are guarded already by `UNIQUE`, `NOT NULL`, and `CHECK` in `sql/schema.sql`. **Fix:** Remove these three from the *cross-table violations* result. Keep `SHOW CREATE TABLE` and `information_schema.table_constraints` as direct **DDL evidence**.
2. **Missing payment date vs. lesson date validation.** **Fix:** Add `05_payment_before_lesson`: join `payments` to `lessons` and return violations where `p.payment_date < l.lesson_date`. Also provide a detailed query identifying offending payment IDs and dates.

## 2. Final SELECT checks

All five counters in [T04_constraints_validation.sql](T04_constraints_validation.sql) must be **0** for valid data.

| Check | Type | Expected |
| --- | --- | --- |
| 01 Completed lesson without exactly one report | Cross-table and aggregate | 0 |
| 02 Report belonging to Pending/Cancelled lesson | Cross-table | 0 |
| 03 Payment without a Completed lesson and report | Cross-table | 0 |
| 04 Sum of payments per lesson exceeds report fee | Cross-table/aggregate | 0 |
| 05 Payment date before the lesson date | Cross-table | 0 |

Detailed status-report and early-payment queries should return **0 rows**. The status/report snapshot should show **1** report for Completed, **0** for Pending and Cancelled.

## 3. MySQL Workbench run (read-only)

1. Check that isolated T26 database `tutoring_mini_t26_20261105_v2` exists and has passed the relevant `schema → seed` steps.
2. Open `docs/T04_constraints_validation.sql`. It explicitly uses **only the isolated test database**. If its name differs, **edit the USE line first**; do not run against the original `tutoring_mini` by accident.
3. Run and capture `SELECT DATABASE(), VERSION()`, the five violation counts (expect all 0), and the two zero-row detail checks.
4. Capture DDL output proving `UNIQUE`, `CHECK` and `ENUM`.
5. Send the screenshots and this revised script to Nhật Linh for sign-off.

**Do not claim the revision is runtime-tested until it has been run in MySQL.** Prior T26 screenshots support the project but do not by themselves verify the **new T04-specific payment date check**.

## 4. Scope / implementation note

MySQL `CHECK` constraints are local to the row/table and cannot enforce a condition referencing another table or `SUM` of payments. The assignment permits SELECT validation for those rules and does not require triggers or stored procedures. The four mandatory submission scripts remain `schema.sql`, `seed.sql`, `queries.sql`, and `views.sql`; this T04 script is supplementary reviewer evidence.

## Suggested re-review reply

> T đã sửa T04 theo góp ý của Linh rồi nhé: tách 3 kiểm tra UNIQUE/CHECK sang phần minh chứng DDL, giữ các quy tắc liên bảng trong nhóm SELECT riêng, và bổ sung check payment_date < lesson_date. Nhờ Linh xem lại file SQL mới trên GitHub; sau khi t chạy chụp minh chứng MySQL thì m review để t chốt T04 nhé.

**Status:** Revised after feedback; **pending rerun on test DB and Nhật Linh approval**.
