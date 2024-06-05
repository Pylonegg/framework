
CREATE TABLE [stage].[WideWorldImporters_Sales_Orders]
    (
    [OrderID] int,
	[CustomerID] int,
	[SalespersonPersonID] int,
	[PickedByPersonID] int,
	[ContactPersonID] int,
	[BackorderOrderID] int,
	[OrderDate] date,
	[ExpectedDeliveryDate] date,
	[CustomerPurchaseOrderNumber] nvarchar(20),
	[IsUndersupplyBackordered] bit,
	[Comments] nvarchar(max),
	[DeliveryInstructions] nvarchar(max),
	[InternalComments] nvarchar(max),
	[PickingCompletedWhen] datetime2,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
