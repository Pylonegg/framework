
CREATE TABLE [stage].[WideWorldImporters_Sales_SpecialDeals]
    (
    [SpecialDealID] int,
	[StockItemID] int,
	[CustomerID] int,
	[BuyingGroupID] int,
	[CustomerCategoryID] int,
	[StockGroupID] int,
	[DealDescription] nvarchar(30),
	[StartDate] date,
	[EndDate] date,
	[DiscountAmount] decimal,
	[DiscountPercentage] decimal,
	[UnitPrice] decimal,
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
