USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactSurveyResponse]
AS
SELECT  
    [SurveyResponseKey],
	[DateKey],
	[CustomerKey],
	[ProductCategoryKey],
	[EnglishProductCategoryName],
	[ProductSubcategoryKey],
	[EnglishProductSubcategoryName],
	[Date]
FROM [curated].[FactSurveyResponse]
