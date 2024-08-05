
CREATE PROCEDURE [curated].[sp_fact_StockHolding]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_StockHolding];

INSERT INTO [curated].[fact_StockHolding](
    [Stock Item Key],
	[Quantity On Hand],
	[Bin Location],
	[Last Stocktake Quantity],
	[Last Cost Price],
	[Reorder Level],
	[Target Stock Level],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Stock Item Key],
	[Quantity On Hand],
	[Bin Location],
	[Last Stocktake Quantity],
	[Last Cost Price],
	[Reorder Level],
	[Target Stock Level],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_StockHolding]
END
