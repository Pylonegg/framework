USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimDate]
AS
SELECT  
    [DateKey],
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
	[FiscalSemester]
FROM [curated].[DimDate]
