USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactInternetSalesReason]
AS
SELECT  
    [SalesOrderNumber],
	[SalesOrderLineNumber],
	[SalesReasonKey]
FROM [curated].[FactInternetSalesReason]
