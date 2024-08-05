
CREATE VIEW [model].[fact_StockHolding]
AS
SELECT
    [Stock Holding Key],
	[Stock Item Key],
	[Quantity On Hand],
	[Bin Location],
	[Last Stocktake Quantity],
	[Last Cost Price],
	[Reorder Level],
	[Target Stock Level]
FROM [curated].[fact_StockHolding]
