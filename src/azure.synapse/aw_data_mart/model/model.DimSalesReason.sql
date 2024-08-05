USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimSalesReason]
AS
SELECT  
    [SalesReasonKey],
	[SalesReasonAlternateKey],
	[SalesReasonName],
	[SalesReasonReasonType]
FROM [curated].[DimSalesReason]
