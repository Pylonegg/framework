USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimDate]') IS NULL
BEGIN
CREATE TABLE [curated].[DimDate]
(
    [DateKey] int NOT NULL,
	[FullDateAlternateKey] date NOT NULL,
	[DayNumberOfWeek] tinyint NOT NULL,
	[EnglishDayNameOfWeek] nvarchar(10) NOT NULL,
	[SpanishDayNameOfWeek] nvarchar(10) NOT NULL,
	[FrenchDayNameOfWeek] nvarchar(10) NOT NULL,
	[DayNumberOfMonth] tinyint NOT NULL,
	[DayNumberOfYear] smallint NOT NULL,
	[WeekNumberOfYear] tinyint NOT NULL,
	[EnglishMonthName] nvarchar(10) NOT NULL,
	[SpanishMonthName] nvarchar(10) NOT NULL,
	[FrenchMonthName] nvarchar(10) NOT NULL,
	[MonthNumberOfYear] tinyint NOT NULL,
	[CalendarQuarter] tinyint NOT NULL,
	[CalendarYear] smallint NOT NULL,
	[CalendarSemester] tinyint NOT NULL,
	[FiscalQuarter] tinyint NOT NULL,
	[FiscalYear] smallint NOT NULL,
	[FiscalSemester] tinyint NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimDate
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimDate] AS T  
USING (
SELECT
    [FullDateAlternateKey],
	[DayNumberOfWeek],
	[EnglishDayNameOfWeek],
	[SpanishDayNameOfWeek],
	[FrenchDayNameOfWeek],
	[DayNumberOfMonth],
	[DayNumberOfYear],
	[WeekNumberOfYear],
	[EnglishMonthName],
	[SpanishMonthName],
	[FrenchMonthName],
	[MonthNumberOfYear],
	[CalendarQuarter],
	[CalendarYear],
	[CalendarSemester],
	[FiscalQuarter],
	[FiscalYear],
	[FiscalSemester],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    [FullDateAlternateKey],''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimDate]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [FullDateAlternateKey],
	[DayNumberOfWeek],
	[EnglishDayNameOfWeek],
	[SpanishDayNameOfWeek],
	[FrenchDayNameOfWeek],
	[DayNumberOfMonth],
	[DayNumberOfYear],
	[WeekNumberOfYear],
	[EnglishMonthName],
	[SpanishMonthName],
	[FrenchMonthName],
	[MonthNumberOfYear],
	[CalendarQuarter],
	[CalendarYear],
	[CalendarSemester],
	[FiscalQuarter],
	[FiscalYear],
	[FiscalSemester],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[FullDateAlternateKey],
	S.[DayNumberOfWeek],
	S.[EnglishDayNameOfWeek],
	S.[SpanishDayNameOfWeek],
	S.[FrenchDayNameOfWeek],
	S.[DayNumberOfMonth],
	S.[DayNumberOfYear],
	S.[WeekNumberOfYear],
	S.[EnglishMonthName],
	S.[SpanishMonthName],
	S.[FrenchMonthName],
	S.[MonthNumberOfYear],
	S.[CalendarQuarter],
	S.[CalendarYear],
	S.[CalendarSemester],
	S.[FiscalQuarter],
	S.[FiscalYear],
	S.[FiscalSemester],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX([DateKey]) FROM [curated].[DimDate]),0)

UPDATE A
SET A.DateKey = COALESCE(A.DateKey, B.new_DateKey)
FROM [curated].[DimDate] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY DateKey) new_DateKey, natural_key_hash FROM [curated].[DimDate]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimDate
