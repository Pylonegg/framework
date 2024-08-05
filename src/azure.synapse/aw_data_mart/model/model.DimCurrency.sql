USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimCurrency]
AS
SELECT  
    [CurrencyKey],
	[CurrencyAlternateKey],
	[CurrencyName]
FROM [curated].[DimCurrency]
