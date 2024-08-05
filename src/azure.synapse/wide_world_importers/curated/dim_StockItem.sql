
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_StockItem]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_StockItem]
(
    [Stock Item Key] INT IDENTITY(1,1),
    [WWI Stock Item ID] int NOT NULL,
	[Stock Item] nvarchar(100) NOT NULL,
	[Color] nvarchar(20) NULL,
	[Selling Package] nvarchar(50) NOT NULL,
	[Buying Package] nvarchar(50) NOT NULL,
	[Brand] nvarchar(50) NULL,
	[Size] nvarchar(20) NULL,
	[Lead Time Days] int NOT NULL,
	[Quantity Per Outer] int NOT NULL,
	[Is Chiller Stock] bit NOT NULL,
	[Barcode] nvarchar(50) NULL,
	[Tax Rate] decimal NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Recommended Retail Price] decimal NOT NULL,
	[Typical Weight Per Unit] decimal NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_StockItem]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_StockItem];

INSERT INTO [curated].[dim_StockItem](
    [WWI Stock Item ID],
	[Stock Item],
	[Color],
	[Selling Package],
	[Buying Package],
	[Brand],
	[Size],
	[Lead Time Days],
	[Quantity Per Outer],
	[Is Chiller Stock],
	[Barcode],
	[Tax Rate],
	[Unit Price],
	[Recommended Retail Price],
	[Typical Weight Per Unit],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Stock Item ID],
	[Stock Item],
	[Color],
	[Selling Package],
	[Buying Package],
	[Brand],
	[Size],
	[Lead Time Days],
	[Quantity Per Outer],
	[Is Chiller Stock],
	[Barcode],
	[Tax Rate],
	[Unit Price],
	[Recommended Retail Price],
	[Typical Weight Per Unit],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Stock Item ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_StockItem]
END
    