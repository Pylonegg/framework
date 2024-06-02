       
CREATE PROCEDURE [enriched].[sp_dim_StockItem]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_StockItem];

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
    