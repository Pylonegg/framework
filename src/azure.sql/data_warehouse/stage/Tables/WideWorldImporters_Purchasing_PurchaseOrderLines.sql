
CREATE TABLE [stage].[WideWorldImporters_Purchasing_PurchaseOrderLines]
    (
    [PurchaseOrderLineID] int,
	[PurchaseOrderID] int,
	[StockItemID] int,
	[OrderedOuters] int,
	[Description] nvarchar(100),
	[ReceivedOuters] int,
	[PackageTypeID] int,
	[ExpectedUnitPricePerOuter] decimal,
	[LastReceiptDate] date,
	[IsOrderLineFinalized] bit,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
