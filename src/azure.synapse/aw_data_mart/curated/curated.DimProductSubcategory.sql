USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimProductSubcategory]') IS NULL
BEGIN
CREATE TABLE [curated].[DimProductSubcategory]
(
    [ProductSubcategoryKey] int NOT NULL,
	[ProductSubcategoryAlternateKey] int NULL,
	[EnglishProductSubcategoryName] nvarchar(50) NOT NULL,
	[SpanishProductSubcategoryName] nvarchar(50) NOT NULL,
	[FrenchProductSubcategoryName] nvarchar(50) NOT NULL,
	[ProductCategoryKey] int NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimProductSubcategory
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimProductSubcategory] AS T  
USING (
SELECT
    [ProductSubcategoryKey],
	[ProductSubcategoryAlternateKey],
	[EnglishProductSubcategoryName],
	[SpanishProductSubcategoryName],
	[FrenchProductSubcategoryName],
	[ProductCategoryKey],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimProductSubcategory]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ProductSubcategoryKey],
	[ProductSubcategoryAlternateKey],
	[EnglishProductSubcategoryName],
	[SpanishProductSubcategoryName],
	[FrenchProductSubcategoryName],
	[ProductCategoryKey],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductSubcategoryKey],
	S.[ProductSubcategoryAlternateKey],
	S.[EnglishProductSubcategoryName],
	S.[SpanishProductSubcategoryName],
	S.[FrenchProductSubcategoryName],
	S.[ProductCategoryKey],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimProductSubcategory]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimProductSubcategory] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimProductSubcategory]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimProductSubcategory
