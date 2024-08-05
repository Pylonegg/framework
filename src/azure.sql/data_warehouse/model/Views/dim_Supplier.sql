
CREATE VIEW [model].[dim_Supplier]
AS
SELECT
    [Supplier Key],
	[WWI Supplier ID],
	[Supplier],
	[Category],
	[Primary Contact],
	[Supplier Reference],
	[Payment Days],
	[Postal Code]
FROM [curated].[dim_Supplier]
