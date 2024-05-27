USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimScenario]
AS
SELECT  
    [ScenarioKey],
	[ScenarioName]
FROM [curated].[DimScenario]
