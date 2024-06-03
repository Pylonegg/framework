USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimSalesTerritory]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimSalesTerritory]
    (
    [SalesTerritoryKey] int NOT NULL,
	[SalesTerritoryAlternateKey] int NULL,
	[SalesTerritoryRegion] nvarchar(50) NOT NULL,
	[SalesTerritoryCountry] nvarchar(50) NOT NULL,
	[SalesTerritoryGroup] nvarchar(50) NULL,
	[SalesTerritoryImage] varbinary(max) NULL
    );
END
