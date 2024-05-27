       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_StockItem]
AS

BEGIN
IF OBJECT_ID('[enriched].[dim_StockItem]') IS NOT NULL
    DROP TABLE [enriched].[dim_StockItem]

BEGIN
CREATE TABLE [enriched].[dim_StockItem]
    (
    [WWI Stock Item ID] int,
	[Stock Item] nvarchar(100),
	[Color] nvarchar(20),
	[Selling Package] nvarchar(50),
	[Buying Package] nvarchar(50),
	[Brand] nvarchar(50),
	[Size] nvarchar(20),
	[Lead Time Days] int,
	[Quantity Per Outer] int,
	[Is Chiller Stock] bit,
	[Barcode] nvarchar(50),
	[Tax Rate] decimal,
	[Unit Price] decimal,
	[Recommended Retail Price] decimal,
	[Typical Weight Per Unit] decimal
    );
END

INSERT INTO [enriched].[dim_StockItem]
SELECT 
     si.StockItemID                AS  [WWI Stock Item ID]
    ,si.StockItemName              AS  [Stock Item]
    ,c.ColorName                   AS  [Color]
    ,spt.PackageTypeName           AS  [Selling Package]
    ,bpt.PackageTypeName           AS  [Buying Package]
    ,si.Brand                      AS  [Brand]
    ,si.Size                       AS  [Size]
    ,si.LeadTimeDays               AS  [Lead Time Days]
    ,si.QuantityPerOuter           AS  [Quantity Per Outer]
    ,si.IsChillerStock             AS  [Is Chiller Stock]
    ,si.Barcode                    AS  [Barcode]
	,si.TaxRate					   AS  [Tax Rate]
    ,si.UnitPrice                  AS  [Unit Price]
    ,si.RecommendedRetailPrice     AS  [Recommended Retail Price]
    ,si.TypicalWeightPerUnit       AS  [Typical Weight Per Unit]
FROM [wide_world_importers].[warehouse].[StockItems] si
INNER JOIN [wide_world_importers].[warehouse].[PackageTypes] spt
    ON si.UnitPackageID = spt.PackageTypeID
INNER JOIN [wide_world_importers].[warehouse].[PackageTypes] bpt
    ON si.OuterPackageID = bpt.PackageTypeID
LEFT OUTER JOIN [wide_world_importers].[warehouse].[Colors] c
        ON si.ColorID = c.ColorID    

END
    