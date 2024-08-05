       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_Movement]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_Movement]') IS NOT NULL
    DROP TABLE [enriched].[fact_Movement]

	BEGIN
	CREATE TABLE [enriched].[fact_Movement]
		(
		[Date Key] int NOT NULL,
		[Stock Item Key] int NOT NULL,
		[Customer Key] int NULL,
		[Supplier Key] int NULL,
		[Transaction Type Key] int NOT NULL,
		[WWI Stock Item Transaction ID] int NOT NULL,
		[WWI Invoice ID] int NULL,
		[WWI Purchase Order ID] int NULL,
		[Quantity] int NOT NULL,
		);
	END

	INSERT INTO [enriched].[fact_Movement]
    SELECT 
		   format(sit.TransactionOccurredWhen, 'yyyyMMdd') 	AS [Date Key],
           si.[Stock Item key] 									AS [Stock Item key],
           c.[Customer Key] 									AS [Customer Key],
           s.[Supplier Key] 									AS [Supplier Key],
		   tt.[Transaction Type Key] 							AS [Transaction Type Key],
           sit.StockItemTransactionID 						AS [WWI Stock Item Transaction ID],
           sit.InvoiceID 									AS [WWI Invoice ID],
           sit.PurchaseOrderID 								AS [WWI Purchase Order ID],
           CAST(sit.Quantity AS int) 						AS Quantity
    FROM [wide_world_importers].[warehouse].[StockItemTransactions] AS sit
	LEFT JOIN [curated].[dim_StockItem] si
		ON si.[WWI Stock Item ID] = sit.StockItemID
	LEFT JOIN [curated].[dim_Customer] c
		ON c.[WWI Customer ID] = sit.CustomerID
	LEFT JOIN [curated].[dim_Supplier] s
		ON s.[WWI Supplier ID] = sit.SupplierID
	LEFT JOIN [curated].[dim_TransactionType] tt
		ON tt.[WWI Transaction Type ID] = sit.[TransactionTypeID]  

END
    