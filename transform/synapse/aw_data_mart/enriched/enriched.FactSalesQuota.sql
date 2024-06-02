USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactSalesQuota]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactSalesQuota]
    (
    [SalesQuotaKey] int NOT NULL,
	[EmployeeKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[CalendarYear] smallint NOT NULL,
	[CalendarQuarter] tinyint NOT NULL,
	[SalesAmountQuota] money NOT NULL,
	[Date] datetime NULL
    );
END
