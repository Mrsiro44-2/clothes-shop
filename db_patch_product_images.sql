/* Sửa ảnh sản phẩm seed không tồn tại file — dùng URL ảnh thật (mẹ & bé) */
USE MomAndBaby;
GO

UPDATE dbo.Product
SET mainImg = CASE (ID % 6)
    WHEN 0 THEN 'https://images.unsplash.com/photo-1515488042361-ee00e817a227?w=600&q=80'
    WHEN 1 THEN 'https://images.unsplash.com/photo-1522771739844-6a9f6d2fafa1?w=600&q=80'
    WHEN 2 THEN 'https://images.unsplash.com/photo-1503454537199-1eabb201c6af?w=600&q=80'
    WHEN 3 THEN 'https://images.unsplash.com/photo-1519457431-44ccd64b83b4?w=600&q=80'
    WHEN 4 THEN 'https://images.unsplash.com/photo-1503919005314-30d933d1b58f?w=600&q=80'
    ELSE 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=80'
END
WHERE mainImg IS NULL
   OR LTRIM(RTRIM(mainImg)) = ''
   OR mainImg LIKE './uploads/product/seed-%'
   OR mainImg LIKE 'uploads/product/seed-%';
GO

UPDATE dbo.Brand
SET img = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&q=80'
WHERE img IS NULL OR LTRIM(RTRIM(img)) = '' OR img LIKE './uploads/%';
GO

PRINT N'Đã cập nhật URL ảnh sản phẩm / thương hiệu.';
GO
