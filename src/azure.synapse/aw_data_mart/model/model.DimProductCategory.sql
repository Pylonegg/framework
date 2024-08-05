USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimProductCategory]
AS
SELECT  
    [ProductCategoryKey],
	[ProductCategoryAlternateKey],
	[EnglishProductCategoryName],
	[SpanishProductCategoryName],
	[FrenchProductCategoryName]
FROM [curated].[DimProductCategory]
