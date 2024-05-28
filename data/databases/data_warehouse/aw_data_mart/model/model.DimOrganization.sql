USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimOrganization]
AS
SELECT  
    [OrganizationKey],
	[ParentOrganizationKey],
	[PercentageOfOwnership],
	[OrganizationName],
	[CurrencyKey]
FROM [curated].[DimOrganization]
