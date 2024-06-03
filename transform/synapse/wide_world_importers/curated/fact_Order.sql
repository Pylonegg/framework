
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[fact_Order]') IS NULL
BEGIN
CREATE TABLE [curated].[fact_Order]
(
    [Order Key] INT IDENTITY(1,1),
    [City Key] int NOT NULL,
	[Customer Key] int NOT NULL,
	[Stock Item Key] int NOT NULL,
	[Order Date Key] int NOT NULL,
	[Picked Date Key] int NOT NULL,
	[Salesperson Key] int NOT NULL,
	[Picker Key] int NOT NULL,
	[WWI Order ID] int NOT NULL,
	[WWI Backorder ID] int NOT NULL,
	[Description] nvarchar(100) NOT NULL,
	[Package] nvarchar(50) NOT NULL,
	[Quantity] int NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Tax Rate] decimal NOT NULL,
	[Total Excluding Tax] decimal NOT NULL,
	[Tax Amount] decimal NOT NULL,
	[Total Including Tax] decimal NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_fact_Order]
AS
BEGIN

TRUNCATE TABLE [curated].[fact_Order];

INSERT INTO [curated].[fact_Order](
    [City Key],
	[Customer Key],
	[Stock Item Key],
	[Order Date Key],
	[Picked Date Key],
	[Salesperson Key],
	[Picker Key],
	[WWI Order ID],
	[WWI Backorder ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [City Key],
	[Customer Key],
	[Stock Item Key],
	[Order Date Key],
	[Picked Date Key],
	[Salesperson Key],
	[Picker Key],
	[WWI Order ID],
	[WWI Backorder ID],
	[Description],
	[Package],
	[Quantity],
	[Unit Price],
	[Tax Rate],
	[Total Excluding Tax],
	[Tax Amount],
	[Total Including Tax],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[fact_Order]
END
    