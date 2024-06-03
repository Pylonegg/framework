
CREATE PROCEDURE [curated].[sp_fact_Purchase]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Purchase];

INSERT INTO [curated].[fact_Purchase](
    [Date Key],
	[Supplier Key],
	[Stock Item Key],
	[WWI Purchase Order ID],
	[Ordered Outers],
	[Ordered Quantity],
	[Received Outers],
	[Package],
	[Is Order Finalized],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date Key],
	[Supplier Key],
	[Stock Item Key],
	[WWI Purchase Order ID],
	[Ordered Outers],
	[Ordered Quantity],
	[Received Outers],
	[Package],
	[Is Order Finalized],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Purchase]
END
