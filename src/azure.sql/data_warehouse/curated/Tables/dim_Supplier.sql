
CREATE TABLE [curated].[dim_Supplier]
(
    [Supplier Key] INT IDENTITY(1,1),
    [WWI Supplier ID] int NOT NULL,
	[Supplier] nvarchar(100) NOT NULL,
	[Category] nvarchar(50) NOT NULL,
	[Primary Contact] nvarchar(50) NOT NULL,
	[Supplier Reference] nvarchar(20) NOT NULL,
	[Payment Days] int NOT NULL,
	[Postal Code] nvarchar(10) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
