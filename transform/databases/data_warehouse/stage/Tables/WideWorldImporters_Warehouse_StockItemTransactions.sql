
CREATE TABLE [stage].[WideWorldImporters_Warehouse_StockItemTransactions]
    (
    [StockItemTransactionID] int,
	[StockItemID] int,
	[TransactionTypeID] int,
	[CustomerID] int,
	[InvoiceID] int,
	[SupplierID] int,
	[PurchaseOrderID] int,
	[TransactionOccurredWhen] datetime2,
	[Quantity] decimal,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
