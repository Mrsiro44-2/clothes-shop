/*
  Chạy trên database ClothesShop (đã có schema v2).
  Lưu ý SSMS: KHÔNG chèn GO giữa DECLARE và lệnh dùng @biến — mỗi GO = batch mới.

  Góp ý:
  - ProductVariant: bỏ sold; giữ oldPrice/newPrice (giá gốc / giá bán).
  - SizeOption nhóm theo SizeGroup; Category.sizeGroupID lọc size khi nhập variant.
*/
USE ClothesShop;
GO

/* ======================== SizeGroup ======================== */
IF OBJECT_ID(N'dbo.SizeGroup', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SizeGroup (
        ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        code        NVARCHAR(50) NOT NULL,
        name        NVARCHAR(100) NOT NULL,
        sortOrder   INT NOT NULL DEFAULT 0,
        status      INT NOT NULL DEFAULT 1,
        CONSTRAINT UX_SizeGroup_code UNIQUE (code)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.SizeGroup WHERE code = N'CLOTHING')
    INSERT INTO dbo.SizeGroup (code, name, sortOrder, status) VALUES
     (N'CLOTHING', N'Quần áo (S/M/L...)', 10, 1),
     (N'SHOES',   N'Giày dép (số size)', 20, 1),
     (N'ONESIZE', N'Phụ kiện / một size', 30, 1);
GO

/* ======================== SizeOption + Category (một batch — giữ biến) ======================== */
DECLARE @grpClothing INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'CLOTHING');
DECLARE @grpShoes    INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'SHOES');
DECLARE @grpOnesize  INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'ONESIZE');

IF @grpClothing IS NULL OR @grpShoes IS NULL OR @grpOnesize IS NULL
BEGIN
    RAISERROR(N'Thieu du lieu SizeGroup (CLOTHING/SHOES/ONESIZE). Chay lai phan INSERT SizeGroup.', 16, 1);
    RETURN;
END

IF COL_LENGTH('dbo.SizeOption', 'sizeGroupID') IS NULL
    ALTER TABLE dbo.SizeOption ADD sizeGroupID INT NULL;

UPDATE dbo.SizeOption SET sizeGroupID = @grpClothing WHERE sizeGroupID IS NULL;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_SizeOption_SizeGroup')
BEGIN
    ALTER TABLE dbo.SizeOption
        ADD CONSTRAINT FK_SizeOption_SizeGroup FOREIGN KEY (sizeGroupID) REFERENCES dbo.SizeGroup(ID);
END

IF EXISTS (SELECT 1 FROM dbo.SizeOption WHERE sizeGroupID IS NULL)
    RAISERROR(N'Con SizeOption chua co sizeGroupID — kiem tra du lieu.', 16, 1);
ELSE IF COL_LENGTH('dbo.SizeOption', 'sizeGroupID') IS NOT NULL
    ALTER TABLE dbo.SizeOption ALTER COLUMN sizeGroupID INT NOT NULL;

IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S16' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S16', N'16', 10, 1, @grpShoes);
IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S17' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S17', N'17', 20, 1, @grpShoes);
IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S18' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S18', N'18', 30, 1, @grpShoes);
IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S19' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S19', N'19', 40, 1, @grpShoes);
IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S20' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S20', N'20', 50, 1, @grpShoes);
IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'S21' AND sizeGroupID = @grpShoes)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'S21', N'21', 60, 1, @grpShoes);

IF NOT EXISTS (SELECT 1 FROM dbo.SizeOption WHERE code = N'OS' AND sizeGroupID = @grpOnesize)
    INSERT INTO dbo.SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (N'OS', N'One size', 0, 1, @grpOnesize);

IF COL_LENGTH('dbo.Category', 'sizeGroupID') IS NULL
    ALTER TABLE dbo.Category ADD sizeGroupID INT NULL;

UPDATE c SET sizeGroupID = @grpClothing
FROM dbo.Category c
WHERE c.sizeGroupID IS NULL
  AND NOT (c.slug LIKE N'%giay%' OR c.name LIKE N'%Giày%' OR c.name LIKE N'%giày%'
       OR c.slug LIKE N'%phu-kien%' OR c.slug LIKE N'%do-choi%'
       OR c.name LIKE N'%Phụ kiện%' OR c.name LIKE N'%Đồ chơi%');

UPDATE c SET sizeGroupID = @grpShoes
FROM dbo.Category c
WHERE c.sizeGroupID IS NULL
  AND (c.slug LIKE N'%giay%' OR c.name LIKE N'%Giày%' OR c.name LIKE N'%giày%');

UPDATE c SET sizeGroupID = @grpOnesize
FROM dbo.Category c
WHERE c.sizeGroupID IS NULL
  AND (c.slug LIKE N'%phu-kien%' OR c.slug LIKE N'%do-choi%'
       OR c.name LIKE N'%Phụ kiện%' OR c.name LIKE N'%Đồ chơi%');

UPDATE dbo.Category SET sizeGroupID = @grpClothing WHERE sizeGroupID IS NULL;

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Category_SizeGroup')
BEGIN
    ALTER TABLE dbo.Category
        ADD CONSTRAINT FK_Category_SizeGroup FOREIGN KEY (sizeGroupID) REFERENCES dbo.SizeGroup(ID);
END

IF EXISTS (SELECT 1 FROM dbo.Category WHERE sizeGroupID IS NULL)
    RAISERROR(N'Con Category chua co sizeGroupID — kiem tra du lieu.', 16, 1);
ELSE IF COL_LENGTH('dbo.Category', 'sizeGroupID') IS NOT NULL
    ALTER TABLE dbo.Category ALTER COLUMN sizeGroupID INT NOT NULL;
GO

/* ======================== ProductVariant: bỏ sold ======================== */
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_ProductVariant_sold')
    ALTER TABLE dbo.ProductVariant DROP CONSTRAINT CK_ProductVariant_sold;

DECLARE @dropSoldDefault NVARCHAR(400);
SELECT @dropSoldDefault = N'ALTER TABLE dbo.ProductVariant DROP CONSTRAINT ' + QUOTENAME(dc.name)
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON c.default_object_id = dc.object_id
INNER JOIN sys.tables t ON t.object_id = c.object_id
WHERE t.name = N'ProductVariant' AND SCHEMA_NAME(t.schema_id) = N'dbo' AND c.name = N'sold';

IF @dropSoldDefault IS NOT NULL
    EXEC sp_executesql @dropSoldDefault;

IF COL_LENGTH('dbo.ProductVariant', 'sold') IS NOT NULL
    ALTER TABLE dbo.ProductVariant DROP COLUMN sold;
GO

CREATE OR ALTER VIEW dbo.vw_ProductPriceStock AS
SELECT
    p.ID AS productID,
    MIN(v.newPrice) AS minPrice,
    MAX(v.newPrice) AS maxPrice,
    SUM(v.quantity) AS totalQuantity
FROM dbo.Product p
JOIN dbo.ProductVariant v ON v.productID = p.ID AND v.status = 1
GROUP BY p.ID;
GO

PRINT N'Migration variant/size completed.';
GO
