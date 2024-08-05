
CREATE TABLE [stage].[WideWorldImporters_Warehouse_StockItemHoldings]
    (
    [StockItemID] int,
	[QuantityOnHand] int,
	[BinLocation] nvarchar(20),
	[LastStocktakeQuantity] int,
	[LastCostPrice] decimal,
	[ReorderLevel] int,
	[TargetStockLevel] int,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
