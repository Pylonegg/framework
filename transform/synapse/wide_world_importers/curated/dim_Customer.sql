
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_Customer]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_Customer]
(
    [Customer Key] INT IDENTITY(1,1),
    [WWI Customer ID] int NOT NULL,
	[Customer] nvarchar(100) NOT NULL,
	[Bill To Customer] nvarchar(100) NOT NULL,
	[Category] nvarchar(50) NOT NULL,
	[Buying Group] nvarchar(50) NOT NULL,
	[Primary Contact] nvarchar(50) NOT NULL,
	[Postal Code] nvarchar(10) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_Customer]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Customer];

INSERT INTO [curated].[dim_Customer](
    [WWI Customer ID],
	[Customer],
	[Bill To Customer],
	[Category],
	[Buying Group],
	[Primary Contact],
	[Postal Code],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Customer ID],
	[Customer],
	[Bill To Customer],
	[Category],
	[Buying Group],
	[Primary Contact],
	[Postal Code],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Customer ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Customer]
END
    