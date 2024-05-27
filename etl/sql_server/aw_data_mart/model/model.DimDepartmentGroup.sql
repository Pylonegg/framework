USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimDepartmentGroup]
AS
SELECT  
    [DepartmentGroupKey],
	[ParentDepartmentGroupKey],
	[DepartmentGroupName]
FROM [curated].[DimDepartmentGroup]
