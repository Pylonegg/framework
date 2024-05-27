USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimProductSubcategory]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimProductSubcategory]
    (
    [ProductSubcategoryKey] int NOT NULL,
	[ProductSubcategoryAlternateKey] int NULL,
	[EnglishProductSubcategoryName] nvarchar(50) NOT NULL,
	[SpanishProductSubcategoryName] nvarchar(50) NOT NULL,
	[FrenchProductSubcategoryName] nvarchar(50) NOT NULL,
	[ProductCategoryKey] int NULL
    );
END
