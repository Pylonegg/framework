USE [adventure_works]
GO

CREATE OR ALTER VIEW [model].[DimPromotion]
AS
SELECT  
    [PromotionKey],
	[PromotionAlternateKey],
	[EnglishPromotionName],
	[SpanishPromotionName],
	[FrenchPromotionName],
	[DiscountPct],
	[EnglishPromotionType],
	[SpanishPromotionType],
	[FrenchPromotionType],
	[EnglishPromotionCategory],
	[SpanishPromotionCategory],
	[FrenchPromotionCategory],
	[StartDate],
	[EndDate],
	[MinQty],
	[MaxQty]
FROM [curated].[DimPromotion]
