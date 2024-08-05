
CREATE TABLE [enriched].[dim_City] 
(
    [WWI City ID] int NOT NULL,
	[City] nvarchar(50) NOT NULL,
	[State Province] nvarchar(50) NOT NULL,
	[Country] nvarchar(60) NOT NULL,
	[Continent] nvarchar(30) NOT NULL,
	[Sales Territory] nvarchar(50) NOT NULL,
	[Region] nvarchar(30) NOT NULL,
	[Subregion] nvarchar(30) NOT NULL,
	[Location] nvarchar(max) NOT NULL,
	[Latest Recorded Population] bigint NOT NULL
);
