       
CREATE PROCEDURE [enriched].[sp_dim_City]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_City];

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
FROM [stage].[WideWorldImporters_Application_Cities] cc
INNER JOIN [stage].[WideWorldImporters_Application_StateProvinces] sp
	ON cc.StateProvinceID = sp.StateProvinceID
INNER JOIN [stage].[WideWorldImporters_Application_Countries] co
	ON sp.CountryID = co.CountryID
END
    