       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_TransactionType]
AS

BEGIN
    IF OBJECT_ID('[enriched].[dim_TransactionType]') IS NOT NULL
        DROP TABLE [enriched].[dim_TransactionType]

    BEGIN
    CREATE TABLE [enriched].[dim_TransactionType]
        (
        [WWI Transaction Type ID] int,
        [Transaction Type] nvarchar(50)
        );
    END

    INSERT INTO [enriched].[dim_TransactionType]
	SELECT
		p.TransactionTypeID 	AS [WWI Transaction Type ID]
		,p.TransactionTypeName 	AS [Transaction Type]
	FROM [wide_world_importers].[application].[TransactionTypes] p   

END
    