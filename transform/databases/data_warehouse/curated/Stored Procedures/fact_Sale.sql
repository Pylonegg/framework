
CREATE PROCEDURE [curated].[sp_fact_Sale]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Sale];

INSERT INTO [curated].[fact_Sale](
    [City Key],
	[Customer Key],
	[Bill To Customer Key],
	[Stock Item Key],
	[Invoice Date Key],
	[Delivery Date Key],
	[Salesperson Key],
	[WWI Invoice ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Profit],
	[Total Including Tax],
	[Total Dry Items],
	[Total Chiller Items],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [City Key],
	[Customer Key],
	[Bill To Customer Key],
	[Stock Item Key],
	[Invoice Date Key],
	[Delivery Date Key],
	[Salesperson Key],
	[WWI Invoice ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Profit],
	[Total Including Tax],
	[Total Dry Items],
	[Total Chiller Items],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Sale]
END
