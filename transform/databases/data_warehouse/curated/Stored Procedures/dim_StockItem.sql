
CREATE PROCEDURE [curated].[sp_dim_StockItem]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_StockItem];

INSERT INTO [curated].[dim_StockItem](
    [WWI Stock Item ID],
	[Stock Item],
	[Color],
	[Selling Package],
	[Buying Package],
	[Brand],
	[Size],
	[Lead Time Days],
	[Quantity Per Outer],
	[Is Chiller Stock],
	[Barcode],
	[Tax Rate],
	[Unit Price],
	[Recommended Retail Price],
	[Typical Weight Per Unit],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Stock Item ID],
	[Stock Item],
	[Color],
	[Selling Package],
	[Buying Package],
	[Brand],
	[Size],
	[Lead Time Days],
	[Quantity Per Outer],
	[Is Chiller Stock],
	[Barcode],
	[Tax Rate],
	[Unit Price],
	[Recommended Retail Price],
	[Typical Weight Per Unit],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Stock Item ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_StockItem]
END
