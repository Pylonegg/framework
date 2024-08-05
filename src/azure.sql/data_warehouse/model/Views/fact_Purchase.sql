
CREATE VIEW [model].[fact_Purchase]
AS
SELECT
    [Purchase Key],
	[Date Key],
	[Supplier Key],
	[Stock Item Key],
	[WWI Purchase Order ID],
	[Ordered Outers],
	[Ordered Quantity],
	[Received Outers],
	[Package],
	[Is Order Finalized]
FROM [curated].[fact_Purchase]
