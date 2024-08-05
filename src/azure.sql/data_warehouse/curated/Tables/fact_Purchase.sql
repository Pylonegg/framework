
CREATE TABLE [curated].[fact_Purchase]
(
    [Purchase Key] INT IDENTITY(1,1),
    [Date Key] int NOT NULL,
	[Supplier Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[WWI Purchase Order ID] int NOT NULL,
	[Ordered Outers] int NOT NULL,
	[Ordered Quantity] int NOT NULL,
	[Received Outers] int NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Is Order Finalized] bit NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
