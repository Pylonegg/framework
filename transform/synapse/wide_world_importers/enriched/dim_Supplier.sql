       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_Supplier]
AS

BEGIN
	IF OBJECT_ID('[enriched].[dim_Supplier]') IS NOT NULL
		DROP TABLE [enriched].[dim_Supplier]

	BEGIN
	CREATE TABLE [enriched].[dim_Supplier]
		(
		[WWI Supplier ID] int,
		[Supplier] nvarchar(100),
		[Category] nvarchar(50),
		[Primary Contact] nvarchar(50),
		[Supplier Reference] nvarchar(20),
		[Payment Days] int,
		[Postal Code] nvarchar(10)
		);
	END

	INSERT INTO [enriched].[dim_Supplier]
	SELECT
		 s.SupplierID                 AS  [WWI Supplier ID]
		,s.SupplierName               AS  [Supplier]
		,sc.SupplierCategoryName      AS  [Category]
		,p.FullName                   AS  [Primary Contact]
		,s.SupplierReference          AS  [Supplier Reference]
		,s.PaymentDays                AS  [Payment Days]
		,s.DeliveryPostalCode         AS  [Postal Code]
	FROM [wide_world_importers].[purchasing].[Suppliers] s
	INNER JOIN [wide_world_importers].[purchasing].[SupplierCategories] sc
	ON s.SupplierCategoryID = sc.SupplierCategoryID
	INNER JOIN [wide_world_importers].[application].[People] p
	ON s.PrimaryContactPersonID = p.PersonID 

END
    