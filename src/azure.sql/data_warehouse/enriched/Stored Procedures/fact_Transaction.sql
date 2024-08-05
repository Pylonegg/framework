       
CREATE PROCEDURE [enriched].[sp_fact_Transaction]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_Transaction];

INSERT INTO [enriched].[fact_Transaction]
SELECT
    '' AS [Date Key],
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
    