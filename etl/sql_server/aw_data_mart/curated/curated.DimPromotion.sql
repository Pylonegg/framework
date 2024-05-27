USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimPromotion]') IS NULL
BEGIN
CREATE TABLE [curated].[DimPromotion]
(
    [PromotionKey] int NOT NULL,
	[PromotionAlternateKey] int NULL,
	[EnglishPromotionName] nvarchar(255) NULL,
	[SpanishPromotionName] nvarchar(255) NULL,
	[FrenchPromotionName] nvarchar(255) NULL,
	[DiscountPct] float NULL,
	[EnglishPromotionType] nvarchar(50) NULL,
	[SpanishPromotionType] nvarchar(50) NULL,
	[FrenchPromotionType] nvarchar(50) NULL,
	[EnglishPromotionCategory] nvarchar(50) NULL,
	[SpanishPromotionCategory] nvarchar(50) NULL,
	[FrenchPromotionCategory] nvarchar(50) NULL,
	[StartDate] datetime NOT NULL,
	[EndDate] datetime NULL,
	[MinQty] int NULL,
	[MaxQty] int NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimPromotion
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimPromotion] AS T  
USING (
SELECT
    [PromotionKey],
	[PromotionAlternateKey],
	[EnglishPromotionName],
	[SpanishPromotionName],
	[FrenchPromotionName],
	[DiscountPct],
	[EnglishPromotionType],
	[SpanishPromotionType],
	[FrenchPromotionType],
	[EnglishPromotionCategory],
	[SpanishPromotionCategory],
	[FrenchPromotionCategory],
	[StartDate],
	[EndDate],
	[MinQty],
	[MaxQty],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimPromotion]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [PromotionKey],
	[PromotionAlternateKey],
	[EnglishPromotionName],
	[SpanishPromotionName],
	[FrenchPromotionName],
	[DiscountPct],
	[EnglishPromotionType],
	[SpanishPromotionType],
	[FrenchPromotionType],
	[EnglishPromotionCategory],
	[SpanishPromotionCategory],
	[FrenchPromotionCategory],
	[StartDate],
	[EndDate],
	[MinQty],
	[MaxQty],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[PromotionKey],
	S.[PromotionAlternateKey],
	S.[EnglishPromotionName],
	S.[SpanishPromotionName],
	S.[FrenchPromotionName],
	S.[DiscountPct],
	S.[EnglishPromotionType],
	S.[SpanishPromotionType],
	S.[FrenchPromotionType],
	S.[EnglishPromotionCategory],
	S.[SpanishPromotionCategory],
	S.[FrenchPromotionCategory],
	S.[StartDate],
	S.[EndDate],
	S.[MinQty],
	S.[MaxQty],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimPromotion]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimPromotion] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimPromotion]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimPromotion
