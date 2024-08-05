USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimCurrency]') IS NULL
BEGIN
CREATE TABLE [curated].[DimCurrency]
(
    [CurrencyKey] int NOT NULL,
	[CurrencyAlternateKey] nchar(3) NOT NULL,
	[CurrencyName] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimCurrency
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimCurrency] AS T  
USING (
SELECT
    [CurrencyAlternateKey],
	[CurrencyName],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    [CurrencyAlternateKey],''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimCurrency]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [CurrencyAlternateKey],
	[CurrencyName],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[CurrencyAlternateKey],
	S.[CurrencyName],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX([CurrencyKey]) FROM [curated].[DimCurrency]),0)

UPDATE A
SET A.CurrencyKey = COALESCE(A.CurrencyKey, B.new_CurrencyKey)
FROM [curated].[DimCurrency] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY CurrencyKey) new_CurrencyKey, natural_key_hash FROM [curated].[DimCurrency]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimCurrency
