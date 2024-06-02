
CREATE TABLE [enriched].[fact_StockHolding]
    (
    [Stock Item Key] int,
	[Quantity On Hand] int,
	[Bin Location] nvarchar(20),
	[Last Stocktake Quantity] int,
	[Last Cost Price] decimal,
	[Reorder Level] int,
	[Target Stock Level] int
    );
