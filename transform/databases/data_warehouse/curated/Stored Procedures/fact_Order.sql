
CREATE PROCEDURE [curated].[sp_fact_Order]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Order];

INSERT INTO [curated].[fact_Order](
    [City Key],
	[Customer Key],
	[Stock Item Key],
	[Order Date Key],
	[Picked Date Key],
	[Salesperson Key],
	[Picker Key],
	[WWI Order ID],
	[WWI Backorder ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [City Key],
	[Customer Key],
	[Stock Item Key],
	[Order Date Key],
	[Picked Date Key],
	[Salesperson Key],
	[Picker Key],
	[WWI Order ID],
	[WWI Backorder ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Order]
END
