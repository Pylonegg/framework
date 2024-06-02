USE [adventure_works]
GO

IF OBJECT_ID('[curated].[FactResellerSales]') IS NULL
BEGIN
CREATE TABLE [curated].[FactResellerSales]
(
    [ProductKey] int NOT NULL,
	[OrderDateKey] int NOT NULL,
	[DueDateKey] int NOT NULL,
	[ShipDateKey] int NOT NULL,
	[ResellerKey] int NOT NULL,
	[EmployeeKey] int NOT NULL,
	[PromotionKey] int NOT NULL,
	[CurrencyKey] int NOT NULL,
	[SalesTerritoryKey] int NOT NULL,
	[SalesOrderNumber] nvarchar(20) NOT NULL,
	[SalesOrderLineNumber] tinyint NOT NULL,
	[RevisionNumber] tinyint NULL,
	[OrderQuantity] smallint NULL,
	[UnitPrice] money NULL,
	[ExtendedAmount] money NULL,
	[UnitPriceDiscountPct] float NULL,
	[DiscountAmount] float NULL,
	[ProductStandardCost] money NULL,
	[TotalProductCost] money NULL,
	[SalesAmount] money NULL,
	[TaxAmt] money NULL,
	[Freight] money NULL,
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

CREATE OR ALTER PROCEDURE curated.curate_FactResellerSales
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[FactResellerSales] AS T  
USING (
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
	[ShipDate],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[FactResellerSales]) S
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
	[ShipDate],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[ProductKey],
	S.[OrderDateKey],
	S.[DueDateKey],
	S.[ShipDateKey],
	S.[ResellerKey],
	S.[EmployeeKey],
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
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[FactResellerSales]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[FactResellerSales] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[FactResellerSales]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_FactResellerSales
