USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimSalesReason]') IS NULL
BEGIN
CREATE TABLE [curated].[DimSalesReason]
(
    [SalesReasonKey] int NOT NULL,
	[SalesReasonAlternateKey] int NOT NULL,
	[SalesReasonName] nvarchar(50) NOT NULL,
	[SalesReasonReasonType] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimSalesReason
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimSalesReason] AS T  
USING (
SELECT
    [SalesReasonKey],
	[SalesReasonAlternateKey],
	[SalesReasonName],
	[SalesReasonReasonType],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimSalesReason]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [SalesReasonKey],
	[SalesReasonAlternateKey],
	[SalesReasonName],
	[SalesReasonReasonType],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[SalesReasonKey],
	S.[SalesReasonAlternateKey],
	S.[SalesReasonName],
	S.[SalesReasonReasonType],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimSalesReason]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimSalesReason] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimSalesReason]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimSalesReason
