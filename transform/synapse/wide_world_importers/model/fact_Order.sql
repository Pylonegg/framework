
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[fact_Order]
AS
SELECT
    [Order Key],
	[City Key],
	[Customer Key],
	[Stock Item Key],
	[Order Date Key],
	[Picked Date Key],
	[Salesperson Key],
	[Picker Key],
	[WWI Order ID],
	[WWI Backorder ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax]
FROM [curated].[fact_Order]
    