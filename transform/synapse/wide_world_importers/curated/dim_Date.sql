
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_Date]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_Date]
(
    [Date Key] INT IDENTITY(1,1),
    [Date] date NOT NULL,
	[Day Number] int NOT NULL,
	[Day] nvarchar(10) NOT NULL,
	[Month] nvarchar(10) NOT NULL,
	[Short Month] nvarchar(3) NOT NULL,
	[Calendar Month Number] int NOT NULL,
	[Calendar Month Label] nvarchar(20) NOT NULL,
	[Calendar Year] int NOT NULL,
	[Calendar Year Label] nvarchar(10) NOT NULL,
	[Fiscal Month Number] int NOT NULL,
	[Fiscal Month Label] nvarchar(20) NOT NULL,
	[Fiscal Year] int NOT NULL,
	[Fiscal Year Label] nvarchar(10) NOT NULL,
	[ISO Week Number] int NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_Date]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_Date];

INSERT INTO [curated].[dim_Date](
    [Date],
	[Day Number],
	[Day],
	[Month],
	[Short Month],
	[Calendar Month Number],
	[Calendar Month Label],
	[Calendar Year],
	[Calendar Year Label],
	[Fiscal Month Number],
	[Fiscal Month Label],
	[Fiscal Year],
	[Fiscal Year Label],
	[ISO Week Number],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [Date],
	[Day Number],
	[Day],
	[Month],
	[Short Month],
	[Calendar Month Number],
	[Calendar Month Label],
	[Calendar Year],
	[Calendar Year Label],
	[Fiscal Month Number],
	[Fiscal Month Label],
	[Fiscal Year],
	[Fiscal Year Label],
	[ISO Week Number],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([Day Number],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_Date]
END
    