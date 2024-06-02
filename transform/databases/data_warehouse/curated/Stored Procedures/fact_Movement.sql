
CREATE PROCEDURE [curated].[sp_fact_Movement]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Movement];

INSERT INTO [curated].[fact_Movement](
    [Date Key],
	[Stock Item Key],
	[Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[WWI Stock Item Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Quantity],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date Key],
	[Stock Item Key],
	[Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[WWI Stock Item Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Quantity],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([Date Key],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Movement]
END
