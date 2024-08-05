
CREATE TABLE [enriched].[fact_StockHolding] 
(
    [Stock Item Key] int NOT NULL,
	[Quantity On Hand] int NOT NULL,
	[Bin Location] nvarchar(20) NOT NULL,
	[Last Stocktake Quantity] int NOT NULL,
	[Last Cost Price] decimal NOT NULL,
	[Reorder Level] int NOT NULL,
	[Target Stock Level] int NOT NULL
);
