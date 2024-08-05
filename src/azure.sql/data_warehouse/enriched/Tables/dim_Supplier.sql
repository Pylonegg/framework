
CREATE TABLE [enriched].[dim_Supplier] 
(
    [WWI Supplier ID] int NOT NULL,
	[Supplier] nvarchar(100) NOT NULL,
	[Category] nvarchar(50) NOT NULL,
	[Primary Contact] nvarchar(50) NOT NULL,
	[Supplier Reference] nvarchar(20) NOT NULL,
	[Payment Days] int NOT NULL,
	[Postal Code] nvarchar(10) NOT NULL
);
