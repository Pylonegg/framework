USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimEmployee]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimEmployee]
    (
    [EmployeeKey] int NOT NULL,
	[ParentEmployeeKey] int NULL,
	[EmployeeNationalIDAlternateKey] nvarchar(15) NULL,
	[ParentEmployeeNationalIDAlternateKey] nvarchar(15) NULL,
	[SalesTerritoryKey] int NULL,
	[FirstName] nvarchar(50) NOT NULL,
	[LastName] nvarchar(50) NOT NULL,
	[MiddleName] nvarchar(50) NULL,
	[NameStyle] bit NOT NULL,
	[Title] nvarchar(50) NULL,
	[HireDate] date NULL,
	[BirthDate] date NULL,
	[LoginID] nvarchar(256) NULL,
	[EmailAddress] nvarchar(50) NULL,
	[Phone] nvarchar(25) NULL,
	[MaritalStatus] nchar(1) NULL,
	[EmergencyContactName] nvarchar(50) NULL,
	[EmergencyContactPhone] nvarchar(25) NULL,
	[SalariedFlag] bit NULL,
	[Gender] nchar(1) NULL,
	[PayFrequency] tinyint NULL,
	[BaseRate] money NULL,
	[VacationHours] smallint NULL,
	[SickLeaveHours] smallint NULL,
	[CurrentFlag] bit NOT NULL,
	[SalesPersonFlag] bit NOT NULL,
	[DepartmentName] nvarchar(50) NULL,
	[StartDate] date NULL,
	[EndDate] date NULL,
	[Status] nvarchar(50) NULL,
	[EmployeePhoto] varbinary(max) NULL
    );
END
