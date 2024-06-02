       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_fact_Order]
AS

BEGIN
IF OBJECT_ID('[enriched].[fact_Order]') IS NOT NULL
    DROP TABLE [enriched].[fact_Order]

BEGIN
CREATE TABLE [enriched].[fact_Order]
    (
    [City Key] int,
	[Customer Key] int,
	[Stock Item Key] int,
	[Order Date Key] date,
	[Picked Date Key] date,
	[Salesperson Key] int,
	[Picker Key] int,
	[WWI Order ID] int,
	[WWI Backorder ID] int,
	[Description] nvarchar(100),
	[Package] nvarchar(50),
	[Quantity] int,
	[Unit Price] decimal,
	[Tax Rate] decimal,
	[Total Excluding Tax] decimal,
	[Tax Amount] decimal,
	[Total Including Tax] decimal
    );
END

INSERT INTO [enriched].[fact_Order]
SELECT
    '' AS [City Key],
	'' AS [Customer Key],
	'' AS [Stock Item Key],
	'' AS [Order Date Key],
	'' AS [Picked Date Key],
	'' AS [Salesperson Key],
	'' AS [Picker Key],
	'' AS [WWI Order ID],
	'' AS [WWI Backorder ID],
	'' AS [Description],
	'' AS [Package],
	'' AS [Quantity],
	'' AS [Unit Price],
	'' AS [Tax Rate],
	'' AS [Total Excluding Tax],
	'' AS [Tax Amount],
	'' AS [Total Including Tax]

END
    