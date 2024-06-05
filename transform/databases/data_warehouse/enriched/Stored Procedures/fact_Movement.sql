       
CREATE PROCEDURE [enriched].[sp_fact_Movement]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_Movement];

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
    FROM [stage].[WideWorldImporters_Warehouse_StockItemTransactions] AS sit
	LEFT JOIN [curated].[dim_StockItem] si
		ON si.[WWI Stock Item ID] = sit.StockItemID
	LEFT JOIN [curated].[dim_Customer] c
		ON c.[WWI Customer ID] = sit.CustomerID
	LEFT JOIN [curated].[dim_Supplier] s
		ON s.[WWI Supplier ID] = sit.SupplierID
	LEFT JOIN [curated].[dim_TransactionType] tt
		ON tt.[WWI Transaction Type ID] = sit.[TransactionTypeID]  
END
    