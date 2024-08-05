
CREATE TABLE [enriched].[fact_Movement] 
(
    [Date Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Customer Key] int NULL,
	[Supplier Key] int NULL,
	[Transaction Type Key] int NOT NULL,
	[WWI Stock Item Transaction ID] int NOT NULL,
	[WWI Invoice ID] int NULL,
	[WWI Purchase Order ID] int NULL,
	[Quantity] int NOT NULL
);
