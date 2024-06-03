       
CREATE PROCEDURE [enriched].[sp_dim_TransactionType]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_TransactionType];

    INSERT INTO [enriched].[dim_TransactionType]
	SELECT
		p.TransactionTypeID 	AS [WWI Transaction Type ID]
		,p.TransactionTypeName 	AS [Transaction Type]
	FROM [wide_world_importers].[application].[TransactionTypes] p   
END
    