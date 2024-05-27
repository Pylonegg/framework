       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_Employee]
AS

BEGIN
	IF OBJECT_ID('[enriched].[dim_Employee]') IS NOT NULL
		DROP TABLE [enriched].[dim_Employee]

	BEGIN
	CREATE TABLE [enriched].[dim_Employee]
		(
		[WWI Employee ID] int,
		[Employee] nvarchar(50),
		[Preferred Name] nvarchar(50),
		[Is Salesperson] bit
		);
	END

	INSERT INTO [enriched].[dim_Employee]
	SELECT 
		 p.PersonID         AS [WWI Employee ID]
		,p.FullName         AS [Employee]
		,p.PreferredName    AS [Preferred Name]
		,p.IsSalesperson    AS [Is Salesperson]
		--,convert(varbinary(max),p.Photo)            AS [Photo]
	FROM [wide_world_importers].[application].[People] p    
END
    