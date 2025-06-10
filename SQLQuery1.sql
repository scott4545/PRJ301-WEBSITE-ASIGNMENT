--New Database: MyStore
-- Bang User: quan ly ca tai khoan cua Khach hang va Admin
USE [master]
GO
DROP DATABASE [PRJ301_WEB_BAN_HANG]
GO
CREATE DATABASE [PRJ301_WEB_BAN_HANG]
GO
USE [PRJ301_WEB_BAN_HANG]
GO

CREATE TABLE [dbo].[User] (
    [Username]     NVARCHAR (255) NOT NULL,
	[Password] NCHAR (50)     NOT NULL,
    [UserRole]     NCHAR (1) NOT NULL,

    PRIMARY KEY CLUSTERED ([Username] ASC)
);


--Bang Customer: luu thong tin khach hang
CREATE TABLE [dbo].[Customer] (
    [CustomerID]          INT IDENTITY (1, 1) NOT NULL,
    [CustomerName]     NVARCHAR (MAX) NOT NULL,
    [CustomerPhone]    NVARCHAR (15)  NOT NULL,
    [CustomerEmail]      NVARCHAR (MAX) NULL,
    [CustomerAddress]  NVARCHAR (MAX) NULL,
    [Username]              NVARCHAR (255) NOT NULL,
    PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_User_Customer] FOREIGN KEY ([Username]) REFERENCES [dbo].[User] ([Username])
);

--Bang Category: luu thong tin danh muc san pham
CREATE TABLE [dbo].[Category] (
    [CategoryID]            INT            IDENTITY (1, 1) NOT NULL,
    [CategoryName]      NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);
--Bang Product: luu thong tin san pham
CREATE TABLE [dbo].[Product] (
    [ProductID]              INT             IDENTITY (1, 1) NOT NULL,
    [CategoryID]            INT            NOT NULL,
    [ProductName]        NVARCHAR (MAX)  NOT NULL,
    [ProductDecription]  NVARCHAR (MAX)  NOT NULL,
    [ProductPrice]          DECIMAL (18, 2) NOT NULL,
    [ProductImage]        NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_Pro_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID])
);

--Bang Order: luu thong tin don hang cua khach hang
CREATE TABLE [dbo].[Order] (
    [OrderID]                 INT            IDENTITY (1, 1) NOT NULL,
    [CustomerID]          INT            NOT NULL,
    [OrderDate]             DATE           NOT NULL,
    [TotalAmount]         DECIMAL (18, 2) NOT NULL,
    [PaymentStatus]     NVARCHAR (MAX) NULL,
    [AddressDelivery]   NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([OrderID] ASC),
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
);
--Bang OrderDetail: luu thong tin chi tiet cac san pham co trong don hang
CREATE TABLE [dbo].[OrderDetail] (
    [ID]        INT        IDENTITY (1, 1) NOT NULL,
    [ProductID] INT        NOT NULL,
    [OrderID]   INT        NOT NULL,
    [Quantity]  INT        NOT NULL,
    [UnitPrice] DECIMAL (18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]),
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Order] ([OrderID])
);

INSERT INTO [dbo].[Category] (CategoryName) VALUES
(N'PlayStation'),
(N'Xbox'),
(N'Nintendo Switch'),
(N'Tay cầm'),
(N'Phụ kiện');

INSERT INTO [dbo].[Product] (CategoryID, ProductName, ProductDecription, ProductPrice, ProductImage) VALUES
-- Danh mục PlayStation (CategoryID = 1)
(1, N'PlayStation 5 Standard Edition', N'Máy chơi game PlayStation 5 với ổ đĩa Blu-ray, hỗ trợ đồ họa 4K, ray tracing và SSD tốc độ cao.', 12990000.00, NULL),
(1, N'PlayStation 5 Digital Edition', N'Phiên bản kỹ thuật số của PlayStation 5, không có ổ đĩa, phù hợp cho game thủ tải game trực tuyến.', 10990000.00, NULL),
(1, N'PlayStation 4 Pro 1TB', N'Máy chơi game PlayStation 4 Pro, hỗ trợ HDR và 4K, dung lượng 1TB.', 7990000.00, NULL),
-- Danh mục Xbox (CategoryID = 2)
(2, N'Xbox Series X 1TB', N'Máy chơi game Xbox Series X mạnh mẽ, hỗ trợ 4K, 120 FPS và dung lượng lưu trữ 1TB.', 12990000.00, NULL),
(2, N'Xbox Series S 512GB', N'Phiên bản nhỏ gọn của Xbox, hỗ trợ 1440p, không ổ đĩa, dung lượng 512GB.', 7990000.00, NULL),
(2, N'Xbox One S 1TB', N'Máy chơi game Xbox One S, hỗ trợ HDR, phát video 4K, dung lượng 1TB.', 6490000.00, NULL),
-- Danh mục Nintendo Switch (CategoryID = 3)
(3, N'Nintendo Switch OLED', N'Máy chơi game Nintendo Switch với màn hình OLED 7 inch, hỗ trợ chơi cầm tay và kết nối TV.', 8490000.00, NULL),
(3, N'Nintendo Switch Lite', N'Phiên bản nhỏ gọn, chỉ chơi cầm tay, phù hợp cho game thủ di động.', 4990000.00, NULL),
(3, N'Nintendo Switch Standard', N'Máy chơi game Nintendo Switch tiêu chuẩn, hỗ trợ cả chơi cầm tay và kết nối TV.', 6990000.00, NULL),
-- Danh mục Tay cầm (CategoryID = 4)
(4, N'Tay cầm DualSense PS5', N'Tay cầm chính hãng cho PlayStation 5, hỗ trợ rung phản hồi xúc giác và cò adaptive triggers.', 1790000.00, NULL),
(4, N'Tay cầm Xbox Wireless Controller', N'Tay cầm không dây cho Xbox Series X|S, Xbox One, thiết kế ergonomic, kết nối Bluetooth.', 1490000.00, NULL),
(4, N'Tay cầm Joy-Con Nintendo Switch', N'Bộ đôi tay cầm Joy-Con cho Nintendo Switch, hỗ trợ chơi đa người, cảm biến chuyển động.', 1990000.00, NULL),
-- Danh mục Phụ kiện (CategoryID = 5)
(5, N'PS5 DualSense Charging Station', N'Đế sạc chính hãng cho 2 tay cầm DualSense, thiết kế nhỏ gọn, tiện lợi.', 790000.00, NULL),
(5, N'Xbox Rechargeable Battery Pack', N'Pin sạc chính hãng cho tay cầm Xbox, đi kèm cáp USB-C, thời lượng sử dụng dài.', 590000.00, NULL),
(5, N'Nintendo Switch Pro Controller', N'Tay cầm chuyên nghiệp cho Nintendo Switch, thiết kế thoải mái, pin lâu, hỗ trợ chơi trên TV.', 1690000.00, NULL),
(5, N'Túi đựng Nintendo Switch', N'Túi bảo vệ dành cho Nintendo Switch, chống sốc, có ngăn chứa phụ kiện.', 490000.00, NULL);

ALTER AUTHORIZATION ON DATABASE::PRJ301_WEB_BAN_HANG TO sa;

