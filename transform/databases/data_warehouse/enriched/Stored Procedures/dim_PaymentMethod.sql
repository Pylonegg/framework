       
CREATE PROCEDURE [enriched].[sp_dim_PaymentMethod]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_PaymentMethod];

	INSERT INTO [enriched].[dim_PaymentMethod]      
	SELECT        
		 p.PaymentMethodID      AS [WWI Payment Method ID]
		,p.PaymentMethodName    AS [Payment Method]
	FROM [stage].[WideWorldImporters_Application_PaymentMethods] p  
END
    