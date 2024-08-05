USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactProductInventory]') IS NULL
BEGIN
CREATE TABLE [curated].[FactProductInventory]
(
    [ProductKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[MovementDate] date NOT NULL,
	[UnitCost] money NOT NULL,
	[UnitsIn] int NOT NULL,
	[UnitsOut] int NOT NULL,
	[UnitsBalance] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactProductInventory
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactProductInventory] AS T  
USING (
SELECT
    [ProductKey],
	[DateKey],
	[MovementDate],
	[UnitCost],
	[UnitsIn],
	[UnitsOut],
	[UnitsBalance],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactProductInventory]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ProductKey],
	[DateKey],
	[MovementDate],
	[UnitCost],
	[UnitsIn],
	[UnitsOut],
	[UnitsBalance],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductKey],
	S.[DateKey],
	S.[MovementDate],
	S.[UnitCost],
	S.[UnitsIn],
	S.[UnitsOut],
	S.[UnitsBalance],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactProductInventory]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactProductInventory] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactProductInventory]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactProductInventory
