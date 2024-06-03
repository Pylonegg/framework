
CREATE TABLE [enriched].[fact_Order]
    (
    [City Key] int,
	[Customer Key] int,
	[Stock Item Key] int,
	[Order Date Key] int,
	[Picked Date Key] int,
	[Salesperson Key] int,
	[Picker Key] int,
	[WWI Order ID] int,
	[WWI Backorder ID] int,
	[Description] nvarchar(100),
	[Package] nvarchar(50),
	[Quantity] int,
	[Unit Price] decimal,
	[Tax Rate] decimal,
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Total Including Tax] decimal
    );
