# T26 — Clean-run lần 1 (Group 08, Đề 01)

**Ngày chuẩn bị:** 05/11/2026  
**Owner:** Mai Anh · **Reviewer:** Khánh An  
**Yêu cầu:** Chạy 4 script theo thứ tự, trong database **MỚI**, không xóa/ghi đè database gốc.  
**Database gốc:** `tutoring_mini` · **Database KIỂM THỬ:** `tutoring_mini_t26_20261105`

> Đây là **bộ test dành riêng cho T26** được tạo từ bản SQL đang có trên GitHub. Ba file `seed.sql`, `queries.sql`, `views.sql` vẫn là bản tích hợp chờ duyệt; mọi số liệu dự kiến bên dưới chỉ có hiệu lực với bản dữ liệu này. **Chưa có xác nhận clean-run bằng MySQL của người dùng.**

## 1. Backup trước, bảo vệ database gốc

Trong MySQL Workbench, mở **Server → Data Export**, chọn schema `tutoring_mini`, chọn **Export to Self-Contained File**, chọn **Dump Structure and Data**, sau đó nhấn **Start Export**. Kiểm tra file `.sql` backup tồn tại trên máy, ví dụ `tutoring_mini_backup_20261105.sql`. Không tải file backup hay thông tin đăng nhập lên GitHub công khai.

Nếu có `mysqldump` trên máy Mac, tùy chọn dòng lệnh (dùng prompt, không ghi password vào lệnh):

```bash
mysqldump -u root -p --single-transaction tutoring_mini > ~/Desktop/tutoring_mini_backup_20261105.sql
```

Đừng dùng `DROP DATABASE`, `TRUNCATE`, `DELETE` hoặc `CREATE TABLE` trên `tutoring_mini` trong T26.

## 2. Clean-run từng file (khuyến nghị để dễ chụp minh chứng)

1. Mở MySQL Workbench, kết nối máy MySQL của cậu. Ghi lại phiên bản bằng `SELECT VERSION();`.
2. Mở **`01_schema_TEST.sql`**, chọn biểu tượng **Execute All / tia sét**, kiểm tra 6 lệnh `CREATE TABLE` báo thành công. File này **tạo mới `tutoring_mini_t26_20261105`** (không có IF NOT EXISTS); nếu tên đã tồn tại, không chạy tiếp trên database cũ, hãy chọn tên database thử mới và đổi nhất quán tên trong mọi script.
3. Mở **`02_seed_TEST.sql`** và Execute All. Đối chiếu số bản ghi: 5 / 6 / 10 / 12 / 10 / 10; các câu truy vấn tìm vi phạm trả **0 dòng**.
4. Mở **`03_queries_TEST.sql`**, chạy 10 câu SELECT. Cần quan sát từng Result Grid, nhất là Q03, Q08, Q09, Q10.
5. Mở **`04_views_TEST.sql`**, tạo 3 VIEW, xác nhận `v_detail`, `v_group_summary`, `v_debt` trả về đúng 12 / 5 / 10 dòng.
6. Chạy **`05_validation_TEST.sql`**, kiểm tra tất cả chỉ số `violations = 0`, tổng fee = paid + debt, và chụp các Result Grid chính.
7. Điền kết quả vào `06_RESULT_TEMPLATE.md` và gửi Khánh An review; sau khi có chữ ký/ý kiến reviewer mới đánh dấu nghiệm thu.

**Lưu ý:** Mỗi bản test đều đã được chuyển `USE tutoring_mini` thành `USE tutoring_mini_t26_20261105`. Không dùng 4 file gốc trong `sql/` cho lần test này nếu database `tutoring_mini` đang chứa dữ liệu phải giữ nguyên.

## 3. Một-click (tùy chọn)

Có thể mở `00_RUN_ALL_TEST.sql` và chạy toàn bộ trong 1 tab. File nối các lệnh theo đúng thứ tự và **chỉ tham chiếu database mới**. Tuy nhiên nên dùng 5 file riêng để có minh chứng rõ từng bước, và dừng nếu script đầu phát sinh lỗi.

## 4. Kết quả kỳ vọng với *dataset đang có* (không phải kết quả MySQL đã xác nhận)

| Kiểm tra | Kết quả kỳ vọng |
|---|---|
| Bảng base | 6 |
| subjects / tutors / students | 5 / 6 / 10 |
| lessons / lesson_reports / payments | 12 / 10 / 10 |
| Trạng thái lessons | Completed 10, Pending 1, Cancelled 1 |
| 3 VIEW | v_detail 12, v_group_summary 5, v_debt 10 |
| 7 kiểm tra violations | Tất cả bằng 0 |
| Tổng fee / paid / debt | 5.000.000 / 4.000.000 / 1.000.000 VND |
| lesson_id=2 | fee 500.000; paid 500.000; debt 0 |
| Query 03 | student_id=3 (Pending, không có report) |
| Query 10 | student_id=1 (>3 Completed năm 2025) |
| Cancelled trong năm 2025 | 0 (thiếu case hủy năm 2025 để thử tỷ lệ dương Q09) |
| Subject không có lesson cả thời gian | 0 (chưa thử VIEW zero-activity ở toàn bộ thời gian) |

## 5. Ảnh chụp minh chứng cần có

- `01_backup.png`: xác nhận đường dẫn backup `.sql` (không lộ password).
- `02_schema.png`: 6 bảng mới được tạo dưới database test.
- `03_seed.png`: kết quả count 5/6/10/12/10/10 và các câu check không vi phạm.
- `04_queries.png`: kết quả một số câu tiêu biểu (Q03, Q08, Q09, Q10), kèm trạng thái 10 câu chạy.
- `05_views.png`: ba VIEW và row counts.
- `06_validation.png`: bảy violation counters bằng 0, tổng fees/paid/debt khớp.
- `07_server_version.png`: `SELECT VERSION(), DATABASE()`.

Đừng đưa vào repo ảnh có mật khẩu, token, email cá nhân thật hoặc file backup chứa dữ liệu nhạy cảm.

## 6. Chốt tracker / review

- **Status trước khi chạy:** Prepared — Pending MySQL clean-run.
- **Sau khi chạy đạt:** Clean-run PASS (on isolated test DB) — Pending Khánh An review.
- **Sau khi An duyệt:** T26 Done.

T26 chỉ là **lần 1**, không thay thế kiểm thử trên bản SQL cuối nếu nhóm tiếp tục chỉnh sửa.