
CREATE TABLE [enriched].[fact_Sale]
    (
    [City Key] int,
	[Customer Key] int,
	[Bill To Customer Key] int,
	[Stock Item Key] int,
	[Invoice Date Key] int,
	[Delivery Date Key] int,
	[Salesperson Key] int,
	[WWI Invoice ID] int,
	[Description] nvarchar(100),
	[Package] nvarchar(50),
	[Quantity] int,
	[Unit Price] decimal,
	[Tax Rate] decimal,
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Profit] decimal,
	[Total Including Tax] decimal,
	[Total Dry Items] int,
	[Total Chiller Items] int
    );
