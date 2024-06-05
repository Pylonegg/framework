       
CREATE PROCEDURE [enriched].[sp_dim_Supplier]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_Supplier];

	INSERT INTO [enriched].[dim_Supplier]
	SELECT
		 s.SupplierID                 AS  [WWI Supplier ID]
		,s.SupplierName               AS  [Supplier]
		,sc.SupplierCategoryName      AS  [Category]
		,p.FullName                   AS  [Primary Contact]
		,s.SupplierReference          AS  [Supplier Reference]
		,s.PaymentDays                AS  [Payment Days]
		,s.DeliveryPostalCode         AS  [Postal Code]
	FROM [stage].[WideWorldImporters_Purchasing_Suppliers] s
	INNER JOIN [stage].[WideWorldImporters_Purchasing_SupplierCategories] sc
	ON s.SupplierCategoryID = sc.SupplierCategoryID
	INNER JOIN [stage].[WideWorldImporters_Application_People] p
	ON s.PrimaryContactPersonID = p.PersonID 
END
    