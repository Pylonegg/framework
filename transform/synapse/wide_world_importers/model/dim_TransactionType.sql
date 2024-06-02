
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[dim_TransactionType]
AS
SELECT
    [Transaction Type Key],
	[WWI Transaction Type ID],
	[Transaction Type]
FROM [curated].[dim_TransactionType]
    