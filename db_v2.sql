/*
================================================================================
  MomAndBaby — Database schema VERSION 2 (SQL Server)
================================================================================
  Mục tiêu v2 (so với v1 trong code hiện tại):
  - Sản phẩm (Product) chỉ còn là "master": mô tả, danh mục, thương hiệu, ảnh chính...
  - Mỗi tổ hợp Size + Màu (và tuỳ chọn thêm thuộc tính khác sau này) là một dòng
    trong ProductVariant (SKU): GIÁ RIÊNG, TỒN KHO RIÊNG, MÃ SKU/BARCODE.
  - Giỏ hàng (Cart) và chi tiết đơn (BillDetail) trỏ tới ProductVariant — không
    còn nhầm giá/tồn ở cấp Product như bảng Size cũ (chỉ có size, chưa có màu).

  Ghi chú triển khai app:
  - Giá hiển thị trên danh sách SP: thường lấy MIN(newPrice) hoặc biến thể mặc định.
  - BillDetail lưu thêm các cột snapshot (tên, ảnh, size, màu, giá tại thời điểm mua)
    để sau này đổi/xóa variant vẫn in được hóa đơn cũ.
  - Blog: danh mục bài viết, bài viết (SEO, lượt xem, đăng/nháp), tag nhiều-nhiều,
    bình luận (user đăng nhập hoặc khách có tên/email), trả lời lồng nhau (parentCommentID).

  Chạy script trên database trống hoặc chỉnh phần DROP phù hợp môi trường của bạn.
================================================================================
*/

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* ---------- Optional: tạo database (bỏ comment nếu cần) ----------
CREATE DATABASE MomAndBaby_v2;
GO
USE MomAndBaby_v2;
GO
*/

/* ---------- Xóa theo thứ tự phụ thuộc (chỉ dùng khi reset schema dev) ----------
IF OBJECT_ID(N'dbo.vw_BlogPublishedPost', N'V') IS NOT NULL DROP VIEW dbo.vw_BlogPublishedPost;
IF OBJECT_ID(N'dbo.vw_ProductPriceStock', N'V') IS NOT NULL DROP VIEW dbo.vw_ProductPriceStock;
IF OBJECT_ID(N'dbo.Wishlist', N'U') IS NOT NULL DROP TABLE dbo.Wishlist;
IF OBJECT_ID(N'dbo.Cart', N'U') IS NOT NULL DROP TABLE dbo.Cart;
IF OBJECT_ID(N'dbo.BillDetail', N'U') IS NOT NULL DROP TABLE dbo.BillDetail;
IF OBJECT_ID(N'dbo.Bill', N'U') IS NOT NULL DROP TABLE dbo.Bill;
IF OBJECT_ID(N'dbo.Feedback', N'U') IS NOT NULL DROP TABLE dbo.Feedback;
IF OBJECT_ID(N'dbo.imgDescription', N'U') IS NOT NULL DROP TABLE dbo.imgDescription;
IF OBJECT_ID(N'dbo.ProductVariant', N'U') IS NOT NULL DROP TABLE dbo.ProductVariant;
IF OBJECT_ID(N'dbo.Product', N'U') IS NOT NULL DROP TABLE dbo.Product;
IF OBJECT_ID(N'dbo.ColorOption', N'U') IS NOT NULL DROP TABLE dbo.ColorOption;
IF OBJECT_ID(N'dbo.SizeOption', N'U') IS NOT NULL DROP TABLE dbo.SizeOption;
IF OBJECT_ID(N'dbo.Voucher', N'U') IS NOT NULL DROP TABLE dbo.Voucher;
IF OBJECT_ID(N'dbo.Category', N'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID(N'dbo.Brand', N'U') IS NOT NULL DROP TABLE dbo.Brand;
IF OBJECT_ID(N'dbo.Producer', N'U') IS NOT NULL DROP TABLE dbo.Producer;
IF OBJECT_ID(N'dbo.BlogComment', N'U') IS NOT NULL DROP TABLE dbo.BlogComment;
IF OBJECT_ID(N'dbo.BlogPostTag', N'U') IS NOT NULL DROP TABLE dbo.BlogPostTag;
IF OBJECT_ID(N'dbo.BlogPost', N'U') IS NOT NULL DROP TABLE dbo.BlogPost;
IF OBJECT_ID(N'dbo.BlogTag', N'U') IS NOT NULL DROP TABLE dbo.BlogTag;
IF OBJECT_ID(N'dbo.BlogCategory', N'U') IS NOT NULL DROP TABLE dbo.BlogCategory;
IF OBJECT_ID(N'dbo.Account', N'U') IS NOT NULL DROP TABLE dbo.Account;
IF OBJECT_ID(N'dbo.Role', N'U') IS NOT NULL DROP TABLE dbo.Role;
GO
*/

/* ============================ CORE AUTH ============================ */

CREATE TABLE dbo.[Role] (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    status      INT NOT NULL DEFAULT 1 /* 1 active */
);

CREATE TABLE dbo.[Account] (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fullname    NVARCHAR(200) NOT NULL,
    email       NVARCHAR(200) NOT NULL,
    phone       NVARCHAR(50)  NULL,
    username    NVARCHAR(100) NOT NULL,
    password    NVARCHAR(500) NOT NULL,
    role        INT NOT NULL FOREIGN KEY REFERENCES dbo.[Role](ID),
    [date]      DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    status      INT NOT NULL DEFAULT 1,
    avatar      NVARCHAR(500) NULL,
    CONSTRAINT UX_Account_username UNIQUE (username)
);

CREATE INDEX IX_Account_role ON dbo.[Account](role);

/* ============================ CATALOG MASTER ============================ */

CREATE TABLE dbo.Producer (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    datePost    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate  DATETIME2(3) NULL,
    status      INT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Brand (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    img         NVARCHAR(500) NULL,
    datePost    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate  DATETIME2(3) NULL,
    status      INT NOT NULL DEFAULT 1
);

/* Nhóm size: quần áo, giày, one-size — Category trỏ sizeGroupID để lọc khi nhập variant */
CREATE TABLE dbo.SizeGroup (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code        NVARCHAR(50) NOT NULL,
    name        NVARCHAR(100) NOT NULL,
    sortOrder   INT NOT NULL DEFAULT 0,
    status      INT NOT NULL DEFAULT 1,
    CONSTRAINT UX_SizeGroup_code UNIQUE (code)
);

CREATE TABLE dbo.Category (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    slug        NVARCHAR(220) NULL /* dùng cho URL đẹp; có thể unique sau khi seed */,
    sizeGroupID INT NOT NULL FOREIGN KEY REFERENCES dbo.SizeGroup(ID),
    datePost    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate  DATETIME2(3) NULL,
    status      INT NOT NULL DEFAULT 1
);

CREATE INDEX IX_Category_slug ON dbo.Category(slug) WHERE slug IS NOT NULL;

CREATE TABLE dbo.SizeOption (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code        NVARCHAR(50) NULL /* ví dụ: S, M, L, XL */,
    label       NVARCHAR(100) NOT NULL /* hiển thị */,
    sortOrder   INT NOT NULL DEFAULT 0,
    status      INT NOT NULL DEFAULT 1,
    sizeGroupID INT NOT NULL FOREIGN KEY REFERENCES dbo.SizeGroup(ID)
);

CREATE TABLE dbo.ColorOption (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    hexCode     CHAR(7) NULL /* #RRGGBB */,
    sortOrder   INT NOT NULL DEFAULT 0,
    status      INT NOT NULL DEFAULT 1
);

/*
  Product v2: KHÔNG còn quantity/sold/oldPrice/newPrice tại cấp SP — thống nhất ở SKU.
  (Nếu bạn vẫn muốn hiển thị "giá niêm yết chung", có thể thêm baseOldPrice/baseNewPrice nullable.)
*/
CREATE TABLE dbo.Product (
    ID            INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name          NVARCHAR(500) NOT NULL,
    slug          NVARCHAR(320) NULL,
    description   NVARCHAR(MAX) NULL,
    datePost      DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate    DATETIME2(3) NULL,
    mainImg       NVARCHAR(500) NULL,
    status        INT NOT NULL DEFAULT 1 /* 1 on sale */,
    model         NVARCHAR(200) NULL,
    priority      INT NOT NULL DEFAULT 0,
    categoryID    INT NOT NULL FOREIGN KEY REFERENCES dbo.Category(ID),
    producerID    INT NOT NULL FOREIGN KEY REFERENCES dbo.Producer(ID),
    brandID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Brand(ID)
);

CREATE INDEX IX_Product_category ON dbo.Product(categoryID);
CREATE INDEX IX_Product_brand ON dbo.Product(brandID);
CREATE INDEX IX_Product_status_priority ON dbo.Product(status, priority DESC);

/*
  ProductVariant = SKU: mỗi cặp (product + size + color) một giá & một kho.
  - isDefault: biến thể được chọn mặc định khi vào trang chi tiết (tuỳ app).
*/
CREATE TABLE dbo.ProductVariant (
    ID              INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    productID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Product(ID) ON DELETE CASCADE,
    sizeOptionID    INT NOT NULL FOREIGN KEY REFERENCES dbo.SizeOption(ID),
    colorOptionID   INT NOT NULL FOREIGN KEY REFERENCES dbo.ColorOption(ID),
    sku             NVARCHAR(80) NOT NULL,
    barcode         NVARCHAR(80) NULL,
    oldPrice        DECIMAL(18,2) NOT NULL DEFAULT 0,
    newPrice        DECIMAL(18,2) NOT NULL,
    quantity        INT NOT NULL DEFAULT 0,
    variantImg      NVARCHAR(500) NULL /* ảnh đại diện riêng cho màu/size */,
    weightGrams     INT NULL,
    isDefault       BIT NOT NULL DEFAULT 0,
    status          INT NOT NULL DEFAULT 1 /* 1 active */,
    dateCreated     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdated     DATETIME2(3) NULL,
    CONSTRAINT UX_ProductVariant_sku UNIQUE (sku),
    CONSTRAINT CK_ProductVariant_qty CHECK (quantity >= 0),
    CONSTRAINT CK_ProductVariant_price CHECK (newPrice >= 0 AND oldPrice >= 0)
);

CREATE UNIQUE INDEX UX_ProductVariant_product_size_color
    ON dbo.ProductVariant(productID, sizeOptionID, colorOptionID);

CREATE INDEX IX_ProductVariant_product ON dbo.ProductVariant(productID);

/* Ảnh mô tả gallery cấp sản phẩm (giữ tên bảng legacy imgDescription cho gần code cũ) */
CREATE TABLE dbo.imgDescription (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    imgUrl      NVARCHAR(500) NOT NULL,
    productID   INT NOT NULL FOREIGN KEY REFERENCES dbo.Product(ID) ON DELETE CASCADE,
    sortOrder   INT NOT NULL DEFAULT 0
);

CREATE INDEX IX_imgDescription_product ON dbo.imgDescription(productID);

CREATE TABLE dbo.Feedback (
    id          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    userId      INT NOT NULL FOREIGN KEY REFERENCES dbo.[Account](ID),
    productId   INT NOT NULL FOREIGN KEY REFERENCES dbo.Product(ID) ON DELETE CASCADE,
    comment     NVARCHAR(MAX) NOT NULL,
    star        INT NOT NULL DEFAULT 5,
    status      INT NOT NULL DEFAULT 1,
    datePost    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate  DATETIME2(3) NULL,
    CONSTRAINT CK_Feedback_star CHECK (star BETWEEN 1 AND 5)
);

CREATE INDEX IX_Feedback_product ON dbo.Feedback(productId);

/*
  Voucher:
  - discountType: 0 = giảm số tiền cố định (value = VND), 1 = giảm % (value = 0–100)
  - minOrderAmount: đơn tối thiểu để áp dụng
  - maxDiscount: trần giảm khi discountType = 1 (nullable)
  - usageLimit: số lần dùng tối đa toàn hệ thống (NULL = không giới hạn)
  - used: đã dùng (tăng khi Bill checkout thành công)
*/
CREATE TABLE dbo.Voucher (
    ID              INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name            NVARCHAR(200) NOT NULL,
    code            NVARCHAR(80) NOT NULL,
    discountType    INT NOT NULL DEFAULT 0,
    value           DECIMAL(18,2) NOT NULL,
    minOrderAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
    maxDiscount     DECIMAL(18,2) NULL,
    usageLimit      INT NULL,
    used            INT NOT NULL DEFAULT 0,
    start           DATE NOT NULL,
    [end]           DATE NOT NULL,
    status          INT NOT NULL DEFAULT 1,
    CONSTRAINT UX_Voucher_code UNIQUE (code),
    CONSTRAINT CK_Voucher_discountType CHECK (discountType IN (0, 1)),
    CONSTRAINT CK_Voucher_used CHECK (used >= 0)
);

/* ============================ BLOG / CONTENT ============================ */

CREATE TABLE dbo.BlogCategory (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(200) NOT NULL,
    slug        NVARCHAR(220) NOT NULL,
    description NVARCHAR(1000) NULL,
    coverImg    NVARCHAR(500) NULL,
    sortOrder   INT NOT NULL DEFAULT 0,
    status      INT NOT NULL DEFAULT 1 /* 1 hiển thị */,
    datePost    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate  DATETIME2(3) NULL,
    CONSTRAINT UX_BlogCategory_slug UNIQUE (slug)
);

CREATE INDEX IX_BlogCategory_status_sort ON dbo.BlogCategory(status, sortOrder);

/*
  BlogPost.status gợi ý: 0 = nháp, 1 = đã xuất bản, 2 = ẩn (gỡ khỏi public).
  publishedAt: thời điểm hiển thị bài; có thể NULL khi còn nháp.
*/
CREATE TABLE dbo.BlogPost (
    ID                  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    blogCategoryID      INT NULL FOREIGN KEY REFERENCES dbo.BlogCategory(ID) ON DELETE SET NULL,
    authorAccountID     INT NOT NULL FOREIGN KEY REFERENCES dbo.[Account](ID),
    title               NVARCHAR(500) NOT NULL,
    slug                NVARCHAR(320) NOT NULL,
    excerpt             NVARCHAR(1000) NULL,
    contentHtml         NVARCHAR(MAX) NOT NULL,
    coverImg            NVARCHAR(500) NULL,
    status              INT NOT NULL DEFAULT 0,
    isFeatured          BIT NOT NULL DEFAULT 0,
    publishedAt         DATETIME2(3) NULL,
    dateCreated         DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdated         DATETIME2(3) NULL,
    viewCount           INT NOT NULL DEFAULT 0,
    seoTitle            NVARCHAR(320) NULL,
    seoDescription      NVARCHAR(500) NULL,
    readingMinutes      SMALLINT NULL,
    CONSTRAINT UX_BlogPost_slug UNIQUE (slug),
    CONSTRAINT CK_BlogPost_views CHECK (viewCount >= 0)
);

CREATE INDEX IX_BlogPost_category ON dbo.BlogPost(blogCategoryID);
CREATE INDEX IX_BlogPost_author ON dbo.BlogPost(authorAccountID);
CREATE INDEX IX_BlogPost_status_published ON dbo.BlogPost(status, publishedAt DESC);
CREATE INDEX IX_BlogPost_featured ON dbo.BlogPost(isFeatured) WHERE isFeatured = 1;

CREATE TABLE dbo.BlogTag (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name        NVARCHAR(120) NOT NULL,
    slug        NVARCHAR(160) NOT NULL,
    CONSTRAINT UX_BlogTag_slug UNIQUE (slug)
);

CREATE TABLE dbo.BlogPostTag (
    blogPostID  INT NOT NULL FOREIGN KEY REFERENCES dbo.BlogPost(ID) ON DELETE CASCADE,
    blogTagID   INT NOT NULL FOREIGN KEY REFERENCES dbo.BlogTag(ID) ON DELETE CASCADE,
    CONSTRAINT PK_BlogPostTag PRIMARY KEY (blogPostID, blogTagID)
);

CREATE INDEX IX_BlogPostTag_tag ON dbo.BlogPostTag(blogTagID);

/*
  BlogComment: thành viên (accountID) HOẶC khách (guestName + guestEmail).
  status gợi ý: 0 chờ duyệt, 1 hiển thị, 2 ẩn/spam.
*/
CREATE TABLE dbo.BlogComment (
    ID                  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    blogPostID          INT NOT NULL FOREIGN KEY REFERENCES dbo.BlogPost(ID) ON DELETE CASCADE,
    accountID           INT NULL FOREIGN KEY REFERENCES dbo.[Account](ID) ON DELETE SET NULL,
    guestName           NVARCHAR(200) NULL,
    guestEmail          NVARCHAR(200) NULL,
    body                NVARCHAR(4000) NOT NULL,
    status              INT NOT NULL DEFAULT 0,
    parentCommentID     INT NULL FOREIGN KEY REFERENCES dbo.BlogComment(ID),
    datePost            DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate          DATETIME2(3) NULL,
    CONSTRAINT CK_BlogComment_author_or_guest CHECK (
        accountID IS NOT NULL
        OR (guestName IS NOT NULL AND guestEmail IS NOT NULL)
    )
);

CREATE INDEX IX_BlogComment_post ON dbo.BlogComment(blogPostID);
CREATE INDEX IX_BlogComment_status ON dbo.BlogComment(status);
CREATE INDEX IX_BlogComment_parent ON dbo.BlogComment(parentCommentID);

/* ============================ ORDERING ============================ */

CREATE TABLE dbo.Bill (
    id                  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    customerID          INT NULL FOREIGN KEY REFERENCES dbo.[Account](ID) /* NULL = khách vãng lai */,
    email               NVARCHAR(200) NOT NULL,
    customerName        NVARCHAR(200) NOT NULL,
    phone               NVARCHAR(50) NOT NULL,
    address             NVARCHAR(500) NOT NULL,
    detailAddress       NVARCHAR(500) NULL,
    subtotal            DECIMAL(18,2) NOT NULL DEFAULT 0 /* tổng trước giảm */,
    discountAmount      DECIMAL(18,2) NOT NULL DEFAULT 0,
    voucherID           INT NULL FOREIGN KEY REFERENCES dbo.Voucher(ID),
    voucherCodeSnapshot NVARCHAR(80) NULL,
    total               DECIMAL(18,2) NOT NULL /* sau giảm */,
    status              INT NOT NULL DEFAULT 0 /* tuỳ app: 0 chờ, 1 đang giao... */,
    payment             INT NOT NULL DEFAULT 0,
    dateOrder           DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    dateUpdate          DATETIME2(3) NULL,
    transactionCode     NVARCHAR(120) NULL
);

CREATE INDEX IX_Bill_customer ON dbo.Bill(customerID);
CREATE INDEX IX_Bill_status ON dbo.Bill(status);

/*
  BillDetail: productVariantID cho báo cáo/query; các cột snapshot (*) là bắt buộc cho lịch sử.
*/
CREATE TABLE dbo.BillDetail (
    ID                  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    billID              INT NOT NULL FOREIGN KEY REFERENCES dbo.Bill(id) ON DELETE CASCADE,
    productVariantID    INT NULL FOREIGN KEY REFERENCES dbo.ProductVariant(ID),
    productID           INT NOT NULL /* snapshot */,
    skuSnapshot         NVARCHAR(80) NOT NULL,
    nameProduct         NVARCHAR(500) NOT NULL,
    modelProduct        NVARCHAR(200) NULL,
    imgProduct          NVARCHAR(500) NULL,
    sizeLabelSnapshot   NVARCHAR(100) NOT NULL,
    colorLabelSnapshot  NVARCHAR(100) NOT NULL,
    priceProduct        DECIMAL(18,2) NOT NULL /* đơn giá tại thời điểm đặt */,
    numberOfProduct     INT NOT NULL,
    lineTotal           AS (CAST(priceProduct * numberOfProduct AS DECIMAL(18,2))) PERSISTED,
    CONSTRAINT CK_BillDetail_qty CHECK (numberOfProduct > 0),
    CONSTRAINT CK_BillDetail_price CHECK (priceProduct >= 0)
);

CREATE INDEX IX_BillDetail_bill ON dbo.BillDetail(billID);

/*
  Cart v2: mỗi dòng là một SKU — không thể gộp nhầm hai màu/size chỉ bằng productID.
*/
CREATE TABLE dbo.Cart (
    ID              INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    accountID       INT NOT NULL FOREIGN KEY REFERENCES dbo.[Account](ID) ON DELETE CASCADE,
    productVariantID INT NOT NULL FOREIGN KEY REFERENCES dbo.ProductVariant(ID) ON DELETE CASCADE,
    quantity        INT NOT NULL DEFAULT 1,
    dateAdded       DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    /* totalPrice trong code cũ có thể suy ra = quantity * newPrice của variant tại lúc xem giỏ */
    CONSTRAINT UX_Cart_user_variant UNIQUE (accountID, productVariantID),
    CONSTRAINT CK_Cart_qty CHECK (quantity > 0)
);

CREATE INDEX IX_Cart_account ON dbo.Cart(accountID);

CREATE TABLE dbo.PasswordResetToken (
    ID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    accountID   INT NOT NULL FOREIGN KEY REFERENCES dbo.[Account](ID) ON DELETE CASCADE,
    tokenHash   NVARCHAR(128) NOT NULL,
    expiresAt   DATETIME2(3) NOT NULL,
    usedAt      DATETIME2(3) NULL,
    createdAt   DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE UNIQUE INDEX UX_PasswordResetToken_hash ON dbo.PasswordResetToken(tokenHash);
CREATE INDEX IX_PasswordResetToken_account ON dbo.PasswordResetToken(accountID);

CREATE TABLE dbo.Wishlist (
    ID                  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    accountID           INT NOT NULL FOREIGN KEY REFERENCES dbo.[Account](ID) ON DELETE CASCADE,
    productVariantID    INT NOT NULL FOREIGN KEY REFERENCES dbo.ProductVariant(ID) ON DELETE CASCADE,
    dateAdded           DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UX_Wishlist_user_variant UNIQUE (accountID, productVariantID)
);

GO

/* ============================ SEED SIZE / COLOR (ví dụ) ============================ */

INSERT INTO dbo.SizeGroup (code, name, sortOrder, status) VALUES
 (N'CLOTHING', N'Quần áo (S/M/L...)', 10, 1),
 (N'SHOES',   N'Giày dép (số size)', 20, 1),
 (N'ONESIZE', N'Phụ kiện / một size', 30, 1);

DECLARE @sgClothing INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'CLOTHING');
DECLARE @sgShoes INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'SHOES');
DECLARE @sgOnesize INT = (SELECT ID FROM dbo.SizeGroup WHERE code = N'ONESIZE');

SET IDENTITY_INSERT dbo.SizeOption ON;
INSERT INTO dbo.SizeOption (ID, code, label, sortOrder, status, sizeGroupID) VALUES
 (1, N'FREE', N'Free size', 0, 1, @sgClothing),
 (2, N'NB',   N'Newborn',   10, 1, @sgClothing),
 (3, N'S',    N'S',          20, 1, @sgClothing),
 (4, N'M',    N'M',          30, 1, @sgClothing),
 (5, N'L',    N'L',          40, 1, @sgClothing),
 (6, N'XL',   N'XL',         50, 1, @sgClothing),
 (7, N'S16',  N'16',         10, 1, @sgShoes),
 (8, N'S17',  N'17',         20, 1, @sgShoes),
 (9, N'S18',  N'18',         30, 1, @sgShoes),
 (10, N'S19', N'19',         40, 1, @sgShoes),
 (11, N'S20', N'20',         50, 1, @sgShoes),
 (12, N'S21', N'21',         60, 1, @sgShoes),
 (13, N'OS',  N'One size',   0, 1, @sgOnesize);
SET IDENTITY_INSERT dbo.SizeOption OFF;

SET IDENTITY_INSERT dbo.ColorOption ON;
INSERT INTO dbo.ColorOption (ID, name, hexCode, sortOrder, status) VALUES
 (1, N'Mặc định', NULL, 0, 1),
 (2, N'Hồng',    N'#FFB6C1', 10, 1),
 (3, N'Xanh dương', N'#4169E1', 20, 1),
 (4, N'Be',      N'#F5F5DC', 30, 1),
 (5, N'Trắng',   N'#FFFFFF', 40, 1),
 (6, N'Xám',     N'#808080', 50, 1);
SET IDENTITY_INSERT dbo.ColorOption OFF;

GO

/*
================================================================================
  VIEWS hữu ích cho listing / báo cáo tồn kho
================================================================================
*/

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

/*
================================================================================
  VIEW — Blog đã xuất bản (tiện cho trang user / API)
================================================================================
*/

CREATE OR ALTER VIEW dbo.vw_BlogPublishedPost AS
SELECT
    p.ID,
    p.slug,
    p.title,
    p.excerpt,
    p.coverImg,
    p.publishedAt,
    p.dateUpdated,
    p.viewCount,
    p.isFeatured,
    p.readingMinutes,
    p.blogCategoryID,
    c.name AS categoryName,
    c.slug AS categorySlug,
    p.authorAccountID,
    a.fullname AS authorName,
    a.avatar AS authorAvatar
FROM dbo.BlogPost p
LEFT JOIN dbo.BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1
JOIN dbo.[Account] a ON a.ID = p.authorAccountID AND a.status = 1
WHERE p.status = 1 AND p.publishedAt IS NOT NULL AND p.publishedAt <= SYSUTCDATETIME();
GO

/*
================================================================================
  Gợi ý migrate dữ liệu từ schema v1 (bảng Size + Product có giá/tồn)
================================================================================
  Ví dụ khái niệm (cần chỉnh ID seed SizeOption/ColorOption và map productID):

  -- Với mỗi dòng cũ trong Size (productID, name, oldPrice, newPrice, quantity):
  -- 1) Tạo hoặc tìm SizeOption theo name -> sizeOptionID
  -- 2) Dùng ColorOption ID = 1 ("Mặc định") cho SP chỉ có size như cũ
  -- 3) INSERT ProductVariant (productID, sizeOptionID, colorOptionID, sku, oldPrice, newPrice, quantity)

  Sau đó:
  - Cart code Java: đổi productID -> productVariantID (và logic chọn variant trên UI).
  - ProductDAO: bỏ filter giá trực tiếp trên Product; join vw_ProductPriceStock hoặc ProductVariant.

================================================================================
*/
