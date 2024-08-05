
USE [wide_world_importers]
GO

CREATE OR ALTER VIEW [model].[dim_Employee]
AS
SELECT
    [Employee Key],
	[WWI Employee ID],
	[Employee],
	[Preferred Name],
	[Is Salesperson]
FROM [curated].[dim_Employee]
    