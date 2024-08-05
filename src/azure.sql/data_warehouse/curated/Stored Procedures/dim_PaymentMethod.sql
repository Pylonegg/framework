
CREATE PROCEDURE [curated].[sp_dim_PaymentMethod]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_PaymentMethod];

INSERT INTO [curated].[dim_PaymentMethod](
    [WWI Payment Method ID],
	[Payment Method],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Payment Method ID],
	[Payment Method],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Payment Method ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_PaymentMethod]
END
