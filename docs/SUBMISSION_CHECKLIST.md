# Release checklist — Group 8 / Topic 01

**Trạng thái ban đầu: chưa duyệt bản release cuối**. Điền người kiểm tra, ngày và link bằng chứng khi tất cả file đã chốt.

## A. Cấu trúc và bảo mật

- [ ] Repository `Group8_TutoringMini_Midterm` đã được tạo trên GitHub.
- [ ] README hiển thị và hướng dẫn chạy đúng thứ tự **4 file**.
- [ ] Có `sql/schema.sql`, `sql/seed.sql`, `sql/queries.sql`, `sql/views.sql` đúng tên.
- [ ] Có PDF cuối ở `report/` và hình ERD/relational schema ở `diagrams/`.
- [ ] Đã kiểm tra quyền xem repository đối với người chấm.
- [ ] **Không** có password/token trong file, ảnh, log hoặc lịch sử commit.
- [ ] Ghi rõ phiên bản MySQL thực tế dùng để kiểm thử toàn bộ lần cuối.

## B. Chạy từ database sạch

- [ ] `schema.sql` chạy thành công, tạo database `tutoring_mini` với đúng 6 bảng.
- [ ] FK, PK, UNIQUE, NOT NULL, CHECK, ENUM tương ứng yêu cầu.
- [ ] `seed.sql` chạy thành công, không phụ thuộc vào dữ liệu đã tồn tại trước đó.
- [ ] Row count: subjects ≥5; tutors ≥6; students ≥10; lessons ≥12; lesson_reports ≥10; payments ≥10.
- [ ] Có case Jan/2025, các tháng khác của Q1/2025, ngoài Q1, ngoài năm 2025.
- [ ] Có Completed/Pending/Cancelled; >3 Completed của một học viên trong 2025.
- [ ] Có học viên có lịch sử nhưng chưa trả; thanh toán nhiều lần; giao dịch còn nợ.
- [ ] Có môn không phát sinh trong Q1, gia sư không phát sinh trong 2025.
- [ ] `seed.sql` có các truy vấn phát hiện vi phạm FK, trạng thái/report, thanh toán/fee; các trường hợp vi phạm trả về 0 dòng.

## C. Queries và VIEW

- [ ] 10 queries độc lập chạy thành công và kết quả có mã + tên đối tượng phân biệt.
- [ ] Q01: tháng 01/2025; Q02: Q1/2025 giữ môn có 0 buổi.
- [ ] **Q03:** theo nguyên văn đề, loại **Cancelled**; không vô tình loại **Pending** chỉ vì chưa có report.
- [ ] Q04: học phí trung bình trên **Completed**, toàn bộ thời gian.
- [ ] Q06: dựa trên **payment_date** của năm 2025, giữ cả người chưa trả với 0.
- [ ] Q07: học viên chưa có bất kỳ payment, kể cả chưa có lesson.
- [ ] Q08: tổng fee không bị nhân đôi khi lesson trả nhiều lần.
- [ ] Q09: tỷ lệ hủy năm 2025, 2 chữ số; tutor không có lesson → NULL.
- [ ] Q10: hơn 3 Completed năm 2025.
- [ ] `v_detail`: mọi lesson, fee NULL khi không có report.
- [ ] `v_group_summary`: mọi subject (kể cả 0 lesson), fee không cộng lặp.
- [ ] `v_debt`: mọi student, 0 cho không phát sinh, không nhân đôi phí.

## D. Báo cáo và bàn giao

- [ ] Báo cáo PDF có cả logo NEU và AEP trên bìa.
- [ ] Kết quả bảng, số liệu, ảnh chụp trong PDF khớp chính xác SQL/seed đã commit.
- [ ] Các bản draft/duplicate không xuất hiện dưới dạng file nộp chính.
- [ ] Mai Anh và người review thực hiện kiểm thử end-to-end và xác nhận.
- [ ] Chốt trước 20:00 ngày 06/11/2026 (mốc nội bộ nhóm).
- [ ] Nộp đúng link theo yêu cầu giảng viên trước 21:00 Chủ nhật 08/11/2026 (ICT).

**Link repository:** [điền sau khi tạo]  
**Commit/tag cuối cùng:** [điền]  
**Người xác nhận:** [điền]  
**Ngày kiểm thử lại:** [điền]