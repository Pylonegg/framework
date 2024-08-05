USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimGeography]
AS
SELECT  
    [GeographyKey],
	[City],
	[StateProvinceCode],
	[StateProvinceName],
	[CountryRegionCode],
	[EnglishCountryRegionName],
	[SpanishCountryRegionName],
	[FrenchCountryRegionName],
	[PostalCode],
	[SalesTerritoryKey],
	[IpAddressLocator]
FROM [curated].[DimGeography]
