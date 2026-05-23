/*
  Sửa tài khoản đã đăng ký nhầm role staff (2) -> user (3)
  và hash mật khẩu plain text sang MD5 (hex HOA).
  Chạy trên DB ClothesShop sau khi deploy code mới.
*/
USE ClothesShop;
GO

/* Tài khoản khách đăng ký web bị gán role staff (trừ user staff hệ thống) */
UPDATE dbo.[Account]
SET role = 3
WHERE role = 2
  AND username <> N'staff';
GO

/* Hash mật khẩu chưa phải MD5 (độ dài khác 32 hoặc không phải hex) */
UPDATE dbo.[Account]
SET password = UPPER(CONVERT(VARCHAR(32), HASHBYTES('MD5', CAST(password AS VARCHAR(256))), 2))
WHERE password IS NULL
   OR LEN(LTRIM(RTRIM(password))) <> 32
   OR password NOT LIKE '%[0-9A-Fa-f]%';
GO

/* Hoặc ép hash toàn bộ mật khẩu dạng text ngắn (ví dụ 123456) */
UPDATE dbo.[Account]
SET password = UPPER(CONVERT(VARCHAR(32), HASHBYTES('MD5', CAST(password AS VARCHAR(256))), 2))
WHERE LEN(password) < 32;
GO
