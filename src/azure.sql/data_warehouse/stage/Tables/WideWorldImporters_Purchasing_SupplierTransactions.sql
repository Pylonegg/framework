
CREATE TABLE [stage].[WideWorldImporters_Purchasing_SupplierTransactions]
    (
    [SupplierTransactionID] int,
	[SupplierID] int,
	[TransactionTypeID] int,
	[PurchaseOrderID] int,
	[PaymentMethodID] int,
	[SupplierInvoiceNumber] nvarchar(20),
	[TransactionDate] date,
	[AmountExcludingTax] decimal,
	[TaxAmount] decimal,
	[TransactionAmount] decimal,
	[OutstandingBalance] decimal,
	[FinalizationDate] date,
	[IsFinalized] bit,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
