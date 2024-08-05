USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimAccount]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimAccount]
    (
    [ParentAccountKey] int NULL,
	[AccountCodeAlternateKey] int NULL,
	[ParentAccountCodeAlternateKey] int NULL,
	[AccountDescription] nvarchar(50) NULL,
	[AccountType] nvarchar(50) NULL,
	[Operator] nvarchar(50) NULL,
	[CustomMembers] nvarchar(300) NULL,
	[ValueType] nvarchar(50) NULL,
	[CustomMemberOptions] nvarchar(200) NULL
    );
END
