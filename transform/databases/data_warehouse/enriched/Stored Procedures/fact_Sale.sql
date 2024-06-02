       
CREATE PROCEDURE [enriched].[sp_fact_Sale]
AS

BEGIN
TRUNCATE TABLE [enriched].[fact_Sale];

INSERT INTO [enriched].[fact_Sale]
SELECT
    '' AS [City Key],
	'' AS [Customer Key],
	'' AS [Bill To Customer Key],
	'' AS [Stock Item Key],
	'' AS [Invoice Date Key],
	'' AS [Delivery Date Key],
	'' AS [Salesperson Key],
	'' AS [WWI Invoice ID],
	'' AS [Description],
	'' AS [Package],
	'' AS [Quantity],
	'' AS [Unit Price],
	'' AS [Tax Rate],
	'' AS [Total Excluding Tax],
	'' AS [Tax Amount],
	'' AS [Profit],
	'' AS [Total Including Tax],
	'' AS [Total Dry Items],
	'' AS [Total Chiller Items]
END
    