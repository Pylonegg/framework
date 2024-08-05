
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_City]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_City]
(
    [City Key] INT IDENTITY(1,1),
    [WWI City ID] int NOT NULL,
	[City] nvarchar(50) NOT NULL,
	[State Province] nvarchar(50) NOT NULL,
	[Country] nvarchar(60) NOT NULL,
	[Continent] nvarchar(30) NOT NULL,
	[Sales Territory] nvarchar(50) NOT NULL,
	[Region] nvarchar(30) NOT NULL,
	[Subregion] nvarchar(30) NOT NULL,
	[Location] nvarchar(max) NOT NULL,
	[Latest Recorded Population] bigint NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_City]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_City];

INSERT INTO [curated].[dim_City](
    [WWI City ID],
	[City],
	[State Province],
	[Country],
	[Continent],
	[Sales Territory],
	[Region],
	[Subregion],
	[Location],
	[Latest Recorded Population],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI City ID],
	[City],
	[State Province],
	[Country],
	[Continent],
	[Sales Territory],
	[Region],
	[Subregion],
	[Location],
	[Latest Recorded Population],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI City ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_City]
END
    