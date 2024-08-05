USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimProduct]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimProduct]
    (
    [ProductKey] int NOT NULL,
	[ProductAlternateKey] nvarchar(25) NULL,
	[ProductSubcategoryKey] int NULL,
	[WeightUnitMeasureCode] nchar(3) NULL,
	[SizeUnitMeasureCode] nchar(3) NULL,
	[EnglishProductName] nvarchar(50) NOT NULL,
	[SpanishProductName] nvarchar(50) NOT NULL,
	[FrenchProductName] nvarchar(50) NOT NULL,
	[StandardCost] money NULL,
	[FinishedGoodsFlag] bit NOT NULL,
	[Color] nvarchar(15) NOT NULL,
	[SafetyStockLevel] smallint NULL,
	[ReorderPoint] smallint NULL,
	[ListPrice] money NULL,
	[Size] nvarchar(50) NULL,
	[SizeRange] nvarchar(50) NULL,
	[Weight] float NULL,
	[DaysToManufacture] int NULL,
	[ProductLine] nchar(2) NULL,
	[DealerPrice] money NULL,
	[Class] nchar(2) NULL,
	[Style] nchar(2) NULL,
	[ModelName] nvarchar(50) NULL,
	[LargePhoto] varbinary(max) NULL,
	[EnglishDescription] nvarchar(400) NULL,
	[FrenchDescription] nvarchar(400) NULL,
	[ChineseDescription] nvarchar(400) NULL,
	[ArabicDescription] nvarchar(400) NULL,
	[HebrewDescription] nvarchar(400) NULL,
	[ThaiDescription] nvarchar(400) NULL,
	[GermanDescription] nvarchar(400) NULL,
	[JapaneseDescription] nvarchar(400) NULL,
	[TurkishDescription] nvarchar(400) NULL,
	[StartDate] datetime NULL,
	[EndDate] datetime NULL,
	[Status] nvarchar(7) NULL
    );
END
