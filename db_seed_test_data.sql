/*
================================================================================
  MomAndBaby / ClothesShop — DỮ LIỆU TEST (seed)
================================================================================
  Chạy SAU KHI đã có schema v2:
    1) db_v2.sql (tạo DB mới) HOẶC db_patch_clotheshop.sql (DB cũ)

  Mật khẩu tất cả tài khoản mẫu: 123456

  Tài khoản:
    admin / 123456     → /MomAndBaby/admin/login
    staff / 123456     → /MomAndBaby/staff/login
    user1, user2, user3 / 123456 → đăng ký user

  Mã giảm giá: MOM10, SAVE50K, FREESHIP (xem bảng Voucher)

  CẢNH BÁO: Bỏ comment khối /*RESET*/ bên dưới nếu muốn xóa dữ liệu cũ trước khi seed.
================================================================================
*/
USE ClothesShop;
GO

SET NOCOUNT ON;

/* ======================== RESET (tuỳ chọn) ======================== */
/*
DELETE FROM dbo.BillDetail;
DELETE FROM dbo.Bill;
DELETE FROM dbo.Cart;
DELETE FROM dbo.Wishlist;
DELETE FROM dbo.Feedback;
DELETE FROM dbo.imgDescription;
DELETE FROM dbo.ProductVariant;
DELETE FROM dbo.Product;
DELETE FROM dbo.BlogComment;
DELETE FROM dbo.BlogPostTag;
DELETE FROM dbo.BlogPost;
DELETE FROM dbo.BlogTag;
DELETE FROM dbo.BlogCategory;
DELETE FROM dbo.Voucher;
DELETE FROM dbo.[Account];
DELETE FROM dbo.Brand;
DELETE FROM dbo.Category;
DELETE FROM dbo.Producer;
DELETE FROM dbo.[Role];
DBCC CHECKIDENT ('dbo.Product', RESEED, 0);
DBCC CHECKIDENT ('dbo.ProductVariant', RESEED, 0);
DBCC CHECKIDENT ('dbo.[Account]', RESEED, 0);
*/

/* ======================== ROLE ======================== */
IF NOT EXISTS (SELECT 1 FROM dbo.[Role])
BEGIN
    SET IDENTITY_INSERT dbo.[Role] ON;
    INSERT INTO dbo.[Role] (ID, name, status) VALUES
     (1, N'admin', 1),
     (2, N'staff', 1),
     (3, N'user',  1);
    SET IDENTITY_INSERT dbo.[Role] OFF;
END
GO

/* ======================== PRODUCER / BRAND / CATEGORY ======================== */
IF NOT EXISTS (SELECT 1 FROM dbo.Producer)
BEGIN
    INSERT INTO dbo.Producer (name, status) VALUES
     (N'Công ty TNHH Mẹ & Bé Việt', 1),
     (N'Kids Fashion Import', 1),
     (N'BabyCare Factory', 1),
     (N'Organic Baby Co.', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Brand)
BEGIN
    INSERT INTO dbo.Brand (name, img, status) VALUES
     (N'Chicco', N'./uploads/brand/chicco.png', 1),
     (N'Pampers', N'./uploads/brand/pampers.png', 1),
     (N'Huggies', N'./uploads/brand/huggies.png', 1),
     (N'Gerber', N'./uploads/brand/gerber.png', 1),
     (N'Mothercare', N'./uploads/brand/mothercare.png', 1),
     (N'Fisher-Price', N'./uploads/brand/fisher.png', 1),
     (N'Combi', N'./uploads/brand/combi.png', 1),
     (N'Aprica', N'./uploads/brand/aprica.png', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Category)
BEGIN
    DECLARE @sgC INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'CLOTHING');
    DECLARE @sgS INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'SHOES');
    DECLARE @sgO INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'ONESIZE');
    INSERT INTO dbo.Category (name, slug, sizeGroupID, status) VALUES
     (N'Quần áo sơ sinh', N'quan-ao-so-sinh', @sgC, 1),
     (N'Đồ bộ bé trai', N'do-bo-be-trai', @sgC, 1),
     (N'Đồ bộ bé gái', N'do-bo-be-gai', @sgC, 1),
     (N'Giày dép', N'giay-dep', @sgS, 1),
     (N'Phụ kiện', N'phu-kien', @sgO, 1),
     (N'Đồ chơi', N'do-choi', @sgO, 1);
END
GO

/* SizeOption / ColorOption: db_v2.sql đã seed ID 1–6 */

/* ======================== ACCOUNTS ======================== */
IF NOT EXISTS (SELECT 1 FROM dbo.[Account] WHERE username = N'admin')
BEGIN
    /* MD5('123456') = E10ADC3949BA59ABBE56E057F20F883E */
    INSERT INTO dbo.[Account] (fullname, email, phone, username, password, role, status) VALUES
     (N'Quản trị viên', N'admin@momandbaby.local', N'0901000001', N'admin', N'E10ADC3949BA59ABBE56E057F20F883E', 1, 1),
     (N'Nhân viên kho', N'staff@momandbaby.local', N'0901000002', N'staff', N'E10ADC3949BA59ABBE56E057F20F883E', 2, 1),
     (N'Nguyễn Thị Lan', N'user1@test.com', N'0902000001', N'user1', N'E10ADC3949BA59ABBE56E057F20F883E', 3, 1),
     (N'Trần Văn Minh', N'user2@test.com', N'0902000002', N'user2', N'E10ADC3949BA59ABBE56E057F20F883E', 3, 1),
     (N'Lê Thị Hoa', N'user3@test.com', N'0902000003', N'user3', N'E10ADC3949BA59ABBE56E057F20F883E', 3, 1);
END
GO

/* ======================== VOUCHER ======================== */
IF NOT EXISTS (SELECT 1 FROM dbo.Voucher WHERE code = N'MOM10')
    INSERT INTO dbo.Voucher (name, code, discountType, value, minOrderAmount, maxDiscount, usageLimit, used, start, [end], status)
    VALUES (N'Giảm 10%', N'MOM10', 1, 10, 200000, 100000, 500, 0, CAST(GETDATE() AS DATE), DATEADD(YEAR, 1, CAST(GETDATE() AS DATE)), 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Voucher WHERE code = N'SAVE50K')
    INSERT INTO dbo.Voucher (name, code, discountType, value, minOrderAmount, maxDiscount, usageLimit, used, start, [end], status)
    VALUES (N'Giảm 50.000đ', N'SAVE50K', 0, 50000, 300000, NULL, 200, 0, CAST(GETDATE() AS DATE), DATEADD(YEAR, 1, CAST(GETDATE() AS DATE)), 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Voucher WHERE code = N'WELCOME20')
    INSERT INTO dbo.Voucher (name, code, discountType, value, minOrderAmount, maxDiscount, usageLimit, used, start, [end], status)
    VALUES (N'Giảm 20% tân thủ', N'WELCOME20', 1, 20, 150000, 80000, 100, 0, CAST(GETDATE() AS DATE), DATEADD(MONTH, 3, CAST(GETDATE() AS DATE)), 1);
GO

/* ======================== BLOG ======================== */
IF NOT EXISTS (SELECT 1 FROM dbo.BlogCategory)
BEGIN
    INSERT INTO dbo.BlogCategory (name, slug, description, status, sortOrder) VALUES
     (N'Chăm sóc bé', N'cham-soc-be', N'Mẹo chăm sóc trẻ nhỏ', 1, 1),
     (N'Xu hướng thời trang', N'xu-huong', N'Thời trang mẹ và bé', 1, 2);
END

IF NOT EXISTS (SELECT 1 FROM dbo.BlogPost)
BEGIN
    DECLARE @adminId INT = (SELECT TOP 1 ID FROM dbo.[Account] WHERE username = N'admin');
    DECLARE @cat1 INT = (SELECT TOP 1 ID FROM dbo.BlogCategory ORDER BY ID);
    IF @adminId IS NOT NULL AND @cat1 IS NOT NULL
    BEGIN
        INSERT INTO dbo.BlogPost (blogCategoryID, authorAccountID, title, slug, excerpt, contentHtml, status, isFeatured, publishedAt, viewCount)
        VALUES
         (@cat1, @adminId, N'5 mẹo chọn size quần áo cho bé', N'5-meo-chon-size',
          N'Hướng dẫn chọn size theo cân nặng và chiều cao.',
          N'<p>Chọn size phù hợp giúp bé thoải mái vận động...</p>', 1, 1, SYSUTCDATETIME(), 12),
         (@cat1, @adminId, N'Giặt đồ sơ sinh đúng cách', N'giat-do-so-sinh',
          N'Cách giặt không gây kích ứng da bé.',
          N'<p>Dùng nước ấm, xà phòng dịu nhẹ...</p>', 1, 0, SYSUTCDATETIME(), 5);
    END
END
GO

/* ======================== PRODUCTS + VARIANTS (40 SP × 2–3 SKU) ======================== */
IF (SELECT COUNT(*) FROM dbo.Product) < 5
BEGIN
    DECLARE @i INT = 1;
    DECLARE @pid INT;
    DECLARE @catCount INT = (SELECT COUNT(*) FROM dbo.Category);
    DECLARE @brandCount INT = (SELECT COUNT(*) FROM dbo.Brand);
    DECLARE @prodCount INT = (SELECT COUNT(*) FROM dbo.Producer);
    DECLARE @catId INT, @brandId INT, @prodId INT;
    DECLARE @name NVARCHAR(500), @slug NVARCHAR(320), @sku NVARCHAR(80);
    DECLARE @basePrice DECIMAL(18,2);
    DECLARE @priority INT;

    WHILE @i <= 40
    BEGIN
        SET @catId = ((@i - 1) % @catCount) + 1;
        SET @brandId = ((@i - 1) % @brandCount) + 1;
        SET @prodId = ((@i - 1) % @prodCount) + 1;
        SET @priority = CASE WHEN @i % 7 = 0 THEN 3 WHEN @i % 5 = 0 THEN 2 ELSE 1 END;
        SET @name = N'Sản phẩm mẫu #' + CAST(@i AS NVARCHAR(10));
        SET @slug = N'san-pham-mau-' + CAST(@i AS NVARCHAR(10));
        SET @basePrice = 80000 + (@i * 15000);

        INSERT INTO dbo.Product (name, slug, description, mainImg, status, model, priority, categoryID, producerID, brandID)
        VALUES (
            @name, @slug,
            N'Mô tả chi tiết cho ' + @name + N'. Chất liệu cotton mềm, phù hợp bé từ 0–24 tháng.',
            CASE (@i % 6)
                WHEN 0 THEN 'https://images.unsplash.com/photo-1515488042361-ee00e817a227?w=600&q=80'
                WHEN 1 THEN 'https://images.unsplash.com/photo-1522771739844-6a9f6d2fafa1?w=600&q=80'
                WHEN 2 THEN 'https://images.unsplash.com/photo-1503454537199-1eabb201c6af?w=600&q=80'
                WHEN 3 THEN 'https://images.unsplash.com/photo-1519457431-44ccd64b83b4?w=600&q=80'
                WHEN 4 THEN 'https://images.unsplash.com/photo-1503919005314-30d933d1b58f?w=600&q=80'
                ELSE 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=80'
            END,
            1, N'MDL-' + CAST(@i AS NVARCHAR(10)), @priority, @catId, @prodId, @brandId
        );
        SET @pid = SCOPE_IDENTITY();

        /* Variant 1: size M + màu mặc định */
        SET @sku = N'SKU-' + CAST(@pid AS NVARCHAR(10)) + N'-M-DEF';
        INSERT INTO dbo.ProductVariant (productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity, isDefault, status)
        VALUES (@pid, 4, 1, @sku, @basePrice * 1.2, @basePrice, 50 + @i, 1, 1);

        /* Variant 2: size L + hồng */
        SET @sku = N'SKU-' + CAST(@pid AS NVARCHAR(10)) + N'-L-PINK';
        INSERT INTO dbo.ProductVariant (productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity, isDefault, status)
        VALUES (@pid, 5, 2, @sku, @basePrice * 1.15, @basePrice * 0.95, 40 + @i, 0, 1);

        /* Variant 3: mỗi SP thứ 3 có thêm size S xanh */
        IF @i % 3 = 0
        BEGIN
            SET @sku = N'SKU-' + CAST(@pid AS NVARCHAR(10)) + N'-S-BLUE';
            INSERT INTO dbo.ProductVariant (productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity, isDefault, status)
            VALUES (@pid, 3, 3, @sku, @basePrice * 1.1, @basePrice * 0.9, 30, 0, 1);
        END

        SET @i = @i + 1;
    END

    PRINT N'Đã seed 40 sản phẩm + biến thể SKU.';
END
ELSE
    PRINT N'Bỏ qua seed Product (đã có >= 5 sản phẩm).';
GO

/* ======================== GIỎ HÀNG MẪU (user1) ======================== */
DECLARE @u1 INT = (SELECT TOP 1 ID FROM dbo.[Account] WHERE username = N'user1');
IF @u1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Cart WHERE accountID = @u1)
BEGIN
    INSERT INTO dbo.Cart (accountID, productVariantID, quantity)
    SELECT TOP 2 @u1, v.ID, 2
    FROM dbo.ProductVariant v
    WHERE v.isDefault = 1
    ORDER BY v.ID;
    PRINT N'Đã thêm 2 dòng giỏ cho user1.';
END
GO

PRINT N'=== db_seed_test_data.sql hoàn tất ===';
GO
