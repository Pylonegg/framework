USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimEmployee]
AS
SELECT  
    [EmployeeKey],
	[ParentEmployeeKey],
	[EmployeeNationalIDAlternateKey],
	[ParentEmployeeNationalIDAlternateKey],
	[SalesTerritoryKey],
	[FirstName],
	[LastName],
	[MiddleName],
	[NameStyle],
	[Title],
	[HireDate],
	[BirthDate],
	[LoginID],
	[EmailAddress],
	[Phone],
	[MaritalStatus],
	[EmergencyContactName],
	[EmergencyContactPhone],
	[SalariedFlag],
	[Gender],
	[PayFrequency],
	[BaseRate],
	[VacationHours],
	[SickLeaveHours],
	[CurrentFlag],
	[SalesPersonFlag],
	[DepartmentName],
	[StartDate],
	[EndDate],
	[Status],
	[EmployeePhoto]
FROM [curated].[DimEmployee]
