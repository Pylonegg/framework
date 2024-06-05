
CREATE TABLE [stage].[WideWorldImporters_Sales_InvoiceLines]
    (
    [InvoiceLineID] int,
	[InvoiceID] int,
	[StockItemID] int,
	[Description] nvarchar(100),
	[PackageTypeID] int,
	[Quantity] int,
	[UnitPrice] decimal,
	[TaxRate] decimal,
	[TaxAmount] decimal,
	[LineProfit] decimal,
	[ExtendedPrice] decimal,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
