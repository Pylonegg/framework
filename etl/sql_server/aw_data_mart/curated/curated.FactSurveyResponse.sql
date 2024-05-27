USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactSurveyResponse]') IS NULL
BEGIN
CREATE TABLE [curated].[FactSurveyResponse]
(
    [SurveyResponseKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[CustomerKey] int NOT NULL,
	[ProductCategoryKey] int NOT NULL,
	[EnglishProductCategoryName] nvarchar(50) NOT NULL,
	[ProductSubcategoryKey] int NOT NULL,
	[EnglishProductSubcategoryName] nvarchar(50) NOT NULL,
	[Date] datetime NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactSurveyResponse
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactSurveyResponse] AS T  
USING (
SELECT
    [SurveyResponseKey],
	[DateKey],
	[CustomerKey],
	[ProductCategoryKey],
	[EnglishProductCategoryName],
	[ProductSubcategoryKey],
	[EnglishProductSubcategoryName],
	[Date],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactSurveyResponse]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [SurveyResponseKey],
	[DateKey],
	[CustomerKey],
	[ProductCategoryKey],
	[EnglishProductCategoryName],
	[ProductSubcategoryKey],
	[EnglishProductSubcategoryName],
	[Date],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[SurveyResponseKey],
	S.[DateKey],
	S.[CustomerKey],
	S.[ProductCategoryKey],
	S.[EnglishProductCategoryName],
	S.[ProductSubcategoryKey],
	S.[EnglishProductSubcategoryName],
	S.[Date],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactSurveyResponse]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactSurveyResponse] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactSurveyResponse]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactSurveyResponse
