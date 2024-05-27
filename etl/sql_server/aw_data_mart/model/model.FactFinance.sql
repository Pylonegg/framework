USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactFinance]
AS
SELECT  
    [FinanceKey],
	[DateKey],
	[OrganizationKey],
	[DepartmentGroupKey],
	[ScenarioKey],
	[AccountKey],
	[Amount],
	[Date]
FROM [curated].[FactFinance]
