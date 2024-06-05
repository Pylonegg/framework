
CREATE TABLE [stage].[WideWorldImporters_Sales_OrderLines]
    (
    [OrderLineID] int,
	[OrderID] int,
	[StockItemID] int,
	[Description] nvarchar(100),
	[PackageTypeID] int,
	[Quantity] int,
	[UnitPrice] decimal,
	[TaxRate] decimal,
	[PickedQuantity] int,
	[PickingCompletedWhen] datetime2,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
