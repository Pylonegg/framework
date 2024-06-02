       
CREATE PROCEDURE [enriched].[sp_fact_Purchase]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_Purchase];

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
    