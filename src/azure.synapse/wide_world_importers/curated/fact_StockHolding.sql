
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_StockHolding]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_StockHolding]
(
    [Stock Holding Key] INT IDENTITY(1,1),
    [Stock Item Key] int NOT NULL,
	[Quantity On Hand] int NOT NULL,
	[Bin Location] nvarchar(20) NOT NULL,
	[Last Stocktake Quantity] int NOT NULL,
	[Last Cost Price] decimal NOT NULL,
	[Reorder Level] int NOT NULL,
	[Target Stock Level] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_StockHolding]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_StockHolding];

INSERT INTO [curated].[fact_StockHolding](
    [Stock Item Key],
	[Quantity On Hand],
	[Bin Location],
	[Last Stocktake Quantity],
	[Last Cost Price],
	[Reorder Level],
	[Target Stock Level],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Stock Item Key],
	[Quantity On Hand],
	[Bin Location],
	[Last Stocktake Quantity],
	[Last Cost Price],
	[Reorder Level],
	[Target Stock Level],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_StockHolding]
END
    