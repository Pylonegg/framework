       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_PaymentMethod]
AS

	BEGIN
	IF OBJECT_ID('[enriched].[dim_PaymentMethod]') IS NOT NULL
		DROP TABLE [enriched].[dim_PaymentMethod]

	BEGIN
	CREATE TABLE [enriched].[dim_PaymentMethod]
		(
		[WWI Payment Method ID] int,
		[Payment Method] nvarchar(50)
		);
	END

	INSERT INTO [enriched].[dim_PaymentMethod]      
	SELECT        
		 p.PaymentMethodID      AS [WWI Payment Method ID]
		,p.PaymentMethodName    AS [Payment Method]
	FROM [wide_world_importers].[application].[PaymentMethods] p  

END
    