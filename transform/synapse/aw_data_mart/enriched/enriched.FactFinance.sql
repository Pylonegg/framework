USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactFinance]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactFinance]
    (
    [FinanceKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[OrganizationKey] int NOT NULL,
	[DepartmentGroupKey] int NOT NULL,
	[ScenarioKey] int NOT NULL,
	[AccountKey] int NOT NULL,
	[Amount] float NOT NULL,
	[Date] datetime NULL
    );
END
