
CREATE TABLE [stage].[WideWorldImporters_Sales_Invoices]
    (
    [InvoiceID] int,
	[CustomerID] int,
	[BillToCustomerID] int,
	[OrderID] int,
	[DeliveryMethodID] int,
	[ContactPersonID] int,
	[AccountsPersonID] int,
	[SalespersonPersonID] int,
	[PackedByPersonID] int,
	[InvoiceDate] date,
	[CustomerPurchaseOrderNumber] nvarchar(20),
	[IsCreditNote] bit,
	[CreditNoteReason] nvarchar(max),
	[Comments] nvarchar(max),
	[DeliveryInstructions] nvarchar(max),
	[InternalComments] nvarchar(max),
	[TotalDryItems] int,
	[TotalChillerItems] int,
	[DeliveryRun] nvarchar(5),
	[RunPosition] nvarchar(5),
	[ReturnedDeliveryData] nvarchar(max),
	[ConfirmedDeliveryTime] datetime2,
	[ConfirmedReceivedBy] nvarchar(4000),
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
