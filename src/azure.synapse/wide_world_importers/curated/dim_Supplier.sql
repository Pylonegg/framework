
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_Supplier]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_Supplier]
(
    [Supplier Key] INT IDENTITY(1,1),
    [WWI Supplier ID] int NOT NULL,
	[Supplier] nvarchar(100) NOT NULL,
	[Category] nvarchar(50) NOT NULL,
	[Primary Contact] nvarchar(50) NOT NULL,
	[Supplier Reference] nvarchar(20) NOT NULL,
	[Payment Days] int NOT NULL,
	[Postal Code] nvarchar(10) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_Supplier]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Supplier];

INSERT INTO [curated].[dim_Supplier](
    [WWI Supplier ID],
	[Supplier],
	[Category],
	[Primary Contact],
	[Supplier Reference],
	[Payment Days],
	[Postal Code],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Supplier ID],
	[Supplier],
	[Category],
	[Primary Contact],
	[Supplier Reference],
	[Payment Days],
	[Postal Code],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Supplier ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Supplier]
END
    