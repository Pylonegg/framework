
USE [wide_world_importers]
GO

IF OBJECT_ID('[curated].[dim_PaymentMethod]') IS NULL
BEGIN
CREATE TABLE [curated].[dim_PaymentMethod]
(
    [Payment Method Key] INT IDENTITY(1,1),
    [WWI Payment Method ID] int NOT NULL,
	[Payment Method] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_dim_PaymentMethod]
AS
BEGIN

TRUNCATE TABLE [curated].[dim_PaymentMethod];

INSERT INTO [curated].[dim_PaymentMethod](
    [WWI Payment Method ID],
	[Payment Method],
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    [WWI Payment Method ID],
	[Payment Method],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT([WWI Payment Method ID],'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT('',''))),2) AS [type1_scd_hash]
FROM [enriched].[dim_PaymentMethod]
END
    