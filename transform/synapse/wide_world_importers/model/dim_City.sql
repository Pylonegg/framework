
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[dim_City]
AS
SELECT
    [City Key],
	[WWI City ID],
	[City],
	[State Province],
	[Country],
	[Continent],
	[Sales Territory],
	[Region],
	[Subregion],
	[Location],
	[Latest Recorded Population]
FROM [curated].[dim_City]
    