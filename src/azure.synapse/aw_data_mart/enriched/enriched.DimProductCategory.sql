USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimProductCategory]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimProductCategory]
    (
    [ProductCategoryKey] int NOT NULL,
	[ProductCategoryAlternateKey] int NULL,
	[EnglishProductCategoryName] nvarchar(50) NOT NULL,
	[SpanishProductCategoryName] nvarchar(50) NOT NULL,
	[FrenchProductCategoryName] nvarchar(50) NOT NULL
    );
END
