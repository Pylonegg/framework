
CREATE PROCEDURE [curated].[sp_fact_Transaction]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Transaction];

INSERT INTO [curated].[fact_Transaction](
    [Date Key],
	[Customer Key],
	[Bill To Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[Payment Method Key],
	[WWI Customer Transaction ID],
	[WWI Supplier Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Supplier Invoice Number],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
	[Outstanding Balance],
	[Is Finalized],
	[Lineage Key],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date Key],
	[Customer Key],
	[Bill To Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[Payment Method Key],
	[WWI Customer Transaction ID],
	[WWI Supplier Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Supplier Invoice Number],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
	[Outstanding Balance],
	[Is Finalized],
	[Lineage Key],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Transaction]
END
