       
CREATE PROCEDURE [enriched].[sp_dim_Date]
AS

BEGIN
TRUNCATE TABLE [enriched].[dim_Date];

INSERT INTO [enriched].[dim_Date]
SELECT
    '' AS [Date],
	'' AS [Day Number],
	'' AS [Day],
	'' AS [Month],
	'' AS [Short Month],
	'' AS [Calendar Month Number],
	'' AS [Calendar Month Label],
	'' AS [Calendar Year],
	'' AS [Calendar Year Label],
	'' AS [Fiscal Month Number],
	'' AS [Fiscal Month Label],
	'' AS [Fiscal Year],
	'' AS [Fiscal Year Label],
	'' AS [ISO Week Number]
END
    