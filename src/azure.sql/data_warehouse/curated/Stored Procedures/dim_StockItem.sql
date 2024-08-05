
CREATE PROCEDURE [curated].[sp_dim_StockItem]
AS
BEGIN
IF OBJECT_ID('[curated].[temp_dim_StockItem]') IS NOT NULL
    DROP TABLE [curated].[temp_dim_StockItem]
CREATE TABLE [curated].[temp_dim_StockItem]
(
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
)

IF OBJECT_ID('[curated].[new_dim_StockItem]') IS NOT NULL
    DROP TABLE [curated].[new_dim_StockItem]
CREATE TABLE [curated].[new_dim_StockItem]
(
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
)

-- Copy from enriched into curated.temp_
INSERT INTO [curated].[temp_dim_StockItem](
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


INSERT INTO [curated].[new_dim_StockItem]

SELECT -- New Snapshot Rows
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
FROM [curated].[temp_dim_StockItem]

UNION ALL

SELECT -- Existing Snapshot Rows
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
FROM [curated].[temp_dim_StockItem]
-- add snapshot date key to logic WHERE [snapshot_key] NOT IN (SELECT [snapshot_key] FROM [curated].[temp_dim_StockItem])


IF OBJECT_ID('[curated].[old_dim_StockItem]') IS NOT NULL
    DROP TABLE [curated].[old_dim_StockItem]
EXEC sp_rename  'curated.dim_StockItem', 'old_dim_StockItem'
EXEC sp_rename  'curated.new_dim_StockItem', 'dim_StockItem'

END
