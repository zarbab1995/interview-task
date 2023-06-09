USE [booklibrary]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 12/05/2023 1:43:06 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[Code] [int] NOT NULL,
	[BookName] [varchar](50) NULL,
	[Author] [varchar](50) NULL,
	[IsAvailable] [bit] NULL,
	[Price] [float] NULL,
	[ShelfID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Racks]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Racks](
	[RackID] [int] NOT NULL,
	[Code] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shelves]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shelves](
	[ShelfID] [int] NOT NULL,
	[Code] [varchar](50) NULL,
	[RackID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ShelfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD FOREIGN KEY([ShelfID])
REFERENCES [dbo].[Shelves] ([ShelfID])
GO
ALTER TABLE [dbo].[Shelves]  WITH CHECK ADD FOREIGN KEY([RackID])
REFERENCES [dbo].[Racks] ([RackID])
GO
/****** Object:  StoredProcedure [dbo].[AddBook]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddBook]
	@Code INT,
    @BookName VARCHAR(50),
    @Author VARCHAR(50),
    @IsAvailable BIT,
    @Price FLOAT,
    @ShelfID INT
AS
BEGIN
    INSERT INTO Books (Code, BookName, Author, IsAvailable, Price, ShelfID)
    VALUES (@Code, @BookName, @Author, @IsAvailable, @Price, @ShelfID)
END
GO
/****** Object:  StoredProcedure [dbo].[GetBookDetails]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBookDetails]
AS
BEGIN
    SELECT 
        b.Code, 
        b.BookName, 
        b.Author, 
        b.Price,
        b.IsAvailable,
        s.Code AS ShelfCode,
        r.Code AS RackCode
    FROM Books b
    JOIN Shelves s ON b.ShelfID = s.ShelfID
    JOIN Racks r ON s.RackID = r.RackID
    WHERE s.Code = b.Code
END
GO
/****** Object:  StoredProcedure [dbo].[SoftDeleteBook]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SoftDeleteBook]
    @Code INT
AS
BEGIN
    UPDATE Books
    SET isAvailable = 0
    WHERE Code = @Code
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateBook]    Script Date: 12/05/2023 1:43:07 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateBook]
    @Code INT,
    @BookName VARCHAR(50),
    @Author VARCHAR(50),
    @IsAvailable BIT,
    @Price FLOAT,
    @ShelfID INT
AS
BEGIN
    UPDATE Books
    SET 
        BookName = @BookName, 
        Author = @Author,
        IsAvailable = @IsAvailable,
        Price = @Price,
        ShelfID = @ShelfID
    WHERE Code = @Code
END
GO
