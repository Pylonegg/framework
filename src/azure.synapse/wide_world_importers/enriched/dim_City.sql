       
USE [wwi_data_mart]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_dim_City]
AS

BEGIN
	IF OBJECT_ID('[enriched].[dim_City]') IS NOT NULL
		DROP TABLE [enriched].[dim_City]

	BEGIN
	CREATE TABLE [enriched].[dim_City]
		(
		[WWI City ID] int,
		[City] nvarchar(50),
		[State Province] nvarchar(50),
		[Country] nvarchar(60),
		[Continent] nvarchar(30),
		[Sales Territory] nvarchar(50),
		[Region] nvarchar(30),
		[Subregion] nvarchar(30),
		[Location] nvarchar(max),
		[Latest Recorded Population] bigint
		);
	END

	INSERT INTO [enriched].[dim_City]  
	SELECT
		 cc.[CityID]                     			AS [WWI City ID]
		,cc.[CityName]                  			AS [City]
		,sp.[StateProvinceName]         			AS [State Province]
		,co.[CountryName]               			AS [Country]
		,co.[Continent]                 			AS [Continent]
		,sp.[SalesTerritory]            			AS [Sales Territory]
		,co.[Region]                    			AS [Region]
		,co.[Subregion]                 			AS [Subregion]
		,CONVERT(nvarchar(50),cc.[Location])        AS [Location]
		,COALESCE(cc.[LatestRecordedPopulation],0)  AS [Latest Recorded Population]
	FROM [wide_world_importers].[application].[Cities] cc
	INNER JOIN [wide_world_importers].[application].[StateProvinces] sp
		ON cc.StateProvinceID = sp.StateProvinceID
	INNER JOIN [wide_world_importers].[application].[Countries] co
		ON sp.CountryID = co.CountryID

END
    