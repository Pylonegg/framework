USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimGeography]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimGeography]
    (
    [GeographyKey] int NOT NULL,
	[City] nvarchar(30) NULL,
	[StateProvinceCode] nvarchar(3) NULL,
	[StateProvinceName] nvarchar(50) NULL,
	[CountryRegionCode] nvarchar(3) NULL,
	[EnglishCountryRegionName] nvarchar(50) NULL,
	[SpanishCountryRegionName] nvarchar(50) NULL,
	[FrenchCountryRegionName] nvarchar(50) NULL,
	[PostalCode] nvarchar(15) NULL,
	[SalesTerritoryKey] int NULL,
	[IpAddressLocator] nvarchar(15) NULL
    );
END
