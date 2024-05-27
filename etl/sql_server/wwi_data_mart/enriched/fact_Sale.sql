       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_Sale]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_Sale]') IS NOT NULL
    DROP TABLE [enriched].[fact_Sale]

BEGIN
CREATE TABLE [enriched].[fact_Sale]
    (
    [City Key] int,
	[Customer Key] int,
	[Bill To Customer Key] int,
	[Stock Item Key] int,
	[Invoice Date Key] date,
	[Delivery Date Key] date,
	[Salesperson Key] int,
	[WWI Invoice ID] int,
	[Description] nvarchar(100),
	[Package] nvarchar(50),
	[Quantity] int,
	[Unit Price] decimal,
	[Tax Rate] decimal,
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Profit] decimal,
	[Total Including Tax] decimal,
	[Total Dry Items] int,
	[Total Chiller Items] int
    );
END

INSERT INTO [enriched].[fact_Sale]
SELECT
    '' AS [City Key],
	'' AS [Customer Key],
	'' AS [Bill To Customer Key],
	'' AS [Stock Item Key],
	'' AS [Invoice Date Key],
	'' AS [Delivery Date Key],
	'' AS [Salesperson Key],
	'' AS [WWI Invoice ID],
	'' AS [Description],
	'' AS [Package],
	'' AS [Quantity],
	'' AS [Unit Price],
	'' AS [Tax Rate],
	'' AS [Total Excluding Tax],
	'' AS [Tax Amount],
	'' AS [Profit],
	'' AS [Total Including Tax],
	'' AS [Total Dry Items],
	'' AS [Total Chiller Items]

END
    