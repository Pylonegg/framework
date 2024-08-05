
CREATE TABLE [enriched].[fact_Purchase] 
(
    [Date Key] int NOT NULL,
	[Supplier Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[WWI Purchase Order ID] int NOT NULL,
	[Ordered Outers] int NOT NULL,
	[Ordered Quantity] int NOT NULL,
	[Received Outers] int NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Is Order Finalized] bit NOT NULL
);
