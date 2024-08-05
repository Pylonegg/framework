
CREATE TABLE [stage].[WideWorldImporters_Application_Countries]
    (
    [CountryID] int,
	[CountryName] nvarchar(60),
	[FormalName] nvarchar(60),
	[IsoAlpha3Code] nvarchar(3),
	[IsoNumericCode] int,
	[CountryType] nvarchar(20),
	[LatestRecordedPopulation] bigint,
	[Continent] nvarchar(30),
	[Region] nvarchar(30),
	[Subregion] nvarchar(30),
	[Border] geography(max),
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
