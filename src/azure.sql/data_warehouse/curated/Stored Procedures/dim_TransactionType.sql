
CREATE PROCEDURE [curated].[sp_dim_TransactionType]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_TransactionType];

INSERT INTO [curated].[dim_TransactionType](
    [WWI Transaction Type ID],
	[Transaction Type],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Transaction Type ID],
	[Transaction Type],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Transaction Type ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_TransactionType]
END
