USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactCurrencyRate]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactCurrencyRate]
    (
    [CurrencyKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[AverageRate] float NOT NULL,
	[EndOfDayRate] float NOT NULL,
	[Date] datetime NULL
    );
END
