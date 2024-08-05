USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimProductSubcategory]
AS
SELECT  
    [ProductSubcategoryKey],
	[ProductSubcategoryAlternateKey],
	[EnglishProductSubcategoryName],
	[SpanishProductSubcategoryName],
	[FrenchProductSubcategoryName],
	[ProductCategoryKey]
FROM [curated].[DimProductSubcategory]
