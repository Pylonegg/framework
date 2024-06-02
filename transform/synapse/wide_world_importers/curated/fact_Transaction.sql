
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_Transaction]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_Transaction]
(
    [Transaction Key] INT IDENTITY(1,1),
    [Date Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Bill To Customer Key] int NOT NULL,
	[Supplier Key] int NOT NULL,
	[Transaction Type Key] int NOT NULL,
	[Payment Method Key] int NOT NULL,
	[WWI Customer Transaction ID] int NOT NULL,
	[WWI Supplier Transaction ID] int NOT NULL,
	[WWI Invoice ID] int NOT NULL,
	[WWI Purchase Order ID] int NOT NULL,
	[Supplier Invoice Number] nvarchar(20) NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL,
	[Outstanding Balance] decimal NOT NULL,
	[Is Finalized] bit NOT NULL,
	[Lineage Key] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_Transaction]
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
    