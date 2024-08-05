
CREATE TABLE [stage].[WideWorldImporters_Warehouse_StockItems]
    (
    [StockItemID] int,
	[StockItemName] nvarchar(100),
	[SupplierID] int,
	[ColorID] int,
	[UnitPackageID] int,
	[OuterPackageID] int,
	[Brand] nvarchar(50),
	[Size] nvarchar(20),
	[LeadTimeDays] int,
	[QuantityPerOuter] int,
	[IsChillerStock] bit,
	[Barcode] nvarchar(50),
	[TaxRate] decimal,
	[UnitPrice] decimal,
	[RecommendedRetailPrice] decimal,
	[TypicalWeightPerUnit] decimal,
	[MarketingComments] nvarchar(max),
	[InternalComments] nvarchar(max),
	[Photo] varbinary(max),
	[CustomFields] nvarchar(max),
	[Tags] nvarchar(max),
	[SearchDetails] nvarchar(max),
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
