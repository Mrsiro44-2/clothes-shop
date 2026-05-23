/*
  Chạy trên database ClothesShop đã có (migrate từ schema cũ).
  - Xóa bảng Banner
  - Chuẩn hóa Voucher (discountType, minOrderAmount, usageLimit, maxDiscount)
  - Liên kết Bill ↔ Voucher
*/
USE ClothesShop;
GO

IF OBJECT_ID(N'dbo.Banner', N'U') IS NOT NULL
    DROP TABLE dbo.Banner;
GO

/* Voucher: thêm cột mới nếu chưa có */
IF COL_LENGTH('dbo.Voucher', 'discountType') IS NULL
    ALTER TABLE dbo.Voucher ADD discountType INT NOT NULL CONSTRAINT DF_Voucher_discountType DEFAULT 0;
GO

IF COL_LENGTH('dbo.Voucher', 'minOrderAmount') IS NULL
BEGIN
    ALTER TABLE dbo.Voucher ADD minOrderAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Voucher_minOrder DEFAULT 0;
    IF COL_LENGTH('dbo.Voucher', 'limit') IS NOT NULL
        EXEC(N'UPDATE dbo.Voucher SET minOrderAmount = ISNULL([limit], 0)');
END
GO

IF COL_LENGTH('dbo.Voucher', 'maxDiscount') IS NULL
    ALTER TABLE dbo.Voucher ADD maxDiscount DECIMAL(18,2) NULL;
GO

IF COL_LENGTH('dbo.Voucher', 'usageLimit') IS NULL
BEGIN
    ALTER TABLE dbo.Voucher ADD usageLimit INT NULL;
    /* Cột [limit] cũ đôi khi bị dùng nhầm làm số lần dùng — giữ used, không auto-migrate usageLimit */
END
GO

/* Bill: liên kết voucher */
IF COL_LENGTH('dbo.Bill', 'subtotal') IS NULL
    ALTER TABLE dbo.Bill ADD subtotal DECIMAL(18,2) NULL;
GO

IF COL_LENGTH('dbo.Bill', 'discountAmount') IS NULL
    ALTER TABLE dbo.Bill ADD discountAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Bill_discount DEFAULT 0;
GO

IF COL_LENGTH('dbo.Bill', 'voucherID') IS NULL
    ALTER TABLE dbo.Bill ADD voucherID INT NULL;
GO

IF COL_LENGTH('dbo.Bill', 'voucherCodeSnapshot') IS NULL
    ALTER TABLE dbo.Bill ADD voucherCodeSnapshot NVARCHAR(80) NULL;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Bill_Voucher'
)
BEGIN
    ALTER TABLE dbo.Bill
        ADD CONSTRAINT FK_Bill_Voucher FOREIGN KEY (voucherID) REFERENCES dbo.Voucher(ID);
END
GO

/* Voucher mẫu (tùy chọn) */
IF NOT EXISTS (SELECT 1 FROM dbo.Voucher WHERE code = N'MOM10')
BEGIN
    INSERT INTO dbo.Voucher (name, code, discountType, value, minOrderAmount, maxDiscount, usageLimit, used, start, [end], status)
    VALUES (N'Giảm 10%', N'MOM10', 1, 10, 200000, 100000, 100, 0, CAST(GETDATE() AS DATE), DATEADD(MONTH, 6, CAST(GETDATE() AS DATE)), 1);
END
GO

PRINT N'Migration ClothesShop completed.';
PRINT N'Tiếp theo chạy: db_seed_test_data.sql để nạp dữ liệu test.';
GO
