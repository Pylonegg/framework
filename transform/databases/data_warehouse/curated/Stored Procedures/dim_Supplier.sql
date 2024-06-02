
CREATE PROCEDURE [curated].[sp_dim_Supplier]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Supplier];

INSERT INTO [curated].[dim_Supplier](
    [WWI Supplier ID],
	[Supplier],
	[Category],
	[Primary Contact],
	[Supplier Reference],
	[Payment Days],
	[Postal Code],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Supplier ID],
	[Supplier],
	[Category],
	[Primary Contact],
	[Supplier Reference],
	[Payment Days],
	[Postal Code],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Supplier ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Supplier]
END
