USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimCurrency]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimCurrency]
    (
    [CurrencyAlternateKey] nchar(3) NOT NULL,
	[CurrencyName] nvarchar(50) NOT NULL
    );
END
