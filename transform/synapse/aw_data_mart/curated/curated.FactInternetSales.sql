USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactInternetSales]') IS NULL
BEGIN
CREATE TABLE [curated].[FactInternetSales]
(
    [ProductKey] int NOT NULL,
	[OrderDateKey] int NOT NULL,
	[DueDateKey] int NOT NULL,
	[ShipDateKey] int NOT NULL,
	[CustomerKey] int NOT NULL,
	[PromotionKey] int NOT NULL,
	[CurrencyKey] int NOT NULL,
	[SalesTerritoryKey] int NOT NULL,
	[SalesOrderNumber] nvarchar(20) NOT NULL,
	[SalesOrderLineNumber] tinyint NOT NULL,
	[RevisionNumber] tinyint NOT NULL,
	[OrderQuantity] smallint NOT NULL,
	[UnitPrice] money NOT NULL,
	[ExtendedAmount] money NOT NULL,
	[UnitPriceDiscountPct] float NOT NULL,
	[DiscountAmount] float NOT NULL,
	[ProductStandardCost] money NOT NULL,
	[TotalProductCost] money NOT NULL,
	[SalesAmount] money NOT NULL,
	[TaxAmt] money NOT NULL,
	[Freight] money NOT NULL,
	[CarrierTrackingNumber] nvarchar(25) NULL,
	[CustomerPONumber] nvarchar(25) NULL,
	[OrderDate] datetime NULL,
	[DueDate] datetime NULL,
	[ShipDate] datetime NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_FactInternetSales
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactInternetSales] AS T  
USING (
SELECT
    [ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
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
	[ShipDate],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactInternetSales]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
    [ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
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
	[ShipDate],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductKey],
	S.[OrderDateKey],
	S.[DueDateKey],
	S.[ShipDateKey],
	S.[CustomerKey],
	S.[PromotionKey],
	S.[CurrencyKey],
	S.[SalesTerritoryKey],
	S.[SalesOrderNumber],
	S.[SalesOrderLineNumber],
	S.[RevisionNumber],
	S.[OrderQuantity],
	S.[UnitPrice],
	S.[ExtendedAmount],
	S.[UnitPriceDiscountPct],
	S.[DiscountAmount],
	S.[ProductStandardCost],
	S.[TotalProductCost],
	S.[SalesAmount],
	S.[TaxAmt],
	S.[Freight],
	S.[CarrierTrackingNumber],
	S.[CustomerPONumber],
	S.[OrderDate],
	S.[DueDate],
	S.[ShipDate],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactInternetSales]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactInternetSales] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactInternetSales]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactInternetSales
