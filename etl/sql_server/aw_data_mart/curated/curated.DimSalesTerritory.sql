USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimSalesTerritory]') IS NULL
BEGIN
CREATE TABLE [curated].[DimSalesTerritory]
(
    [SalesTerritoryKey] int NOT NULL,
	[SalesTerritoryAlternateKey] int NULL,
	[SalesTerritoryRegion] nvarchar(50) NOT NULL,
	[SalesTerritoryCountry] nvarchar(50) NOT NULL,
	[SalesTerritoryGroup] nvarchar(50) NULL,
	[SalesTerritoryImage] varbinary(max) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimSalesTerritory
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimSalesTerritory] AS T  
USING (
SELECT
    [SalesTerritoryKey],
	[SalesTerritoryAlternateKey],
	[SalesTerritoryRegion],
	[SalesTerritoryCountry],
	[SalesTerritoryGroup],
	[SalesTerritoryImage],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimSalesTerritory]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [SalesTerritoryKey],
	[SalesTerritoryAlternateKey],
	[SalesTerritoryRegion],
	[SalesTerritoryCountry],
	[SalesTerritoryGroup],
	[SalesTerritoryImage],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[SalesTerritoryKey],
	S.[SalesTerritoryAlternateKey],
	S.[SalesTerritoryRegion],
	S.[SalesTerritoryCountry],
	S.[SalesTerritoryGroup],
	S.[SalesTerritoryImage],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimSalesTerritory]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimSalesTerritory] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimSalesTerritory]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimSalesTerritory
