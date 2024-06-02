
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[dim_StockItem]
AS
SELECT
    [Stock Item Key],
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
	[Typical Weight Per Unit]
FROM [curated].[dim_StockItem]
    