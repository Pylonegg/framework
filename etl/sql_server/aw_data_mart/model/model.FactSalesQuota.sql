USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactSalesQuota]
AS
SELECT  
    [SalesQuotaKey],
	[EmployeeKey],
	[DateKey],
	[CalendarYear],
	[CalendarQuarter],
	[SalesAmountQuota],
	[Date]
FROM [curated].[FactSalesQuota]
