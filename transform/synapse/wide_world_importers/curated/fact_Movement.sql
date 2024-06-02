
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_Movement]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_Movement]
(
    [Movement Key] INT IDENTITY(1,1),
    [Date Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Customer Key] int NULL,
	[Supplier Key] int NULL,
	[Transaction Type Key] int NOT NULL,
	[WWI Stock Item Transaction ID] int NOT NULL,
	[WWI Invoice ID] int NULL,
	[WWI Purchase Order ID] int NULL,
	[Quantity] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_Movement]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Movement];

INSERT INTO [curated].[fact_Movement](
    [Date Key],
	[Stock Item Key],
	[Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[WWI Stock Item Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Quantity],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date Key],
	[Stock Item Key],
	[Customer Key],
	[Supplier Key],
	[Transaction Type Key],
	[WWI Stock Item Transaction ID],
	[WWI Invoice ID],
	[WWI Purchase Order ID],
	[Quantity],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([Date Key],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Movement]
END
    