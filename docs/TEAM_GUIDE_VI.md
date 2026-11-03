# T05 — Hướng dẫn tạo và bàn giao GitHub (Nhóm 8, Đề 01)

## A. Khởi tạo repository trên GitHub

1. Đăng nhập GitHub, mở <https://github.com/new>.
2. **Owner:** tài khoản GitHub của đầu mối nhóm (Mai Anh).
3. **Repository name:** `Group8_TutoringMini_Midterm`.
4. **Description:** `NEU AEP | Group 08, Topic 01 | Tutoring Mini relational database (MySQL midterm project)`.
5. **Visibility:** chọn `Private` khi nhóm còn sửa bài. Trước lúc nộp, kiểm tra yêu cầu quyền truy cập của thầy: nếu repo private, thầy cần được mời vào hoặc được cấp cách xem hợp lệ; không giả định chỉ gửi link là xem được. Chỉ chuyển `Public` khi đã kiểm tra dữ liệu, thông tin cá nhân và mật khẩu.
6. **Để trống** lựa chọn khởi tạo `README`, `.gitignore`, License vì bộ khung tải xuống đã có các file đó (trừ License — không cần thiết để nộp bài).
7. Bấm **Create repository**.

## B. Upload bộ khung đã chuẩn bị

1. Tải file `.zip` của T05 và **giải nén** trên máy.
2. Vào repository mới → **Add file → Upload files**.
3. Từ thư mục `Group8_TutoringMini_Midterm`, kéo thả **các file và thư mục bên trong**, KHÔNG chỉ đưa file `.zip` lên repo. GitHub sẽ hiển thị `README.md` ở trang chủ repo.
4. Trên macOS, để thấy file `.gitignore` trong Finder, nhấn `Command + Shift + .` (dấu chấm). Kiểm tra `.gitignore` có được upload; nếu không, dùng **Add file → Create new file** để bổ sung thủ công.
5. Xem trước danh sách và bấm **Commit changes** (tên commit gợi ý: `Initialize Group 8 midterm repository`).
6. Kiểm tra ở trang repo có `README.md`, `sql/schema.sql`, `diagrams/`, `docs/`, `report/`, `.gitignore`.

## C. Cộng tác và hoàn thiện 4 SQL

1. Vào **Settings → Collaborators** (tên mục có thể thay đổi theo GitHub) → mời Khánh An, Tường Khanh, Nhật Linh bằng tài khoản GitHub của từng người; các bạn phải chấp nhận lời mời.
2. Khi Khánh An chốt `seed.sql`, bổ sung file tại **`sql/seed.sql`**.
3. Khi Tường Khanh chốt `queries.sql`, bổ sung tại **`sql/queries.sql`**.
4. Khi Nhật Linh chốt `views.sql`, bổ sung tại **`sql/views.sql`**.
5. Upload **báo cáo PDF cuối** vào `report/Group08_TutoringMini_Report.pdf`.
6. Không xóa `schema.sql` đang có trừ khi Mai Anh chấp thuận bản thay thế.
7. Đừng nộp bản SQL trung gian tên `schemas.sql`, `final_v2.sql`, hay lẫn 2 phiên bản truy vấn. Repo cuối nên có đúng 4 tệp SQL bắt buộc mang tên thầy yêu cầu.

## D. Kiểm thử trước khi nộp

1. Từ một database sạch, chạy `schema.sql → seed.sql → queries.sql → views.sql`.
2. Kiểm tra 6 bảng, đủ dữ liệu tối thiểu; toàn bộ truy vấn kiểm tra vi phạm phải cho kết quả hợp lệ.
3. Chạy đủ 10 query và 3 VIEW; chụp bằng chứng kết quả. Không coi sự tồn tại của mã SQL là đã kiểm thử thành công.
4. So sánh các kết quả trong PDF với file SQL cuối cùng trên GitHub.
5. Kiểm tra cover PDF có logo NEU và AEP.
6. Mở URL GitHub bằng tài khoản khác (hoặc nhờ người xem) để xác minh quyền truy cập trước lúc gửi link. Nếu repo private, cần quyền collaborator/giảng viên; nếu public, mọi người đều có thể xem.
7. Lưu link repository để điền vào biểu mẫu thầy gửi ngày 08/11.

## E. Bảo mật

- **Tuyệt đối không** upload ảnh chụp terminal có hiện password, câu `ALTER USER ... IDENTIFIED BY ...`, file `.env`, key/token, MySQL error log hay bản backup chứa thông tin cá nhân.
- Dùng kết nối MySQL riêng trên từng máy; không đưa username/password thật vào README hoặc câu lệnh chạy.
- Một mật khẩu MySQL từng xuất hiện trong ảnh trao đổi khi cấu hình trước đó. Nên đổi mật khẩu đó trước khi công bố mã/tài liệu hoặc cấp quyền cho bên ngoài.
- `.gitignore` chỉ ngăn file chưa được Git theo dõi; nếu lỡ commit bí mật, chỉ xóa file khỏi repo là **chưa đủ** — phải thay đổi/thu hồi bí mật và kiểm tra lịch sử commit.

## F. Khi chưa có seed/queries/views

Bản T05 được chấp nhận ở trạng thái **scaffold/documentation ready**, chưa được tự đánh dấu **full execution verified**. Sau khi các bạn nộp và review, cập nhật README, xóa nhãn chờ, kiểm thử lại, rồi mới chốt T05 hoàn thành ở mức bàn giao cuối.