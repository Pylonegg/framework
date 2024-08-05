
CREATE PROCEDURE [curated].[sp_dim_City]
AS
BEGIN
IF OBJECT_ID('[curated].[temp_dim_City]') IS NOT NULL
    DROP TABLE [curated].[temp_dim_City]
CREATE TABLE [curated].[temp_dim_City]
(
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
)

IF OBJECT_ID('[curated].[new_dim_City]') IS NOT NULL
    DROP TABLE [curated].[new_dim_City]
CREATE TABLE [curated].[new_dim_City]
(
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
)

-- Copy from enriched into curated.temp_
INSERT INTO [curated].[temp_dim_City](
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


INSERT INTO [curated].[new_dim_City]
SELECT -- New Rows
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
FROM [curated].[temp_dim_City]
WHERE [natural_key_hash] NOT IN (SELECT [natural_key_hash] FROM [curated].[dim_City])

UNION ALL

SELECT -- Changed Rows
    S.[WWI City ID],
	S.[City],
	S.[State Province],
	S.[Country],
	S.[Continent],
	S.[Sales Territory],
	S.[Region],
	S.[Subregion],
	S.[Location],
	S.[Latest Recorded Population],
    S.[natural_key_hash],
    S.[type1_scd_hash]
FROM [curated].[temp_dim_City] S
INNER JOIN [curated].[dim_City] T
    ON S.[natural_key_hash] = T.[natural_key_hash]
WHERE S.[type1_scd_hash] <> T.[type1_scd_hash]

UNION ALL

SELECT -- Unchanged
    S.[WWI City ID],
	S.[City],
	S.[State Province],
	S.[Country],
	S.[Continent],
	S.[Sales Territory],
	S.[Region],
	S.[Subregion],
	S.[Location],
	S.[Latest Recorded Population],
    S.[natural_key_hash],
    S.[type1_scd_hash]
FROM [curated].[dim_City] S
LEFT JOIN [curated].[temp_dim_City] T
    ON S.[natural_key_hash] = T.[natural_key_hash]
WHERE S.[type1_scd_hash] = T.[type1_scd_hash]
    AND S.[natural_key_hash] = T.[natural_key_hash]


IF OBJECT_ID('[curated].[old_dim_City]') IS NOT NULL
    DROP TABLE [curated].[old_dim_City]
EXEC sp_rename  'curated.dim_City', 'old_dim_City'
EXEC sp_rename  'curated.new_dim_City', 'dim_City'

END
