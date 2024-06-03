
CREATE TABLE [enriched].[dim_StockItem]
    (
    [WWI Stock Item ID] int,
	[Stock Item] nvarchar(100),
	[Color] nvarchar(20),
	[Selling Package] nvarchar(50),
	[Buying Package] nvarchar(50),
	[Brand] nvarchar(50),
	[Size] nvarchar(20),
	[Lead Time Days] int,
	[Quantity Per Outer] int,
	[Is Chiller Stock] bit,
	[Barcode] nvarchar(50),
	[Tax Rate] decimal,
	[Unit Price] decimal,
	[Recommended Retail Price] decimal,
	[Typical Weight Per Unit] decimal
    );
