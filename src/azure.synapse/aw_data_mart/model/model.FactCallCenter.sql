USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactCallCenter]
AS
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
	[Date]
FROM [curated].[FactCallCenter]
