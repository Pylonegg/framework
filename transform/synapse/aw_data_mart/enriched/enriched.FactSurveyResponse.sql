USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactSurveyResponse]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactSurveyResponse]
    (
    [SurveyResponseKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[CustomerKey] int NOT NULL,
	[ProductCategoryKey] int NOT NULL,
	[EnglishProductCategoryName] nvarchar(50) NOT NULL,
	[ProductSubcategoryKey] int NOT NULL,
	[EnglishProductSubcategoryName] nvarchar(50) NOT NULL,
	[Date] datetime NULL
    );
END
