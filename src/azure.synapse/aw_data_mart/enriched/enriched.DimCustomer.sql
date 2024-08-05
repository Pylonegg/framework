USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimCustomer]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimCustomer]
    (
    [GeographyKey] int NULL,
	[CustomerAlternateKey] nvarchar(15) NOT NULL,
	[Title] nvarchar(8) NULL,
	[FirstName] nvarchar(50) NULL,
	[MiddleName] nvarchar(50) NULL,
	[LastName] nvarchar(50) NULL,
	[NameStyle] bit NULL,
	[BirthDate] date NULL,
	[MaritalStatus] nchar(1) NULL,
	[Suffix] nvarchar(10) NULL,
	[Gender] nvarchar(1) NULL,
	[EmailAddress] nvarchar(50) NULL,
	[YearlyIncome] money NULL,
	[TotalChildren] tinyint NULL,
	[NumberChildrenAtHome] tinyint NULL,
	[EnglishEducation] nvarchar(40) NULL,
	[SpanishEducation] nvarchar(40) NULL,
	[FrenchEducation] nvarchar(40) NULL,
	[EnglishOccupation] nvarchar(100) NULL,
	[SpanishOccupation] nvarchar(100) NULL,
	[FrenchOccupation] nvarchar(100) NULL,
	[HouseOwnerFlag] nchar(1) NULL,
	[NumberCarsOwned] tinyint NULL,
	[AddressLine1] nvarchar(120) NULL,
	[AddressLine2] nvarchar(120) NULL,
	[Phone] nvarchar(20) NULL,
	[DateFirstPurchase] date NULL,
	[CommuteDistance] nvarchar(15) NULL
    );
END
