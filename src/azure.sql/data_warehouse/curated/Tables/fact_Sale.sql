
CREATE TABLE [curated].[fact_Sale]
(
    [Sale Key] INT IDENTITY(1,1),
    [City Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Bill To Customer Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Invoice Date Key] int NOT NULL,
	[Delivery Date Key] int NOT NULL,
	[Salesperson Key] int NOT NULL,
	[WWI Invoice ID] int NOT NULL,
	[Description] nvarchar(100) NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Quantity] int NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Tax Rate] decimal NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Profit] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL,
	[Total Dry Items] int NOT NULL,
	[Total Chiller Items] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
