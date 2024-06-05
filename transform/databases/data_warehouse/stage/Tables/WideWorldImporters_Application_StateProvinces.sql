
CREATE TABLE [stage].[WideWorldImporters_Application_StateProvinces]
    (
    [StateProvinceID] int,
	[StateProvinceCode] nvarchar(5),
	[StateProvinceName] nvarchar(50),
	[CountryID] int,
	[SalesTerritory] nvarchar(50),
	[Border] geography(max),
	[LatestRecordedPopulation] bigint,
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
