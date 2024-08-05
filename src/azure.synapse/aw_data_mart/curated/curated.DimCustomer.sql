USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimCustomer]') IS NULL
BEGIN
CREATE TABLE [curated].[DimCustomer]
(
    [CustomerKey] int NOT NULL,
	[GeographyKey] int NULL,
	[CustomerAlternateKey] nvarchar(15) NOT NULL,
	[Title] nvarchar(8) NULL,
	[FirstName] nvarchar(50) NULL,
	[MiddleName] nvarchar(50) NULL,
	[LastName] nvarchar(50) NULL,
	[NameStyle] bit NULL,
	[BirthDate] date NULL,
	[MaritalStatus] nchar(1) NULL,
	[Suffix] nvarchar(10) NULL,
	[Gender] nvarchar(1) NULL,
	[EmailAddress] nvarchar(50) NULL,
	[YearlyIncome] money NULL,
	[TotalChildren] tinyint NULL,
	[NumberChildrenAtHome] tinyint NULL,
	[EnglishEducation] nvarchar(40) NULL,
	[SpanishEducation] nvarchar(40) NULL,
	[FrenchEducation] nvarchar(40) NULL,
	[EnglishOccupation] nvarchar(100) NULL,
	[SpanishOccupation] nvarchar(100) NULL,
	[FrenchOccupation] nvarchar(100) NULL,
	[HouseOwnerFlag] nchar(1) NULL,
	[NumberCarsOwned] tinyint NULL,
	[AddressLine1] nvarchar(120) NULL,
	[AddressLine2] nvarchar(120) NULL,
	[Phone] nvarchar(20) NULL,
	[DateFirstPurchase] date NULL,
	[CommuteDistance] nvarchar(15) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimCustomer
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimCustomer] AS T  
USING (
SELECT
    [GeographyKey],
	[CustomerAlternateKey],
	[Title],
	[FirstName],
	[MiddleName],
	[LastName],
	[NameStyle],
	[BirthDate],
	[MaritalStatus],
	[Suffix],
	[Gender],
	[EmailAddress],
	[YearlyIncome],
	[TotalChildren],
	[NumberChildrenAtHome],
	[EnglishEducation],
	[SpanishEducation],
	[FrenchEducation],
	[EnglishOccupation],
	[SpanishOccupation],
	[FrenchOccupation],
	[HouseOwnerFlag],
	[NumberCarsOwned],
	[AddressLine1],
	[AddressLine2],
	[Phone],
	[DateFirstPurchase],
	[CommuteDistance],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    [GeographyKey],''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimCustomer]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [GeographyKey],
	[CustomerAlternateKey],
	[Title],
	[FirstName],
	[MiddleName],
	[LastName],
	[NameStyle],
	[BirthDate],
	[MaritalStatus],
	[Suffix],
	[Gender],
	[EmailAddress],
	[YearlyIncome],
	[TotalChildren],
	[NumberChildrenAtHome],
	[EnglishEducation],
	[SpanishEducation],
	[FrenchEducation],
	[EnglishOccupation],
	[SpanishOccupation],
	[FrenchOccupation],
	[HouseOwnerFlag],
	[NumberCarsOwned],
	[AddressLine1],
	[AddressLine2],
	[Phone],
	[DateFirstPurchase],
	[CommuteDistance],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[GeographyKey],
	S.[CustomerAlternateKey],
	S.[Title],
	S.[FirstName],
	S.[MiddleName],
	S.[LastName],
	S.[NameStyle],
	S.[BirthDate],
	S.[MaritalStatus],
	S.[Suffix],
	S.[Gender],
	S.[EmailAddress],
	S.[YearlyIncome],
	S.[TotalChildren],
	S.[NumberChildrenAtHome],
	S.[EnglishEducation],
	S.[SpanishEducation],
	S.[FrenchEducation],
	S.[EnglishOccupation],
	S.[SpanishOccupation],
	S.[FrenchOccupation],
	S.[HouseOwnerFlag],
	S.[NumberCarsOwned],
	S.[AddressLine1],
	S.[AddressLine2],
	S.[Phone],
	S.[DateFirstPurchase],
	S.[CommuteDistance],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX([CustomerKey]) FROM [curated].[DimCustomer]),0)

UPDATE A
SET A.CustomerKey = COALESCE(A.CustomerKey, B.new_CustomerKey)
FROM [curated].[DimCustomer] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY CustomerKey) new_CustomerKey, natural_key_hash FROM [curated].[DimCustomer]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimCustomer
