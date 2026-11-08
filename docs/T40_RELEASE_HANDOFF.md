# T40 — GitHub release handoff (08 November 2026)

**Owner:** Mai Anh  
**Reviewer:** Tường Khanh (for T40); **T41 run by:** Tường Khanh, reviewed by Nhật Linh.

## Uploaded and verified on `main`

| Release file | Git blob SHA |
| --- | --- |
| `sql/schema.sql` | `97812113f4cb40c4b31476a3b89d48562ae168fc` |
| `sql/seed.sql` | `04c15f00609c7e65acf7b85995b6a2eb8daa82c9` |
| `sql/queries.sql` | `439bdb0d30ceb34bbe538a9028bdc6505faa8289` |
| `sql/views.sql` | `ee6aceedca75707d19b7aa2dd149e9d13576983b` |
| `README.md` | `1549041fe3a6d19e238ca56dfc7096a8911eabc4` |

- Schema from `schema(2).sql`.
- Seed from `seed(3).sql`; **only** T10.11 Expected comment corrected to **Chemistry + Literature**. Inserted data unchanged.
- Queries from Tường Khanh's `queries(2).sql` (ten queries, no code change).
- Views from Nhật Linh's `views(2).sql` (three views).
- README rewritten to show current release/evidence status rather than obsolete candidate status.
- All five files were re-fetched from GitHub after upload and their displayed blob SHAs verified.

## Current gate: PDF and independent acceptance

**T40 is not yet complete.** `report/Group08_TutoringMini_Report.pdf` is **not uploaded** as of this handoff. An incomplete 16-page working draft was deliberately *not* uploaded.

To finish:
1. Nhật Linh provides the complete A–E PDF (with genuine Workbench screenshots and no placeholders). Mai Anh completes T39 proofread.
2. Upload the approved PDF to `report/Group08_TutoringMini_Report.pdf`.
3. Tường Khanh (T41) opens this public repository without privileged access, downloads all four SQL files and the PDF, and checks README and output. No passwords or API keys should be committed.
4. Complete T42 four-member sign-off, and T43 actual submission and saved receipt.

## Quick technical reviewer checks

- Correct run order: schema → seed → queries → views, on **new empty database**, with existing data backed up.
- 5 subjects / 6 tutors / 10 students / 12 lessons / 10 reports / 10 payments.
- 10 query sections, 3 views, 12/5/10 rows.
- Confirmed fee / total paid / outstanding debt: 5,000,000 / 4,000,000 / 1,000,000 VND.
- Q02: Chemistry and Literature 0 in Q1/2025; Q09: tutor 6 NULL.
- MySQL execution evidence must be genuine screenshots, not AI-generated images.
- The main `sql/` files have no `DROP DATABASE`, `DROP TABLE`, `TRUNCATE` or `DELETE FROM` statements.

**Final release status:** `SQL + README uploaded / PDF pending / T41 pending`.
