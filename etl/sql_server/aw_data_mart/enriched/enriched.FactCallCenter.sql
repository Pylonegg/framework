USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactCallCenter]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactCallCenter]
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
	[Date] datetime NULL
    );
END
