
CREATE TABLE [stage].[WideWorldImporters_Sales_CustomerTransactions]
    (
    [CustomerTransactionID] int,
	[CustomerID] int,
	[TransactionTypeID] int,
	[InvoiceID] int,
	[PaymentMethodID] int,
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
