USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactCallCenter]') IS NULL
BEGIN
CREATE TABLE [curated].[FactCallCenter]
(
    [FactCallCenterID] int NOT NULL,
	[DateKey] int NOT NULL,
	[WageType] nvarchar(15) NOT NULL,
	[Shift] nvarchar(20) NOT NULL,
	[LevelOneOperators] smallint NOT NULL,
	[LevelTwoOperators] smallint NOT NULL,
	[TotalOperators] smallint NOT NULL,
	[Calls] int NOT NULL,
	[AutomaticResponses] int NOT NULL,
	[Orders] int NOT NULL,
	[IssuesRaised] smallint NOT NULL,
	[AverageTimePerIssue] smallint NOT NULL,
	[ServiceGrade] float NOT NULL,
	[Date] datetime NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactCallCenter
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactCallCenter] AS T  
USING (
SELECT
    [FactCallCenterID],
	[DateKey],
	[WageType],
	[Shift],
	[LevelOneOperators],
	[LevelTwoOperators],
	[TotalOperators],
	[Calls],
	[AutomaticResponses],
	[Orders],
	[IssuesRaised],
	[AverageTimePerIssue],
	[ServiceGrade],
	[Date],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactCallCenter]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [FactCallCenterID],
	[DateKey],
	[WageType],
	[Shift],
	[LevelOneOperators],
	[LevelTwoOperators],
	[TotalOperators],
	[Calls],
	[AutomaticResponses],
	[Orders],
	[IssuesRaised],
	[AverageTimePerIssue],
	[ServiceGrade],
	[Date],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[FactCallCenterID],
	S.[DateKey],
	S.[WageType],
	S.[Shift],
	S.[LevelOneOperators],
	S.[LevelTwoOperators],
	S.[TotalOperators],
	S.[Calls],
	S.[AutomaticResponses],
	S.[Orders],
	S.[IssuesRaised],
	S.[AverageTimePerIssue],
	S.[ServiceGrade],
	S.[Date],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactCallCenter]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactCallCenter] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactCallCenter]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactCallCenter
