
CREATE TABLE [curated].[fact_Movement]
(
    [Movement Key] INT IDENTITY(1,1),
    [Date Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Customer Key] int NULL,
	[Supplier Key] int NULL,
	[Transaction Type Key] int NOT NULL,
	[WWI Stock Item Transaction ID] int NOT NULL,
	[WWI Invoice ID] int NULL,
	[WWI Purchase Order ID] int NULL,
	[Quantity] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
