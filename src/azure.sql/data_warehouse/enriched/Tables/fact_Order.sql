
CREATE TABLE [enriched].[fact_Order] 
(
    [City Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Order Date Key] int NOT NULL,
	[Picked Date Key] int NOT NULL,
	[Salesperson Key] int NOT NULL,
	[Picker Key] int NOT NULL,
	[WWI Order ID] int NOT NULL,
	[WWI Backorder ID] int NOT NULL,
	[Description] nvarchar(100) NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Quantity] int NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Tax Rate] decimal NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL
);
