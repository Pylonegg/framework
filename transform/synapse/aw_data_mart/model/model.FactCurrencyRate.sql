USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactCurrencyRate]
AS
SELECT  
    [CurrencyKey],
	[DateKey],
	[AverageRate],
	[EndOfDayRate],
	[Date]
FROM [curated].[FactCurrencyRate]
