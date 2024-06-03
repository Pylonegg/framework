
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[fact_Transaction]
AS
SELECT
    [Transaction Key],
	[Date Key],
	[Customer Key],
	[Bill To Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[Payment Method Key],
	[WWI Customer Transaction ID],
	[WWI Supplier Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Supplier Invoice Number],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
	[Outstanding Balance],
	[Is Finalized],
	[Lineage Key]
FROM [curated].[fact_Transaction]
    