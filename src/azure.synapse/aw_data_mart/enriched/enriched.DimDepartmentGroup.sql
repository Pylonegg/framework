USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimDepartmentGroup]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimDepartmentGroup]
    (
    [DepartmentGroupKey] int NOT NULL,
	[ParentDepartmentGroupKey] int NULL,
	[DepartmentGroupName] nvarchar(50) NULL
    );
END
