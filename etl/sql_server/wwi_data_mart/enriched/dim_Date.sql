       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_Date]
AS

BEGIN
IF OBJECT_ID('[enriched].[dim_Date]') IS NOT NULL
    DROP TABLE [enriched].[dim_Date]

BEGIN
CREATE TABLE [enriched].[dim_Date]
    (
    [Date] date,
	[Day Number] int,
	[Day] nvarchar(10),
	[Month] nvarchar(10),
	[Short Month] nvarchar(3),
	[Calendar Month Number] int,
	[Calendar Month Label] nvarchar(20),
	[Calendar Year] int,
	[Calendar Year Label] nvarchar(10),
	[Fiscal Month Number] int,
	[Fiscal Month Label] nvarchar(20),
	[Fiscal Year] int,
	[Fiscal Year Label] nvarchar(10),
	[ISO Week Number] int
    );
END

INSERT INTO [enriched].[dim_Date]
SELECT
    '' AS [Date],
	'' AS [Day Number],
	'' AS [Day],
	'' AS [Month],
	'' AS [Short Month],
	'' AS [Calendar Month Number],
	'' AS [Calendar Month Label],
	'' AS [Calendar Year],
	'' AS [Calendar Year Label],
	'' AS [Fiscal Month Number],
	'' AS [Fiscal Month Label],
	'' AS [Fiscal Year],
	'' AS [Fiscal Year Label],
	'' AS [ISO Week Number]

END
    