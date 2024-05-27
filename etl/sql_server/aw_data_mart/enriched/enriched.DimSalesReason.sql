USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimSalesReason]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimSalesReason]
    (
    [SalesReasonKey] int NOT NULL,
	[SalesReasonAlternateKey] int NOT NULL,
	[SalesReasonName] nvarchar(50) NOT NULL,
	[SalesReasonReasonType] nvarchar(50) NOT NULL
    );
END
