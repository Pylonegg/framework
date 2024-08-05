USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactInternetSalesReason]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactInternetSalesReason]
    (
    [SalesOrderNumber] nvarchar(20) NOT NULL,
	[SalesOrderLineNumber] tinyint NOT NULL,
	[SalesReasonKey] int NOT NULL
    );
END
