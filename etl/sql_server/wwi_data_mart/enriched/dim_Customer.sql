       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_Customer]
AS

BEGIN
IF OBJECT_ID('[enriched].[dim_Customer]') IS NOT NULL
    DROP TABLE [enriched].[dim_Customer]

BEGIN
CREATE TABLE [enriched].[dim_Customer]
    (
    [WWI Customer ID] int,
	[Customer] nvarchar(100),
	[Bill To Customer] nvarchar(100),
	[Category] nvarchar(50),
	[Buying Group] nvarchar(50),
	[Primary Contact] nvarchar(50),
	[Postal Code] nvarchar(10)
    );
END

INSERT INTO [enriched].[dim_Customer]
	SELECT 
		   c.[CustomerID]                           AS [WWI Customer ID]
		,  c.[CustomerName]                         AS [Customer]
		, bt.[CustomerName]                         AS [Bill To Customer]
		, cc.[CustomerCategoryName]                 AS [Category]
		, bg.[BuyingGroupName]                      AS [Buying Group]
		,  p.[FullName]                             AS [Primary Contact]
		,  c.[DeliveryPostalCode]                   AS [Postal Code]
	FROM [wide_world_importers].[sales].[Customers] 				AS c
	INNER JOIN [wide_world_importers].[sales].[BuyingGroups] 			AS bg
		ON c.[BuyingGroupID] = bg.[BuyingGroupID]
	INNER JOIN [wide_world_importers].[sales].[CustomerCategories] 	AS cc
		ON c.[CustomerCategoryID] = cc.[CustomerCategoryID]
	INNER JOIN [wide_world_importers].[sales].[Customers] 			AS bt
		ON c.[BillToCustomerID] = bt.[CustomerID]
	INNER JOIN [wide_world_importers].[application].[People] 		AS p
		ON c.[PrimaryContactPersonID] = p.[PersonID]    
END
    