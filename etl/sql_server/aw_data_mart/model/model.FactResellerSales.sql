USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactResellerSales]
AS
SELECT  
    [ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[ResellerKey],
	[EmployeeKey],
	[PromotionKey],
	[CurrencyKey],
	[SalesTerritoryKey],
	[SalesOrderNumber],
	[SalesOrderLineNumber],
	[RevisionNumber],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[TaxAmt],
	[Freight],
	[CarrierTrackingNumber],
	[CustomerPONumber],
	[OrderDate],
	[DueDate],
	[ShipDate]
FROM [curated].[FactResellerSales]
