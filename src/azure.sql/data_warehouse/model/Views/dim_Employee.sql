
CREATE VIEW [model].[dim_Employee]
AS
SELECT
    [Employee Key],
	[WWI Employee ID],
	[Employee],
	[Preferred Name],
	[Is Salesperson]
FROM [curated].[dim_Employee]
