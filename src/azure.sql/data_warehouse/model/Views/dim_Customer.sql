
CREATE VIEW [model].[dim_Customer]
AS
SELECT
    [Customer Key],
	[WWI Customer ID],
	[Customer],
	[Bill To Customer],
	[Category],
	[Buying Group],
	[Primary Contact],
	[Postal Code]
FROM [curated].[dim_Customer]
