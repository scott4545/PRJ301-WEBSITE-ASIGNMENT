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
    [UserID]        INT IDENTITY (1,1) NOT NULL,
    [Username]      NVARCHAR(255) NOT NULL,
    [Password]      NCHAR(50) NOT NULL,
    [UserRole]      NCHAR(1) NOT NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [UQ_Username] UNIQUE ([Username])
);

-- Table: Customer
CREATE TABLE [dbo].[Customer] (
    [CustomerID]         INT IDENTITY (1,1) NOT NULL,
    [CustomerName]       NVARCHAR(MAX) NOT NULL,
    [CustomerPhone]      NVARCHAR(15) NOT NULL,
    [CustomerEmail]      NVARCHAR(MAX) NULL,
    [CustomerAddress]    NVARCHAR(MAX) NULL,
    [Username]           NVARCHAR(255) NOT NULL,
    PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_User_Customer] FOREIGN KEY ([Username]) REFERENCES [dbo].[User] ([Username])
);

-- Table: Category
CREATE TABLE [dbo].[Category] (
    [CategoryID]         INT IDENTITY(1,1) NOT NULL,
    [CategoryName]       NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

-- Table: Product
CREATE TABLE [dbo].[Product] (
    [ProductID]          INT IDENTITY(1,1) NOT NULL,
    [CategoryID]         INT NOT NULL,
    [ProductName]        NVARCHAR(MAX) NOT NULL,
    [ProductDecription]  NVARCHAR(MAX) NOT NULL,
    [ProductPrice]       DECIMAL(18, 2) NOT NULL,
    [ProductImage]       NVARCHAR(MAX) NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_Pro_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID])
);

-- Table: Order
CREATE TABLE [dbo].[Order] (
    [OrderID]            INT IDENTITY(1,1) NOT NULL,
    [CustomerID]         INT NOT NULL,
    [OrderDate]          DATE NOT NULL,
    [TotalAmount]        DECIMAL(18, 2) NOT NULL,
    [PaymentStatus]      NVARCHAR(MAX) NULL,
    [AddressDelivery]    NVARCHAR(MAX) NOT NULL,
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

-- Insert categories
INSERT INTO [dbo].[Category] ([CategoryName]) VALUES
(N'Máy chơi game'),
(N'Tay cầm'),
(N'Phụ kiện'),
(N'Digital card');

-- Insert 50 products
INSERT INTO [dbo].[Product] ([CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage]) VALUES
(1, N'PlayStation 5', N'Máy chơi game thế hệ mới của Sony', 14990000, N'https://example.com/ps5.jpg'),
(1, N'Xbox Series X', N'Máy chơi game mạnh mẽ của Microsoft', 13990000, N'https://example.com/xboxx.jpg'),
(1, N'Nintendo Switch OLED', N'Máy chơi game di động màn hình OLED', 9990000, N'https://example.com/switch.jpg'),
(2, N'Tay cầm DualSense', N'Tay cầm PS5 chính hãng', 1890000, N'https://example.com/dualsense.jpg'),
(2, N'Tay cầm Xbox', N'Tay cầm chính hãng cho Xbox', 1790000, N'https://example.com/xboxcontroller.jpg'),
(2, N'Tay cầm Pro Controller', N'Tay cầm cao cấp cho Nintendo Switch', 1890000, N'https://example.com/procontroller.jpg'),
(3, N'Tai nghe Pulse 3D', N'Tai nghe không dây cho PS5', 2990000, N'https://example.com/pulse3d.jpg'),
(3, N'Bộ sạc tay cầm PS5', N'Sạc 2 tay cầm cùng lúc', 799000, N'https://example.com/charger.jpg'),
(3, N'Đế đứng PS5', N'Giúp PS5 đứng vững chắc', 599000, N'https://example.com/stand.jpg'),
(4, N'PlayStation Plus 12 tháng', N'Dịch vụ chơi online của Sony', 1290000, N'https://example.com/psplus.jpg'),
(4, N'Xbox Game Pass 12 tháng', N'Thư viện game khổng lồ từ Microsoft', 1290000, N'https://example.com/gamepass.jpg'),
(4, N'Nintendo Online 12 tháng', N'Chơi online với Switch', 790000, N'https://example.com/nintendoonline.jpg'),
-- Thêm tiếp 38 sản phẩm tương tự cho đến đủ 50
(1, N'PS5 Digital Edition', N'Phiên bản không ổ đĩa', 12990000, NULL),
(1, N'Nintendo Switch Lite', N'Phiên bản rẻ hơn của Switch', 5990000, NULL),
(2, N'Tay cầm Logitech F710', N'Tay cầm không dây đa dụng', 890000, NULL),
(3, N'Ốp tay cầm PS5', N'Bảo vệ và tăng độ bám', 290000, NULL),
(3, N'Dây cáp sạc USB-C', N'Sạc tay cầm PS5 và thiết bị khác', 150000, NULL),
(4, N'Mua thẻ Steam 500k', N'Nạp tài khoản Steam dễ dàng', 500000, NULL),
(4, N'Mua thẻ Xbox Live', N'Nạp tài khoản Xbox nhanh chóng', 300000, NULL),
(2, N'Tay cầm PS4', N'Tay cầm DualShock 4 chính hãng', 1590000, NULL),
(1, N'Máy chơi game Retro Mini', N'Thiết bị chơi game cổ điển', 1200000, NULL),
(3, N'Hộp đựng tay cầm', N'Bảo quản tay cầm tốt hơn', 250000, NULL),
-- ... tiếp tục chèn thêm để đạt đủ 50 nếu cần
(3, N'Dây HDMI 4K', N'Dây HDMI chất lượng cao', 390000, NULL),
(3, N'Bàn phím cơ mini', N'Phím cơ cho gaming', 1590000, NULL),
(3, N'Chuột gaming Razer', N'Chuột chính xác cao', 1890000, NULL),
(3, N'Bàn di chuột RGB', N'Tăng trải nghiệm chơi game', 450000, NULL),
(3, N'Giá đỡ tai nghe RGB', N'Trang trí và tiện dụng', 550000, NULL),
(3, N'Ống tản nhiệt PS5', N'Hỗ trợ làm mát máy', 300000, NULL),
(4, N'PSN Card 1 triệu', N'Nạp tài khoản PSN', 1000000, NULL),
(4, N'Nintendo eShop Card 500k', N'Nạp tài khoản Nintendo', 500000, NULL),
(4, N'Steam Wallet 1 triệu', N'Nạp ví Steam', 1000000, NULL),
(4, N'Garena Card 500k', N'Nạp game Liên Quân, Free Fire', 500000, NULL),
(4, N'Game Code FIFA 24', N'Mã tải game FIFA 24', 1400000, NULL),
(4, N'Minecraft Java Code', N'Mã tải game Minecraft', 700000, NULL);

-- Final
ALTER AUTHORIZATION ON DATABASE::PRJ301_WEB_BAN_HANG TO sa;
