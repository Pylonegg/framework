
CREATE TABLE [curated].[dim_StockItem]
(
    [Stock Item Key] INT IDENTITY(1,1),
    [WWI Stock Item ID] int NOT NULL,
	[Stock Item] nvarchar(100) NOT NULL,
	[Color] nvarchar(20) NULL,
	[Selling Package] nvarchar(50) NOT NULL,
	[Buying Package] nvarchar(50) NOT NULL,
	[Brand] nvarchar(50) NULL,
	[Size] nvarchar(20) NULL,
	[Lead Time Days] int NOT NULL,
	[Quantity Per Outer] int NOT NULL,
	[Is Chiller Stock] bit NOT NULL,
	[Barcode] nvarchar(50) NULL,
	[Tax Rate] decimal NOT NULL,
	[Unit Price] decimal NOT NULL,
	[Recommended Retail Price] decimal NOT NULL,
	[Typical Weight Per Unit] decimal NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
