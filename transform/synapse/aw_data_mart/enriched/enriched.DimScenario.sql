USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimScenario]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimScenario]
    (
    [ScenarioKey] int NOT NULL,
	[ScenarioName] nvarchar(50) NULL
    );
END
