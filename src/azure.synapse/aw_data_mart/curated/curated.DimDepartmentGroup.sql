USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimDepartmentGroup]') IS NULL
BEGIN
CREATE TABLE [curated].[DimDepartmentGroup]
(
    [DepartmentGroupKey] int NOT NULL,
	[ParentDepartmentGroupKey] int NULL,
	[DepartmentGroupName] nvarchar(50) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimDepartmentGroup
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimDepartmentGroup] AS T  
USING (
SELECT
    [DepartmentGroupKey],
	[ParentDepartmentGroupKey],
	[DepartmentGroupName],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimDepartmentGroup]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [DepartmentGroupKey],
	[ParentDepartmentGroupKey],
	[DepartmentGroupName],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[DepartmentGroupKey],
	S.[ParentDepartmentGroupKey],
	S.[DepartmentGroupName],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimDepartmentGroup]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimDepartmentGroup] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimDepartmentGroup]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimDepartmentGroup
