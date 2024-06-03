USE [adventure_works]
GO

IF OBJECT_ID('[curated].[DimEmployee]') IS NULL
BEGIN
CREATE TABLE [curated].[DimEmployee]
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
	[EmployeePhoto] varbinary(max) NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE curated.curate_DimEmployee
AS
BEGIN  
    SET NOCOUNT ON;
MERGE [curated].[DimEmployee] AS T  
USING (
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
	[EmployeePhoto],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    ,''))),2) AS [natural_key_hash]
    ,CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2) AS [type1_scd_hash]
FROM [enriched].[DimEmployee]) S
ON (S.natural_key_hash = T.natural_key_hash)

WHEN MATCHED AND (S.type1_scd_hash <> T.type1_scd_hash)
THEN
UPDATE SET
    
    T.[type1_scd_hash] = CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT(
    '',''))),2)
     
WHEN NOT MATCHED THEN  
INSERT (
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
	[EmployeePhoto],
    [natural_key_hash],
    [type1_scd_hash]
    )
VALUES (
    S.[EmployeeKey],
	S.[ParentEmployeeKey],
	S.[EmployeeNationalIDAlternateKey],
	S.[ParentEmployeeNationalIDAlternateKey],
	S.[SalesTerritoryKey],
	S.[FirstName],
	S.[LastName],
	S.[MiddleName],
	S.[NameStyle],
	S.[Title],
	S.[HireDate],
	S.[BirthDate],
	S.[LoginID],
	S.[EmailAddress],
	S.[Phone],
	S.[MaritalStatus],
	S.[EmergencyContactName],
	S.[EmergencyContactPhone],
	S.[SalariedFlag],
	S.[Gender],
	S.[PayFrequency],
	S.[BaseRate],
	S.[VacationHours],
	S.[SickLeaveHours],
	S.[CurrentFlag],
	S.[SalesPersonFlag],
	S.[DepartmentName],
	S.[StartDate],
	S.[EndDate],
	S.[Status],
	S.[EmployeePhoto],
    S.[natural_key_hash],
    S.[type1_scd_hash]
    );


DECLARE @max_surrogate_key int
SET @max_surrogate_key = COALESCE((SELECT MAX() FROM [curated].[DimEmployee]),0)

UPDATE A
SET A. = COALESCE(A., B.new_)
FROM [curated].[DimEmployee] A
LEFT JOIN  (SELECT @max_surrogate_key + ROW_NUMBER() OVER (ORDER BY ) new_, natural_key_hash FROM [curated].[DimEmployee]) B
ON  A.natural_key_hash = B.natural_key_hash 
END
GO

EXEC curated.curate_DimEmployee
