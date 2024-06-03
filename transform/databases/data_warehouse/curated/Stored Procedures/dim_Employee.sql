
CREATE PROCEDURE [curated].[sp_dim_Employee]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Employee];

INSERT INTO [curated].[dim_Employee](
    [WWI Employee ID],
	[Employee],
	[Preferred Name],
	[Is Salesperson],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Employee ID],
	[Employee],
	[Preferred Name],
	[Is Salesperson],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Employee ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Employee]
END
