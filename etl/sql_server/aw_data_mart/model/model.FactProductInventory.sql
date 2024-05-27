USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[FactProductInventory]
AS
SELECT  
    [ProductKey],
	[DateKey],
	[MovementDate],
	[UnitCost],
	[UnitsIn],
	[UnitsOut],
	[UnitsBalance]
FROM [curated].[FactProductInventory]
