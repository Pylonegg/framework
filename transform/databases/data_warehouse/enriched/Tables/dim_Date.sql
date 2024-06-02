
CREATE TABLE [enriched].[dim_Date]
    (
    [Date] date,
	[Day Number] int,
	[Day] nvarchar(10),
	[Month] nvarchar(10),
	[Short Month] nvarchar(3),
	[Calendar Month Number] int,
	[Calendar Month Label] nvarchar(20),
	[Calendar Year] int,
	[Calendar Year Label] nvarchar(10),
	[Fiscal Month Number] int,
	[Fiscal Month Label] nvarchar(20),
	[Fiscal Year] int,
	[Fiscal Year Label] nvarchar(10),
	[ISO Week Number] int
    );
