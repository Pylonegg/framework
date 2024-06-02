
CREATE TABLE [enriched].[fact_Transaction]
    (
    [Date Key] int,
	[Customer Key] int,
	[Bill To Customer Key] int,
	[Supplier Key] int,
	[Transaction Type Key] int,
	[Payment Method Key] int,
	[WWI Customer Transaction ID] int,
	[WWI Supplier Transaction ID] int,
	[WWI Invoice ID] int,
	[WWI Purchase Order ID] int,
	[Supplier Invoice Number] nvarchar(20),
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Total Including Tax] decimal,
	[Outstanding Balance] decimal,
	[Is Finalized] bit,
	[Lineage Key] int
    );
