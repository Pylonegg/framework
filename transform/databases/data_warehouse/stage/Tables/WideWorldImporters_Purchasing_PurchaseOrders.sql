
CREATE TABLE [stage].[WideWorldImporters_Purchasing_PurchaseOrders]
    (
    [PurchaseOrderID] int,
	[SupplierID] int,
	[OrderDate] date,
	[DeliveryMethodID] int,
	[ContactPersonID] int,
	[ExpectedDeliveryDate] date,
	[SupplierReference] nvarchar(20),
	[IsOrderFinalized] bit,
	[Comments] nvarchar(max),
	[InternalComments] nvarchar(max),
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
