USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimReseller]') IS NULL
BEGIN
CREATE TABLE [curated].[DimReseller]
(
    [ResellerKey] int NOT NULL,
	[GeographyKey] int NULL,
	[ResellerAlternateKey] nvarchar(15) NULL,
	[Phone] nvarchar(25) NULL,
	[BusinessType] varchar(20) NOT NULL,
	[ResellerName] nvarchar(50) NOT NULL,
	[NumberEmployees] int NULL,
	[OrderFrequency] char(1) NULL,
	[OrderMonth] tinyint NULL,
	[FirstOrderYear] int NULL,
	[LastOrderYear] int NULL,
	[ProductLine] nvarchar(50) NULL,
	[AddressLine1] nvarchar(60) NULL,
	[AddressLine2] nvarchar(60) NULL,
	[AnnualSales] money NULL,
	[BankName] nvarchar(50) NULL,
	[MinPaymentType] tinyint NULL,
	[MinPaymentAmount] money NULL,
	[AnnualRevenue] money NULL,
	[YearOpened] int NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimReseller
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimReseller] AS T  
USING (
SELECT
    [ResellerKey],
	[GeographyKey],
	[ResellerAlternateKey],
	[Phone],
	[BusinessType],
	[ResellerName],
	[NumberEmployees],
	[OrderFrequency],
	[OrderMonth],
	[FirstOrderYear],
	[LastOrderYear],
	[ProductLine],
	[AddressLine1],
	[AddressLine2],
	[AnnualSales],
	[BankName],
	[MinPaymentType],
	[MinPaymentAmount],
	[AnnualRevenue],
	[YearOpened],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimReseller]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ResellerKey],
	[GeographyKey],
	[ResellerAlternateKey],
	[Phone],
	[BusinessType],
	[ResellerName],
	[NumberEmployees],
	[OrderFrequency],
	[OrderMonth],
	[FirstOrderYear],
	[LastOrderYear],
	[ProductLine],
	[AddressLine1],
	[AddressLine2],
	[AnnualSales],
	[BankName],
	[MinPaymentType],
	[MinPaymentAmount],
	[AnnualRevenue],
	[YearOpened],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ResellerKey],
	S.[GeographyKey],
	S.[ResellerAlternateKey],
	S.[Phone],
	S.[BusinessType],
	S.[ResellerName],
	S.[NumberEmployees],
	S.[OrderFrequency],
	S.[OrderMonth],
	S.[FirstOrderYear],
	S.[LastOrderYear],
	S.[ProductLine],
	S.[AddressLine1],
	S.[AddressLine2],
	S.[AnnualSales],
	S.[BankName],
	S.[MinPaymentType],
	S.[MinPaymentAmount],
	S.[AnnualRevenue],
	S.[YearOpened],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimReseller]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimReseller] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimReseller]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimReseller
