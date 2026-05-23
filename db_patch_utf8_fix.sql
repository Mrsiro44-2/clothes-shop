/*
  Sửa dữ liệu tiếng Việt đã lưu sai (nếu DB/collation cũ gây lỗi chữ).
  Chạy SAU khi deploy app có Utf8EncodingFilter + connection Unicode.
*/
USE ClothesShop;
GO

/* Đảm bảo cột text dùng NVARCHAR (Unicode) — chỉ chạy nếu cột vẫn là VARCHAR */
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'dbo.Account') AND name = N'fullname'
      AND system_type_id = TYPE_ID(N'varchar')
)
BEGIN
    ALTER TABLE dbo.Account ALTER COLUMN fullname NVARCHAR(200) NOT NULL;
    ALTER TABLE dbo.Account ALTER COLUMN email NVARCHAR(200) NOT NULL;
    ALTER TABLE dbo.Account ALTER COLUMN phone NVARCHAR(50) NULL;
END
GO

PRINT N'UTF-8 patch completed. Nếu tài khoản vẫn hiển thị sai chữ, cập nhật lại họ tên/email trong trang Tài khoản.';
GO
