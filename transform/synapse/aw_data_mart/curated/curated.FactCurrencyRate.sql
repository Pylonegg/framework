USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactCurrencyRate]') IS NULL
BEGIN
CREATE TABLE [curated].[FactCurrencyRate]
(
    [CurrencyKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[AverageRate] float NOT NULL,
	[EndOfDayRate] float NOT NULL,
	[Date] datetime NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactCurrencyRate
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactCurrencyRate] AS T  
USING (
SELECT
    [CurrencyKey],
	[DateKey],
	[AverageRate],
	[EndOfDayRate],
	[Date],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactCurrencyRate]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [CurrencyKey],
	[DateKey],
	[AverageRate],
	[EndOfDayRate],
	[Date],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[CurrencyKey],
	S.[DateKey],
	S.[AverageRate],
	S.[EndOfDayRate],
	S.[Date],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactCurrencyRate]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactCurrencyRate] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactCurrencyRate]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactCurrencyRate
