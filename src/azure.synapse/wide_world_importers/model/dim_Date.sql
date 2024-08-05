
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[dim_Date]
AS
SELECT
    [Date Key],
	[Date],
	[Day Number],
	[Day],
	[Month],
	[Short Month],
	[Calendar Month Number],
	[Calendar Month Label],
	[Calendar Year],
	[Calendar Year Label],
	[Fiscal Month Number],
	[Fiscal Month Label],
	[Fiscal Year],
	[Fiscal Year Label],
	[ISO Week Number]
FROM [curated].[dim_Date]
    