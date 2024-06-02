
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_Sale]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_Sale]
(
    [Sale Key] INT IDENTITY(1,1),
    [City Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Bill To Customer Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Invoice Date Key] int NOT NULL,
	[Delivery Date Key] int NOT NULL,
	[Salesperson Key] int NOT NULL,
	[WWI Invoice ID] int NOT NULL,
	[Description] nvarchar(100) NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Quantity] int NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Tax Rate] decimal NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Profit] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL,
	[Total Dry Items] int NOT NULL,
	[Total Chiller Items] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_Sale]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Sale];

INSERT INTO [curated].[fact_Sale](
    [City Key],
	[Customer Key],
	[Bill To Customer Key],
	[Stock Item Key],
	[Invoice Date Key],
	[Delivery Date Key],
	[Salesperson Key],
	[WWI Invoice ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Profit],
	[Total Including Tax],
	[Total Dry Items],
	[Total Chiller Items],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [City Key],
	[Customer Key],
	[Bill To Customer Key],
	[Stock Item Key],
	[Invoice Date Key],
	[Delivery Date Key],
	[Salesperson Key],
	[WWI Invoice ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Profit],
	[Total Including Tax],
	[Total Dry Items],
	[Total Chiller Items],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Sale]
END
    