USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimSalesTerritory]
AS
SELECT  
    [SalesTerritoryKey],
	[SalesTerritoryAlternateKey],
	[SalesTerritoryRegion],
	[SalesTerritoryCountry],
	[SalesTerritoryGroup],
	[SalesTerritoryImage]
FROM [curated].[DimSalesTerritory]
