
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_Purchase]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_Purchase]
(
    [Purchase Key] INT IDENTITY(1,1),
    [Date Key] int NOT NULL,
	[Supplier Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[WWI Purchase Order ID] int NOT NULL,
	[Ordered Outers] int NOT NULL,
	[Ordered Quantity] int NOT NULL,
	[Received Outers] int NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Is Order Finalized] bit NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_Purchase]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Purchase];

INSERT INTO [curated].[fact_Purchase](
    [Date Key],
	[Supplier Key],
	[Stock Item Key],
	[WWI Purchase Order ID],
	[Ordered Outers],
	[Ordered Quantity],
	[Received Outers],
	[Package],
	[Is Order Finalized],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date Key],
	[Supplier Key],
	[Stock Item Key],
	[WWI Purchase Order ID],
	[Ordered Outers],
	[Ordered Quantity],
	[Received Outers],
	[Package],
	[Is Order Finalized],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Purchase]
END
    