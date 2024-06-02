       
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
FROM [wide_world_importers].[application].[Cities] cc
INNER JOIN [wide_world_importers].[application].[StateProvinces] sp
	ON cc.StateProvinceID = sp.StateProvinceID
INNER JOIN [wide_world_importers].[application].[Countries] co
	ON sp.CountryID = co.CountryID
END
    