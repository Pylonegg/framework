USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[FactProductInventory]') IS NULL
BEGIN
CREATE TABLE [enriched].[FactProductInventory]
    (
    [ProductKey] int NOT NULL,
	[DateKey] int NOT NULL,
	[MovementDate] date NOT NULL,
	[UnitCost] money NOT NULL,
	[UnitsIn] int NOT NULL,
	[UnitsOut] int NOT NULL,
	[UnitsBalance] int NOT NULL
    );
END
