USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactSalesQuota]') IS NULL
BEGIN
CREATE TABLE [curated].[FactSalesQuota]
(
    [SalesQuotaKey] int NOT NULL,
	[EmployeeKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[CalendarYear] smallint NOT NULL,
	[CalendarQuarter] tinyint NOT NULL,
	[SalesAmountQuota] money NOT NULL,
	[Date] datetime NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactSalesQuota
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactSalesQuota] AS T  
USING (
SELECT
    [SalesQuotaKey],
	[EmployeeKey],
	[DateKey],
	[CalendarYear],
	[CalendarQuarter],
	[SalesAmountQuota],
	[Date],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactSalesQuota]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [SalesQuotaKey],
	[EmployeeKey],
	[DateKey],
	[CalendarYear],
	[CalendarQuarter],
	[SalesAmountQuota],
	[Date],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[SalesQuotaKey],
	S.[EmployeeKey],
	S.[DateKey],
	S.[CalendarYear],
	S.[CalendarQuarter],
	S.[SalesAmountQuota],
	S.[Date],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactSalesQuota]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactSalesQuota] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactSalesQuota]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactSalesQuota
