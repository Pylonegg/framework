
CREATE TABLE [stage].[WideWorldImporters_Application_Cities]
    (
    [CityID] int,
	[CityName] nvarchar(50),
	[StateProvinceID] int,
	[Location] geography(max),
	[LatestRecordedPopulation] bigint,
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
