# T27 — Issue Log / Tổng hợp lỗi và vấn đề tích hợp

**Nhóm:** Group 08 — Đề 01 (Tutoring Mini)  
**Người lập / owner T27:** Mai Anh  
**Reviewer T27:** Tường Khanh  
**Cập nhật:** 05/11/2026  
**Tình trạng:** **DRAFT — pending T26 MySQL clean-run evidence and Tường Khanh review**

> T27 được lập từ review code và dữ liệu **đang có trên GitHub**. Clean-run T26 trên MySQL Workbench của Mai Anh chưa có biên bản kết quả đã điền, nên **không được coi các issue này là kết luận sau kiểm thử thực tế**. Bản tổng hợp này có thể bổ sung lỗi mới sau khi chạy T26.

## 1. Quy ước phân loại

- **BUG — Confirmed:** Bằng chứng từ mã/dữ liệu hiện hành cho thấy sai lệch cụ thể.
- **QA GAP — Not a bug:** Thiếu tình huống mẫu để chứng minh quy tắc hoạt động; không mặc định code sai.
- **BLOCKER / RELEASE GATE:** Việc bắt buộc phải hoàn tất trước bàn giao; không tự coi là lỗi chức năng.
- **Severity High:** Ảnh hưởng khả năng chạy/nộp hoặc đúng dữ liệu nhiều chức năng; **Medium:** ảnh hưởng một nhóm kết quả nghiệp vụ; **Low:** chủ yếu độ bao phủ QA hoặc tài liệu.
- **Open:** Chưa có đủ bằng chứng đóng; **Pending review:** đã có bản sửa nhưng chưa có sign-off; **Closed:** đã có commit, kiểm thử lại và reviewer xác nhận.

## 2. Issue log chính thức — người sửa, mức ảnh hưởng, phương án, bằng chứng

| ID | Phân loại / Mức độ | Mô tả / Phạm vi tác động | Người sửa / Reviewer | Phương án xử lý | Bằng chứng cần có | Trạng thái |
|---|---|---|---|---|---|---|
| [#1](https://github.com/xoainguyenpham-rgb/Group8_TutoringMini_Midterm/issues/1) | **BUG · Medium** | Tutor 5 ghi bằng Biology, nội dung lessons 5 & 9 là Biology, nhưng `subject_id=1` (Mathematics). Sai số thống kê theo môn ở Q02/Q04, `v_detail`, `v_group_summary`. | **Khánh An** / Mai Anh; thông báo Tường Khanh, Nhật Linh | An xác minh chuyên môn dự định; nếu Biology thì đổi `subject_id` từ 1→5 trong bản seed được duyệt; chạy lại kết quả phụ thuộc môn. | [seed.sql](../sql/seed.sql) đang có + bản T07 sửa còn cùng giá trị; commit seed cuối, SELECT tutor–subject, ảnh Q02/Q04 và views sau sửa. | **Open** |
| [#2](https://github.com/xoainguyenpham-rgb/Group8_TutoringMini_Midterm/issues/2) | **QA GAP · Low** | Chưa có lesson `Cancelled` năm 2025; Q09 chưa được test trường hợp tỷ lệ hủy >0 (không phải lỗi câu truy vấn). | **Khánh An** (fixture) + Tường Khanh (Q09) / Mai Anh | Bổ sung case trong **database QA riêng** hoặc seed sau khi nhóm chấp thuận; đối chiếu tỷ lệ hủy >0, =0, và NULL. | [seed.sql](../sql/seed.sql), [queries.sql](../sql/queries.sql), screenshot Q09 và phép tính tay, mã test fixture. | **Open** |
| [#3](https://github.com/xoainguyenpham-rgb/Group8_TutoringMini_Midterm/issues/3) | **QA GAP · Low** | Dataset có lesson cho cả 5 subjects (tính mọi thời gian), nên chưa chứng minh `v_group_summary` trả 0 cho subject hoàn toàn rỗng. Không phải lỗi VIEW đã xác nhận. | **Khánh An** (fixture) + Nhật Linh (VIEW) / Tường Khanh | Trong DB QA riêng, thêm subject mới không có tutor/lesson; chạy VIEW và so sánh cột total/completed/cancelled/fee đều 0. | [views.sql](../sql/views.sql), mã fixture, ảnh Result Grid và expected/actual. | **Open** |

**Đã xem xét nhưng KHÔNG lập bug:** Q03 dùng `l.status <> 'Cancelled'` và bao gồm Pending không có report, phù hợp mô tả hiện hành của đề. Không tự sửa thành `status='Completed'` chỉ vì Pending xuất hiện. Q04 comment diễn giải đã nêu “per Completed lesson, all dates”.

## 3. Việc ngăn chốt T27 (không xếp chung với bug)

| Release gate / Mức ảnh hưởng | Người xử lý | Cần làm | Minh chứng / Trạng thái |
|---|---|---|---|
| **G01 · High — T26 clean-run MySQL chưa có kết quả thực thi** | Mai Anh; reviewer Khánh An | Backup database gốc; chạy 4 SQL trên database test mới; chạy validation; ghi lỗi, ảnh và phiên bản MySQL. | [T26 runbook](../tests/t26/README.md), [biên bản trống](../tests/t26/T26_RESULT_TEMPLATE.md). **Pending**, không có chứng nhận PASS. |
| **G02 · High — 3 file SQL chưa xác nhận đúng bản đã duyệt** | Khánh An (`seed.sql`), Tường Khanh (`queries.sql`), Nhật Linh (`views.sql`); Mai Anh tích hợp | Đối chiếu bản approved, thay candidate nếu có thay đổi; run clean từ đầu. | [seed](../sql/seed.sql), [queries](../sql/queries.sql), [views](../sql/views.sql) còn tiêu đề working draft/candidate. **Pending**. |
| **G03 · Medium — PDF báo cáo cuối chưa xuất bản** | Nhật Linh; cả nhóm duyệt | Upload PDF hoàn chỉnh vào `report/`, bảo đảm đúng số liệu SQL được chốt và yêu cầu bìa. | [report](../report/README.md) mới có README. **Pending**. |
| **G04 · Medium — quyền xem repo khi nộp** | Mai Anh | Xác minh thầy có quyền truy cập nếu repo Private. | Repository Private; **chưa có bằng chứng thầy được cấp quyền**. |

## 4. Khi chạy T26 có bug mới, bổ sung theo đúng mẫu

```text
ID / link GitHub Issue:
Phát hiện lúc: YYYY-MM-DD HH:mm (MySQL version, database test)
File/câu lệnh:
Bước tái hiện:
Expected:
Actual:
Phân loại: BUG / QA GAP / BLOCKER
Severity: High / Medium / Low
Impact:
Fix owner:
Reviewer:
Root cause:
Phương án sửa:
Bằng chứng lỗi: ảnh Result Grid hoặc SQL error + link dòng/commit
Bằng chứng fix: commit + ảnh test lại Expected = Actual
Trạng thái: Open / Pending review / Closed
```

**Nếu T26 không phát hiện lỗi runtime:** Ghi **“0 confirmed runtime bugs in the executed test”** chỉ sau khi có đầy đủ Result Grid; vẫn giữ #1 là vấn đề dữ liệu trong draft, và không tự đóng #2/#3 nếu chưa test được case thiếu.

## 5. Quy trình chốt T27 với Tường Khanh

1. Mai Anh điền [T26_RESULT_TEMPLATE](../tests/t26/T26_RESULT_TEMPLATE.md) từ **kết quả MySQL thực tế** và đính kèm ảnh không lộ mật khẩu; xác nhận DB gốc không bị thay đổi.
2. Đối chiếu mọi lỗi phát sinh khi chạy 4 script và validation với issue log này. Thêm issue mới nếu có bằng chứng.
3. Chủ sở hữu mỗi issue sửa **trong file gốc được duyệt**, gắn mã commit / ảnh kiểm thử lại vào issue, rồi người review xác nhận.
4. Tường Khanh rà xem có đủ **owner, severity, impact, fix plan, evidence, status** và xác nhận những mục chưa sửa sẽ được xử lý trước nộp.
5. Chỉ ghi **T27 DONE** khi đã rà các lỗi sau clean-run, tất cả issue được phân loại và phân công, các vấn đề chặn nộp được xử lý hoặc có kế hoạch có người chịu trách nhiệm được reviewer đồng ý. Không yêu cầu mọi QA GAP đều phải sửa nếu nhóm và reviewer chấp nhận giới hạn test, nhưng phải ghi rõ.

## 6. Review / sign-off

- **Mai Anh — issue log prepared:** ✅ Có
- **T26 runtime evidence attached:** ☐ Chưa
- **Issues updated following T26:** ☐ Chưa
- **Tường Khanh reviewed:** ☐ Chưa
- **T27 signed off:** ☐ Chưa

**Tường Khanh comments / approval:** _Chờ phản hồi._

## 7. Liên kết

- [GitHub Issue tracker](https://github.com/xoainguyenpham-rgb/Group8_TutoringMini_Midterm/issues)
- [SQL source](../sql/README.md)
- [T26 isolated clean-run](../tests/t26/README.md)
- [T04 constraints validation](T04_constraints_validation.sql)

*Lưu ý riêng cho tracker: T27 theo lịch là mốc 04/11/2026, không có mốc 03/11. Bản log bổ sung ngày 05/11 vì T26 hiện vẫn chưa có bằng chứng runtime được gửi.*
