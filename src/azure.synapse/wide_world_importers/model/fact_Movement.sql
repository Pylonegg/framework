
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[fact_Movement]
AS
SELECT
    [Movement Key],
	[Date Key],
	[Stock Item Key],
	[Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[WWI Stock Item Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Quantity]
FROM [curated].[fact_Movement]
    