
CREATE TABLE [enriched].[dim_City]
    (
    [WWI City ID] int,
	[City] nvarchar(50),
	[State Province] nvarchar(50),
	[Country] nvarchar(60),
	[Continent] nvarchar(30),
	[Sales Territory] nvarchar(50),
	[Region] nvarchar(30),
	[Subregion] nvarchar(30),
	[Location] nvarchar(max),
	[Latest Recorded Population] bigint
    );
