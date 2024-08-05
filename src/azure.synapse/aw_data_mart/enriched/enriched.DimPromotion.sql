USE [adventure_works]
GO

IF OBJECT_ID('[enriched].[DimPromotion]') IS NULL
BEGIN
CREATE TABLE [enriched].[DimPromotion]
    (
    [PromotionKey] int NOT NULL,
	[PromotionAlternateKey] int NULL,
	[EnglishPromotionName] nvarchar(255) NULL,
	[SpanishPromotionName] nvarchar(255) NULL,
	[FrenchPromotionName] nvarchar(255) NULL,
	[DiscountPct] float NULL,
	[EnglishPromotionType] nvarchar(50) NULL,
	[SpanishPromotionType] nvarchar(50) NULL,
	[FrenchPromotionType] nvarchar(50) NULL,
	[EnglishPromotionCategory] nvarchar(50) NULL,
	[SpanishPromotionCategory] nvarchar(50) NULL,
	[FrenchPromotionCategory] nvarchar(50) NULL,
	[StartDate] datetime NOT NULL,
	[EndDate] datetime NULL,
	[MinQty] int NULL,
	[MaxQty] int NULL
    );
END
