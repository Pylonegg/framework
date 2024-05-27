       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_Transaction]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_Transaction]') IS NOT NULL
    DROP TABLE [enriched].[fact_Transaction]

BEGIN
CREATE TABLE [enriched].[fact_Transaction]
    (
    [DateKey] date,
	[Customer Key] int,
	[Bill To Customer Key] int,
	[Supplier Key] int,
	[Transaction Type Key] int,
	[Payment Method Key] int,
	[WWI Customer Transaction ID] int,
	[WWI Supplier Transaction ID] int,
	[WWI Invoice ID] int,
	[WWI Purchase Order ID] int,
	[Supplier Invoice Number] nvarchar(20),
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Total Including Tax] decimal,
	[Outstanding Balance] decimal,
	[Is Finalized] bit,
	[Lineage Key] int
    );
END

INSERT INTO [enriched].[fact_Transaction]
SELECT
    '' AS [DateKey],
	'' AS [Customer Key],
	'' AS [Bill To Customer Key],
	'' AS [Supplier Key],
	'' AS [Transaction Type Key],
	'' AS [Payment Method Key],
	'' AS [WWI Customer Transaction ID],
	'' AS [WWI Supplier Transaction ID],
	'' AS [WWI Invoice ID],
	'' AS [WWI Purchase Order ID],
	'' AS [Supplier Invoice Number],
	'' AS [Total Excluding Tax],
	'' AS [Tax Amount],
	'' AS [Total Including Tax],
	'' AS [Outstanding Balance],
	'' AS [Is Finalized],
	'' AS [Lineage Key]

END
    