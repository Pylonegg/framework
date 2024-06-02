USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimReseller]
AS
SELECT  
    [ResellerKey],
	[GeographyKey],
	[ResellerAlternateKey],
	[Phone],
	[BusinessType],
	[ResellerName],
	[NumberEmployees],
	[OrderFrequency],
	[OrderMonth],
	[FirstOrderYear],
	[LastOrderYear],
	[ProductLine],
	[AddressLine1],
	[AddressLine2],
	[AnnualSales],
	[BankName],
	[MinPaymentType],
	[MinPaymentAmount],
	[AnnualRevenue],
	[YearOpened]
FROM [curated].[DimReseller]
