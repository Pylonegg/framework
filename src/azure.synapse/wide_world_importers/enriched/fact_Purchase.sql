       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_Purchase]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_Purchase]') IS NOT NULL
    DROP TABLE [enriched].[fact_Purchase]

BEGIN
CREATE TABLE [enriched].[fact_Purchase]
    (
    [Date Key] date,
	[Supplier Key] int,
	[Stock Item Key] int,
	[WWI Purchase Order ID] int,
	[Ordered Outers] int,
	[Ordered Quantity] int,
	[Received Outers] int,
	[Package] nvarchar(50),
	[Is Order Finalized] bit
    );
END

INSERT INTO [enriched].[fact_Purchase]
SELECT
    '' AS [Date Key],
	'' AS [Supplier Key],
	'' AS [Stock Item Key],
	'' AS [WWI Purchase Order ID],
	'' AS [Ordered Outers],
	'' AS [Ordered Quantity],
	'' AS [Received Outers],
	'' AS [Package],
	'' AS [Is Order Finalized]

END
    