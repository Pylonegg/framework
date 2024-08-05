
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
)
