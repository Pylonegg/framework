
CREATE TABLE [curated].[dim_Customer]
(
    [Customer Key] INT IDENTITY(1,1),
    [WWI Customer ID] int NOT NULL,
	[Customer] nvarchar(100) NOT NULL,
	[Bill To Customer] nvarchar(100) NOT NULL,
	[Category] nvarchar(50) NOT NULL,
	[Buying Group] nvarchar(50) NOT NULL,
	[Primary Contact] nvarchar(50) NOT NULL,
	[Postal Code] nvarchar(10) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
