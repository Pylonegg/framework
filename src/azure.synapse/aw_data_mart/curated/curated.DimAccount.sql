USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimAccount]') IS NULL
BEGIN
CREATE TABLE [curated].[DimAccount]
(
    [AccountKey] int NOT NULL,
	[ParentAccountKey] int NULL,
	[AccountCodeAlternateKey] int NULL,
	[ParentAccountCodeAlternateKey] int NULL,
	[AccountDescription] nvarchar(50) NULL,
	[AccountType] nvarchar(50) NULL,
	[Operator] nvarchar(50) NULL,
	[CustomMembers] nvarchar(300) NULL,
	[ValueType] nvarchar(50) NULL,
	[CustomMemberOptions] nvarchar(200) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimAccount
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimAccount] AS T  
USING (
SELECT
    [ParentAccountKey],
	[AccountCodeAlternateKey],
	[ParentAccountCodeAlternateKey],
	[AccountDescription],
	[AccountType],
	[Operator],
	[CustomMembers],
	[ValueType],
	[CustomMemberOptions],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    [ParentAccountKey],''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimAccount]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ParentAccountKey],
	[AccountCodeAlternateKey],
	[ParentAccountCodeAlternateKey],
	[AccountDescription],
	[AccountType],
	[Operator],
	[CustomMembers],
	[ValueType],
	[CustomMemberOptions],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ParentAccountKey],
	S.[AccountCodeAlternateKey],
	S.[ParentAccountCodeAlternateKey],
	S.[AccountDescription],
	S.[AccountType],
	S.[Operator],
	S.[CustomMembers],
	S.[ValueType],
	S.[CustomMemberOptions],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX([AccountKey]) FROM [curated].[DimAccount]),0)

UPDATE A
SET A.AccountKey = COALESCE(A.AccountKey, B.new_AccountKey)
FROM [curated].[DimAccount] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY AccountKey) new_AccountKey, natural_key_hash FROM [curated].[DimAccount]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimAccount
