
CREATE TABLE [enriched].[fact_Transaction] 
(
    [Date Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Bill To Customer Key] int NOT NULL,
	[Supplier Key] int NOT NULL,
	[Transaction Type Key] int NOT NULL,
	[Payment Method Key] int NOT NULL,
	[WWI Customer Transaction ID] int NOT NULL,
	[WWI Supplier Transaction ID] int NOT NULL,
	[WWI Invoice ID] int NOT NULL,
	[WWI Purchase Order ID] int NOT NULL,
	[Supplier Invoice Number] nvarchar(20) NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL,
	[Outstanding Balance] decimal NOT NULL,
	[Is Finalized] bit NOT NULL,
	[Lineage Key] int NOT NULL
);
