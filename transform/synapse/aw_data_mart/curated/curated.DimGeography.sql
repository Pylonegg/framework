USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimGeography]') IS NULL
BEGIN
CREATE TABLE [curated].[DimGeography]
(
    [GeographyKey] int NOT NULL,
	[City] nvarchar(30) NULL,
	[StateProvinceCode] nvarchar(3) NULL,
	[StateProvinceName] nvarchar(50) NULL,
	[CountryRegionCode] nvarchar(3) NULL,
	[EnglishCountryRegionName] nvarchar(50) NULL,
	[SpanishCountryRegionName] nvarchar(50) NULL,
	[FrenchCountryRegionName] nvarchar(50) NULL,
	[PostalCode] nvarchar(15) NULL,
	[SalesTerritoryKey] int NULL,
	[IpAddressLocator] nvarchar(15) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimGeography
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimGeography] AS T  
USING (
SELECT
    [GeographyKey],
	[City],
	[StateProvinceCode],
	[StateProvinceName],
	[CountryRegionCode],
	[EnglishCountryRegionName],
	[SpanishCountryRegionName],
	[FrenchCountryRegionName],
	[PostalCode],
	[SalesTerritoryKey],
	[IpAddressLocator],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimGeography]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [GeographyKey],
	[City],
	[StateProvinceCode],
	[StateProvinceName],
	[CountryRegionCode],
	[EnglishCountryRegionName],
	[SpanishCountryRegionName],
	[FrenchCountryRegionName],
	[PostalCode],
	[SalesTerritoryKey],
	[IpAddressLocator],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[GeographyKey],
	S.[City],
	S.[StateProvinceCode],
	S.[StateProvinceName],
	S.[CountryRegionCode],
	S.[EnglishCountryRegionName],
	S.[SpanishCountryRegionName],
	S.[FrenchCountryRegionName],
	S.[PostalCode],
	S.[SalesTerritoryKey],
	S.[IpAddressLocator],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimGeography]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimGeography] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimGeography]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimGeography
