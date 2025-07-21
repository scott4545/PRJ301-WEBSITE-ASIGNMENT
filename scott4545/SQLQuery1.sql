USE [master]
GO
IF DB_ID('PRJ301_WEB_BAN_HANG') IS NOT NULL
    DROP DATABASE PRJ301_WEB_BAN_HANG
GO
CREATE DATABASE PRJ301_WEB_BAN_HANG
GO
USE [PRJ301_WEB_BAN_HANG]
GO

-- Table: User
CREATE TABLE [dbo].[User] (
    [UserID]        INT IDENTITY(1,1) NOT NULL,
    [Username]      NVARCHAR(255) NOT NULL,
    [Password]      NVARCHAR(50) NOT NULL,
    [UserRole]      NVARCHAR(1) NOT NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [UQ_Username] UNIQUE ([Username])
);

-- Table: Customer
CREATE TABLE [dbo].[Customer] (
    [CustomerID]         INT IDENTITY(1,1) NOT NULL,
    [CustomerName]       NVARCHAR(255) NOT NULL,
    [CustomerPhone]      NVARCHAR(15) NOT NULL,
    [CustomerEmail]      NVARCHAR(255) NULL,
    [CustomerAddress]    NVARCHAR(255) NULL,
    [Username]           NVARCHAR(255) NOT NULL,
    PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_User_Customer] FOREIGN KEY ([Username]) REFERENCES [dbo].[User] ([Username])
);

-- Table: Category
CREATE TABLE [dbo].[Category] (
    [CategoryID]         INT IDENTITY(1,1) NOT NULL,
    [CategoryName]       NVARCHAR(50) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

-- Table: Brand
CREATE TABLE [dbo].[Brand] (
    [BrandID]            INT IDENTITY(1,1) NOT NULL,
    [BrandName]          NVARCHAR(50) NOT NULL,
    PRIMARY KEY CLUSTERED ([BrandID] ASC)
);

-- Table: Product
CREATE TABLE [dbo].[Product] (
    [ProductID]          INT IDENTITY(1,1) NOT NULL,
    [CategoryID]         INT NOT NULL,
    [BrandID]            INT NOT NULL,
    [ProductName]        NVARCHAR(255) NOT NULL,
    [ProductDescription] NVARCHAR(1000) NULL,
    [ProductPrice]       DECIMAL(18, 2) NOT NULL,
    [ProductImage]       NVARCHAR(255) NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_Pro_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID]),
    CONSTRAINT [FK_Pro_Brand] FOREIGN KEY ([BrandID]) REFERENCES [dbo].[Brand] ([BrandID])
);

-- Table: Review
CREATE TABLE [dbo].[Review] (
    [ReviewID]           INT IDENTITY(1,1) NOT NULL,
    [ProductID]          INT NOT NULL,
    [Username]           NVARCHAR(255) NOT NULL,
    [Rating]             INT CHECK (Rating BETWEEN 1 AND 5),
    [Comment]            NVARCHAR(500) NULL,
    [ReviewDate]         DATE DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([ReviewID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]),
    FOREIGN KEY ([Username]) REFERENCES [dbo].[User] ([Username])
);

-- Table: [Order]
CREATE TABLE [dbo].[Order] (
    [OrderID]            INT IDENTITY(1,1) NOT NULL,
    [CustomerID]         INT NOT NULL,
    [OrderDate]          DATE NOT NULL,
    [TotalAmount]        DECIMAL(18, 2) NOT NULL,
    [PaymentStatus]      NVARCHAR(50) NULL,
    [AddressDelivery]    NVARCHAR(255) NOT NULL,
    PRIMARY KEY CLUSTERED ([OrderID] ASC),
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
);

-- Table: OrderDetail
CREATE TABLE [dbo].[OrderDetail] (
    [ID]                 INT IDENTITY(1,1) NOT NULL,
    [ProductID]          INT NOT NULL,
    [OrderID]            INT NOT NULL,
    [Quantity]           INT NOT NULL,
    [UnitPrice]          DECIMAL(18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]),
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Order] ([OrderID])
);

-- Insert users: 1 admin + 5 singers
INSERT INTO [dbo].[User] ([Username], [Password], [UserRole]) VALUES
(N'admin', N'1', N'A'),
(N'sontungmtp', N'123456', N'K'),
(N'erik', N'123456', N'K'),
(N'ducphuc', N'123456', N'K'),
(N'noophuocthinh', N'123456', N'K'),
(N'min', N'123456', N'K');

-- Insert customers: 1 admin + 5 singers
INSERT INTO [dbo].[Customer] ([CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username]) VALUES
(N'Admin', N'0909123450', N'admin@example.com', N'Hà Nội', N'admin'),
(N'Sơn Tùng M-TP', N'0909123456', N'sontung@example.com', N'Hà Nội', N'sontungmtp'),
(N'Erik', N'0912345678', N'erik@example.com', N'Hồ Chí Minh', N'erik'),
(N'Đức Phúc', N'0934567890', N'ducphuc@example.com', N'Hà Nội', N'ducphuc'),
(N'Noo Phước Thịnh', N'0945678901', N'noo@example.com', N'Đà Nẵng', N'noophuocthinh'),
(N'MIN', N'0956789012', N'min@example.com', N'Cần Thơ', N'min');

-- Insert categories
INSERT INTO [dbo].[Category] ([CategoryName]) VALUES
(N'Máy chơi game'),
(N'Tay cầm'),
(N'Phụ kiện'),
(N'Thẻ game');

-- Insert brands
INSERT INTO [dbo].[Brand] ([BrandName]) VALUES
(N'Sony'),
(N'Microsoft'),
(N'Nintendo'),
(N'Logitech'),
(N'Razer'),
(N'Steam'),
(N'Garena');

-- Insert 50 products
INSERT INTO [dbo].[Product] ([CategoryID], [BrandID], [ProductName], [ProductDescription], [ProductPrice], [ProductImage]) VALUES
(1, 1, N'PlayStation 5', N'Máy chơi game thế hệ mới của Sony', 14990000, N'images/ps5.jpg'),
(1, 2, N'Xbox Series X', N'Máy chơi game mạnh mẽ của Microsoft', 13990000, N'images/xboxx.jpg'),
(1, 3, N'Nintendo Switch OLED', N'Máy chơi game di động màn hình OLED', 9990000, N'images/switch.jpg'),
(2, 1, N'Tay cầm DualSense', N'Tay cầm PS5 chính hãng', 1890000, N'images/dualsense.jpg'),
(2, 2, N'Tay cầm Xbox', N'Tay cầm chính hãng cho Xbox', 1790000, N'images/xboxcontroller.jpg'),
(2, 3, N'Tay cầm Pro Controller', N'Tay cầm cao cấp cho Nintendo Switch', 1890000, N'images/procontroller.jpg'),
(3, 1, N'Tai nghe Pulse 3D', N'Tai nghe không dây cho PS5', 2990000, N'images/pulse3d.jpg'),
(3, 1, N'Bộ sạc tay cầm PS5', N'Sạc 2 tay cầm cùng lúc', 799000, N'images/charger.jpg'),
(3, 1, N'Đế đứng PS5', N'Giúp PS5 đứng vững chắc', 599000, N'images/stand.jpg'),
(4, 1, N'PlayStation Plus 12 tháng', N'Dịch vụ chơi online của Sony', 1290000, N'images/psplus.jpg'),
(4, 2, N'Xbox Game Pass 12 tháng', N'Thư viện game khổng lồ từ Microsoft', 1290000, N'images/gamepass.jpg'),
(4, 3, N'Nintendo Online 12 tháng', N'Chơi online với Switch', 790000, N'images/nintendoonline.jpg'),
(1, 1, N'PS5 Digital Edition', N'Phiên bản không ổ đĩa', 12990000, N'images/ps5digital.jpg'),
(1, 3, N'Nintendo Switch Lite', N'Phiên bản rẻ hơn của Switch', 5990000, N'images/switchlite.jpg'),
(2, 4, N'Tay cầm Logitech F710', N'Tay cầm không dây đa dụng', 890000, N'images/f710.jpg'),
(3, 1, N'Ốp tay cầm PS5', N'Bảo vệ và tăng độ bám', 290000, N'images/ps5grip.jpg'),
(3, 1, N'Dây cáp sạc USB-C', N'Sạc tay cầm PS5 và thiết bị khác', 150000, N'images/usbc.jpg'),
(4, 6, N'Thẻ Steam 500k', N'Nạp tài khoản Steam dễ dàng', 500000, N'images/steam500k.jpg'),
(4, 2, N'Thẻ Xbox Live 300k', N'Nạp tài khoản Xbox nhanh chóng', 300000, N'images/xboxlive.jpg'),
(2, 1, N'Tay cầm DualShock 4', N'Tay cầm PS4 chính hãng', 1590000, N'images/dualshock4.jpg'),
(1, 4, N'Máy chơi game Retro Mini', N'Thiết bị chơi game cổ điển', 1200000, N'images/retromini.jpg'),
(3, 1, N'Hộp đựng tay cầm', N'Bảo quản tay cầm tốt hơn', 250000, N'images/controllerbox.jpg'),
(3, 1, N'Dây HDMI 4K', N'Dây HDMI chất lượng cao', 390000, N'images/hdmi4k.jpg'),
(3, 5, N'Bàn phím cơ mini', N'Phím cơ cho gaming', 1590000, N'images/mechanicalkb.jpg'),
(3, 5, N'Chuột gaming Razer', N'Chuột chính xác cao', 1890000, N'images/razermouse.jpg'),
(3, 5, N'Bàn di chuột RGB', N'Tăng trải nghiệm chơi game', 450000, N'images/rgbpad.jpg'),
(3, 5, N'Giá đỡ tai nghe RGB', N'Trang trí và tiện dụng', 550000, N'images/headsetstand.jpg'),
(3, 1, N'Ống tản nhiệt PS5', N'Hỗ trợ làm mát máy', 300000, N'images/ps5cooler.jpg'),
(4, 1, N'PSN Card 1 triệu', N'Nạp tài khoản PSN', 1000000, N'images/psn1m.jpg'),
(4, 3, N'Nintendo eShop Card 500k', N'Nạp tài khoản Nintendo', 500000, N'images/eshop500k.jpg'),
(4, 6, N'Steam Wallet 1 triệu', N'Nạp ví Steam', 1000000, N'images/steam1m.jpg'),
(4, 7, N'Garena Card 500k', N'Nạp game Liên Quân, Free Fire', 500000, N'images/garena500k.jpg'),
(4, 1, N'Game Code FIFA 24', N'Mã tải game FIFA 24', 1400000, N'images/fifa24.jpg'),
(4, 6, N'Minecraft Java Code', N'Mã tải game Minecraft', 700000, N'images/minecraft.jpg'),
(1, 2, N'Xbox Series S', N'Phiên bản nhỏ gọn của Xbox', 7990000, N'images/xboxs.jpg'),
(2, 5, N'Tay cầm Razer Wolverine', N'Tay cầm cao cấp cho Xbox', 2990000, N'images/wolverine.jpg'),
(3, 4, N'Tai nghe Logitech G Pro', N'Tai nghe gaming chất lượng', 2490000, N'images/gpro.jpg'),
(3, 1, N'Túi đựng PS5', N'Bảo vệ máy khi di chuyển', 690000, N'images/ps5bag.jpg'),
(3, 3, N'Túi đựng Switch', N'Túi chống sốc cho Switch', 490000, N'images/switchbag.jpg'),
(4, 1, N'PSN Card 500k', N'Nạp tài khoản PSN', 500000, N'images/psn500k.jpg'),
(4, 2, N'Xbox Game Pass 6 tháng', N'Thư viện game 6 tháng', 790000, N'images/gamepass6m.jpg'),
(4, 3, N'Nintendo eShop Card 1 triệu', N'Nạp tài khoản Nintendo', 1000000, N'images/eshop1m.jpg'),
(4, 6, N'Steam Wallet 300k', N'Nạp ví Steam', 300000, N'images/steam300k.jpg'),
(4, 7, N'Garena Card 1 triệu', N'Nạp game Garena', 1000000, N'images/garena1m.jpg'),
(2, 3, N'Tay cầm Joy-Con Pair', N'Tay cầm Joy-Con cho Switch', 1990000, N'images/joycon.jpg'),
(3, 4, N'Bộ sạc pin AA Logitech', N'Sạc pin cho tay cầm', 590000, N'images/aacharger.jpg'),
(3, 5, N'Tấm lót bàn gaming', N'Tấm lót lớn cho bàn phím và chuột', 350000, N'images/deskpad.jpg'),
(1, 1, N'PS4 Slim', N'Máy chơi game PS4 phiên bản mỏng', 6990000, N'images/ps4slim.jpg'),
(1, 3, N'Nintendo 3DS XL', N'Máy chơi game cầm tay 3D', 4990000, N'images/3dsxl.jpg'),
(4, 1, N'Game Code Spider-Man 2', N'Mã tải game Spider-Man 2', 1490000, N'images/spiderman2.jpg');

-- Insert reviews
INSERT INTO [dbo].[Review] ([ProductID], [Username], [Rating], [Comment]) VALUES
(1, N'sontungmtp', 4, N'Máy chơi game tuyệt vời, đồ họa đẹp!'),
(1, N'erik', 5, N'PS5 chạy mượt, đáng tiền.'),
(2, N'ducphuc', 3, N'Xbox mạnh nhưng hơi ồn.'),
(4, N'noophuocthinh', 4, N'Tay cầm DualSense rất nhạy.');

-- Insert sample order
INSERT INTO [dbo].[Order] ([CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery]) VALUES
(2, '2025-06-13', 14990000, N'Paid', N'Hà Nội');

-- Insert sample order detail
INSERT INTO [dbo].[OrderDetail] ([ProductID], [OrderID], [Quantity], [UnitPrice]) VALUES
(1, 1, 1, 14990000);

-- Final
ALTER AUTHORIZATION ON DATABASE::PRJ301_WEB_BAN_HANG TO sa;

-- Cập nhật dữ liệu mẫu cho cột Status và Quantity
ALTER TABLE [dbo].[Product]
ADD [Status] BIT NOT NULL DEFAULT 1,
    [Quantity] INT NOT NULL DEFAULT 0;

-- Cập nhật Status = 1 và Quantity ngẫu nhiên (ví dụ: từ 0 đến 100)
UPDATE [dbo].[Product]
SET [Status] = 1,
    [Quantity] = FLOOR(RAND() * 100) + 1; -- Số lượng ngẫu nhiên từ 1 đến 100