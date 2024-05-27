USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimProductCategory]') IS NULL
BEGIN
CREATE TABLE [curated].[DimProductCategory]
(
    [ProductCategoryKey] int NOT NULL,
	[ProductCategoryAlternateKey] int NULL,
	[EnglishProductCategoryName] nvarchar(50) NOT NULL,
	[SpanishProductCategoryName] nvarchar(50) NOT NULL,
	[FrenchProductCategoryName] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimProductCategory
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimProductCategory] AS T  
USING (
SELECT
    [ProductCategoryKey],
	[ProductCategoryAlternateKey],
	[EnglishProductCategoryName],
	[SpanishProductCategoryName],
	[FrenchProductCategoryName],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimProductCategory]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ProductCategoryKey],
	[ProductCategoryAlternateKey],
	[EnglishProductCategoryName],
	[SpanishProductCategoryName],
	[FrenchProductCategoryName],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductCategoryKey],
	S.[ProductCategoryAlternateKey],
	S.[EnglishProductCategoryName],
	S.[SpanishProductCategoryName],
	S.[FrenchProductCategoryName],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimProductCategory]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimProductCategory] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimProductCategory]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimProductCategory
