USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimAccount]
AS
SELECT  
    [AccountKey],
	[ParentAccountKey],
	[AccountCodeAlternateKey],
	[ParentAccountCodeAlternateKey],
	[AccountDescription],
	[AccountType],
	[Operator],
	[CustomMembers],
	[ValueType],
	[CustomMemberOptions]
FROM [curated].[DimAccount]
