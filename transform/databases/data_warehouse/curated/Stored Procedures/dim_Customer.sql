
CREATE PROCEDURE [curated].[sp_dim_Customer]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Customer];

INSERT INTO [curated].[dim_Customer](
    [WWI Customer ID],
	[Customer],
	[Bill To Customer],
	[Category],
	[Buying Group],
	[Primary Contact],
	[Postal Code],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Customer ID],
	[Customer],
	[Bill To Customer],
	[Category],
	[Buying Group],
	[Primary Contact],
	[Postal Code],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Customer ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Customer]
END
