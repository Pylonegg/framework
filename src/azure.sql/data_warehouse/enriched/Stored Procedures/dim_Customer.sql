       
CREATE PROCEDURE [enriched].[sp_dim_Customer]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_Customer];

INSERT INTO [enriched].[dim_Customer]
	SELECT 
		   c.[CustomerID]                           AS [WWI Customer ID]
		,  c.[CustomerName]                         AS [Customer]
		, bt.[CustomerName]                         AS [Bill To Customer]
		, cc.[CustomerCategoryName]                 AS [Category]
		, bg.[BuyingGroupName]                      AS [Buying Group]
		,  p.[FullName]                             AS [Primary Contact]
		,  c.[DeliveryPostalCode]                   AS [Postal Code]
	FROM [stage].[WideWorldImporters_Sales_Customers] 				AS c
	INNER JOIN [stage].[WideWorldImporters_Sales_BuyingGroups] 			AS bg
		ON c.[BuyingGroupID] = bg.[BuyingGroupID]
	INNER JOIN [stage].[WideWorldImporters_Sales_CustomerCategories] 	AS cc
		ON c.[CustomerCategoryID] = cc.[CustomerCategoryID]
	INNER JOIN [stage].[WideWorldImporters_Sales_Customers] 			AS bt
		ON c.[BillToCustomerID] = bt.[CustomerID]
	INNER JOIN [stage].[WideWorldImporters_Application_People] 		AS p
		ON c.[PrimaryContactPersonID] = p.[PersonID]    
END
    