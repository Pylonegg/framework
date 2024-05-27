
USE [wwi_data_mart]
GO

CREATE OR ALTER VIEW [model].[dim_PaymentMethod]
AS
SELECT
    [Payment Method Key],
	[WWI Payment Method ID],
	[Payment Method]
FROM [curated].[dim_PaymentMethod]
    