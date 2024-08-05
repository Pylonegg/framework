       
CREATE PROCEDURE [enriched].[sp_fact_StockHolding]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_StockHolding];

	INSERT INTO [enriched].[fact_StockHolding]
    SELECT 
		   si.[Stock Item Key] 			AS [Stock Item Key],
		   sih.QuantityOnHand 			AS [Quantity On Hand],
           sih.BinLocation 				AS [Bin Location],
           sih.LastStocktakeQuantity 	AS [Last Stocktake Quantity],
           sih.LastCostPrice 			AS [Last Cost Price],
           sih.ReorderLevel 			AS [Reorder Level],
           sih.TargetStockLevel 		AS [Target Stock Level]
    FROM [stage].[WideWorldImporters_Warehouse_StockItemHoldings] AS sih
	LEFT JOIN [curated].dim_StockItem si
		ON si.[WWI Stock Item ID] = sih.StockItemID   
END
    