USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimOrganization]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimOrganization]
    (
    [OrganizationKey] int NOT NULL,
	[ParentOrganizationKey] int NULL,
	[PercentageOfOwnership] nvarchar(16) NULL,
	[OrganizationName] nvarchar(50) NULL,
	[CurrencyKey] int NULL
    );
END
