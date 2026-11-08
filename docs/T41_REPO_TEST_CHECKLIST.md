# T41 — Independent repository acceptance test

**Task owner:** Tường Khanh  
**Assigned reviewer:** Nhật Linh  
**Prepared for handoff by:** Mai Anh, 08/11/2026  
**Current state:** PARTIAL — SQL and README are available; **final PDF is missing**.

Repository: https://github.com/xoainguyenpham-rgb/Group8_TutoringMini_Midterm  
Default branch: `main`. Repository visibility checked through GitHub: **public**.

## Precheck by Mai Anh (not Tường Khanh's review)

| Check | Observed at precheck | Tường Khanh's independent evidence/result |
|---|---|---|
| GitHub repository accessible as public | Yes, API reports public | [ ] Verify in private/incognito browser |
| `sql/schema.sql` present | Yes | [ ] Open / download |
| `sql/seed.sql` present | Yes | [ ] Open / download |
| `sql/queries.sql` present | Yes | [ ] Open / download |
| `sql/views.sql` present | Yes | [ ] Open / download |
| Root `README.md` present | Yes | [ ] Read instruction order |
| `report/Group08_TutoringMini_Report.pdf` present | **NO** | [ ] Open / download PDF after upload |
| Four SQL files reproduce the final reviewed version | Source handoff checked by Mai Anh | [ ] Compare with T31/approved version |
| README run instructions safe and clear | Written | [ ] Test/confirm |
| Files contain no credentials/secrets | Not independently security-audited by T41 | [ ] Check |

## Independent reviewer test procedure

1. Open repository in a browser window **not logged in to the owner's account**, confirm access.
2. Download/open each `sql/*.sql` file. Confirm exact names and run order: `schema.sql` → `seed.sql` → `queries.sql` → `views.sql`.
3. Verify 6 base tables, 10 query sections and 3 views; compare with approved T31 outcome. Do not run against existing populated database.
4. Once the official PDF is uploaded, check it opens, matches complete sections A–E, has original Workbench evidence and is linked from README.
5. Save a browser screenshot showing all four SQL filenames and the PDF, plus the PDF opening successfully.
6. Return final review verdict to Mai Anh and Nhật Linh.

### Evidence fields

- Test date/time (ICT): `______________`
- Repository URL tested: `______________`
- Screenshot / Drive evidence link: `______________`
- PDF filename and status: `______________`
- Reviewer Tường Khanh: `______________`
- Reviewer Nhật Linh: `______________`
- Final verdict: `PENDING / PASS / NEEDS FIX`

**Do not mark T41 Done until the PDF is present and independently checked.**
