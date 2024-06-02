
CREATE PROCEDURE [curated].[sp_dim_City]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_City];

INSERT INTO [curated].[dim_City](
    [WWI City ID],
	[City],
	[State Province],
	[Country],
	[Continent],
	[Sales Territory],
	[Region],
	[Subregion],
	[Location],
	[Latest Recorded Population],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI City ID],
	[City],
	[State Province],
	[Country],
	[Continent],
	[Sales Territory],
	[Region],
	[Subregion],
	[Location],
	[Latest Recorded Population],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI City ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_City]
END
