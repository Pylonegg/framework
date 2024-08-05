USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimOrganization]') IS NULL
BEGIN
CREATE TABLE [curated].[DimOrganization]
(
    [OrganizationKey] int NOT NULL,
	[ParentOrganizationKey] int NULL,
	[PercentageOfOwnership] nvarchar(16) NULL,
	[OrganizationName] nvarchar(50) NULL,
	[CurrencyKey] int NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimOrganization
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimOrganization] AS T  
USING (
SELECT
    [OrganizationKey],
	[ParentOrganizationKey],
	[PercentageOfOwnership],
	[OrganizationName],
	[CurrencyKey],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimOrganization]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [OrganizationKey],
	[ParentOrganizationKey],
	[PercentageOfOwnership],
	[OrganizationName],
	[CurrencyKey],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[OrganizationKey],
	S.[ParentOrganizationKey],
	S.[PercentageOfOwnership],
	S.[OrganizationName],
	S.[CurrencyKey],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimOrganization]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimOrganization] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimOrganization]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimOrganization
