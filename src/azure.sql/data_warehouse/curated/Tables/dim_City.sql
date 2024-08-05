
CREATE TABLE [curated].[dim_City]
(
    [City Key] INT IDENTITY(1,1),
    [WWI City ID] int NOT NULL,
	[City] nvarchar(50) NOT NULL,
	[State Province] nvarchar(50) NOT NULL,
	[Country] nvarchar(60) NOT NULL,
	[Continent] nvarchar(30) NOT NULL,
	[Sales Territory] nvarchar(50) NOT NULL,
	[Region] nvarchar(30) NOT NULL,
	[Subregion] nvarchar(30) NOT NULL,
	[Location] nvarchar(max) NOT NULL,
	[Latest Recorded Population] bigint NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
