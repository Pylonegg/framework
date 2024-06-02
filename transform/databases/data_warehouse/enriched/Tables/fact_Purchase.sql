
CREATE TABLE [enriched].[fact_Purchase]
    (
    [Date Key] int,
	[Supplier Key] int,
	[Stock Item Key] int,
	[WWI Purchase Order ID] int,
	[Ordered Outers] int,
	[Ordered Quantity] int,
	[Received Outers] int,
	[Package] nvarchar(50),
	[Is Order Finalized] bit
    );
