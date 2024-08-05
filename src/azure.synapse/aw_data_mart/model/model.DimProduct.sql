USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimProduct]
AS
SELECT  
    [ProductKey],
	[ProductAlternateKey],
	[ProductSubcategoryKey],
	[WeightUnitMeasureCode],
	[SizeUnitMeasureCode],
	[EnglishProductName],
	[SpanishProductName],
	[FrenchProductName],
	[StandardCost],
	[FinishedGoodsFlag],
	[Color],
	[SafetyStockLevel],
	[ReorderPoint],
	[ListPrice],
	[Size],
	[SizeRange],
	[Weight],
	[DaysToManufacture],
	[ProductLine],
	[DealerPrice],
	[Class],
	[Style],
	[ModelName],
	[LargePhoto],
	[EnglishDescription],
	[FrenchDescription],
	[ChineseDescription],
	[ArabicDescription],
	[HebrewDescription],
	[ThaiDescription],
	[GermanDescription],
	[JapaneseDescription],
	[TurkishDescription],
	[StartDate],
	[EndDate],
	[Status]
FROM [curated].[DimProduct]
