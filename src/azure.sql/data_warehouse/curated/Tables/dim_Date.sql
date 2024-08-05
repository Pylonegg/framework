
CREATE TABLE [curated].[dim_Date]
(
    [Date Key] INT IDENTITY(1,1),
    [Date] date NOT NULL,
	[Day Number] int NOT NULL,
	[Day] nvarchar(10) NOT NULL,
	[Month] nvarchar(10) NOT NULL,
	[Short Month] nvarchar(3) NOT NULL,
	[Calendar Month Number] int NOT NULL,
	[Calendar Month Label] nvarchar(20) NOT NULL,
	[Calendar Year] int NOT NULL,
	[Calendar Year Label] nvarchar(10) NOT NULL,
	[Fiscal Month Number] int NOT NULL,
	[Fiscal Month Label] nvarchar(20) NOT NULL,
	[Fiscal Year] int NOT NULL,
	[Fiscal Year Label] nvarchar(10) NOT NULL,
	[ISO Week Number] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
