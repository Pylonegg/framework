       
CREATE PROCEDURE [enriched].[sp_dim_Employee]
AS

BEGIN
	TRUNCATE TABLE [enriched].[dim_Employee];

	INSERT INTO [enriched].[dim_Employee]
	SELECT 
		 p.PersonID         AS [WWI Employee ID]
		,p.FullName         AS [Employee]
		,p.PreferredName    AS [Preferred Name]
		,p.IsSalesperson    AS [Is Salesperson]
		--,convert(varbinary(max),p.Photo)            AS [Photo]
	FROM [stage].[WideWorldImporters_Application_People] p   
END
    