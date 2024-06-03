
CREATE TABLE [enriched].[dim_Customer]
    (
    [WWI Customer ID] int,
	[Customer] nvarchar(100),
	[Bill To Customer] nvarchar(100),
	[Category] nvarchar(50),
	[Buying Group] nvarchar(50),
	[Primary Contact] nvarchar(50),
	[Postal Code] nvarchar(10)
    );
