       
CREATE PROCEDURE [enriched].[sp_fact_Order]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_Order];

INSERT INTO [enriched].[fact_Order]
SELECT
    '' AS [City Key],
	'' AS [Customer Key],
	'' AS [Stock Item Key],
	'' AS [Order Date Key],
	'' AS [Picked Date Key],
	'' AS [Salesperson Key],
	'' AS [Picker Key],
	'' AS [WWI Order ID],
	'' AS [WWI Backorder ID],
	'' AS [Description],
	'' AS [Package],
	'' AS [Quantity],
	'' AS [Unit Price],
	'' AS [Tax Rate],
	'' AS [Total Excluding Tax],
	'' AS [Tax Amount],
	'' AS [Total Including Tax]
END
    