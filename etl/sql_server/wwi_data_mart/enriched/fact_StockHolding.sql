       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_StockHolding]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_StockHolding]') IS NOT NULL
    DROP TABLE [enriched].[fact_StockHolding]

	BEGIN
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
	END

	INSERT INTO [enriched].[fact_StockHolding]
    SELECT 
		   si.[Stock Item Key] 			AS [Stock Item Key],
		   sih.QuantityOnHand 			AS [Quantity On Hand],
           sih.BinLocation 				AS [Bin Location],
           sih.LastStocktakeQuantity 	AS [Last Stocktake Quantity],
           sih.LastCostPrice 			AS [Last Cost Price],
           sih.ReorderLevel 			AS [Reorder Level],
           sih.TargetStockLevel 		AS [Target Stock Level]
    FROM [wide_world_importers].[warehouse].[StockItemHoldings] AS sih
	LEFT JOIN [curated].dim_StockItem si
		ON si.[WWI Stock Item ID] = sih.StockItemID   

END
    