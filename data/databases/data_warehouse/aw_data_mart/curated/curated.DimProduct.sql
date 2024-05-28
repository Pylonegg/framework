USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimProduct]') IS NULL
BEGIN
CREATE TABLE [curated].[DimProduct]
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
	[Status] nvarchar(7) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimProduct
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimProduct] AS T  
USING (
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
	[Status],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimProduct]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
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
	[Status],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductKey],
	S.[ProductAlternateKey],
	S.[ProductSubcategoryKey],
	S.[WeightUnitMeasureCode],
	S.[SizeUnitMeasureCode],
	S.[EnglishProductName],
	S.[SpanishProductName],
	S.[FrenchProductName],
	S.[StandardCost],
	S.[FinishedGoodsFlag],
	S.[Color],
	S.[SafetyStockLevel],
	S.[ReorderPoint],
	S.[ListPrice],
	S.[Size],
	S.[SizeRange],
	S.[Weight],
	S.[DaysToManufacture],
	S.[ProductLine],
	S.[DealerPrice],
	S.[Class],
	S.[Style],
	S.[ModelName],
	S.[LargePhoto],
	S.[EnglishDescription],
	S.[FrenchDescription],
	S.[ChineseDescription],
	S.[ArabicDescription],
	S.[HebrewDescription],
	S.[ThaiDescription],
	S.[GermanDescription],
	S.[JapaneseDescription],
	S.[TurkishDescription],
	S.[StartDate],
	S.[EndDate],
	S.[Status],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimProduct]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimProduct] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimProduct]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimProduct
