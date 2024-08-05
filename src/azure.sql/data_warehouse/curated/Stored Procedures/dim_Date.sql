
CREATE PROCEDURE [curated].[sp_dim_Date]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Date];

INSERT INTO [curated].[dim_Date](
    [Date],
	[Day Number],
	[Day],
	[Month],
	[Short Month],
	[Calendar Month Number],
	[Calendar Month Label],
	[Calendar Year],
	[Calendar Year Label],
	[Fiscal Month Number],
	[Fiscal Month Label],
	[Fiscal Year],
	[Fiscal Year Label],
	[ISO Week Number],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date],
	[Day Number],
	[Day],
	[Month],
	[Short Month],
	[Calendar Month Number],
	[Calendar Month Label],
	[Calendar Year],
	[Calendar Year Label],
	[Fiscal Month Number],
	[Fiscal Month Label],
	[Fiscal Year],
	[Fiscal Year Label],
	[ISO Week Number],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([Day Number],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Date]
END
