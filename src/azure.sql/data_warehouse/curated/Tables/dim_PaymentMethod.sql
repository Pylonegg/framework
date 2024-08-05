
CREATE TABLE [curated].[dim_PaymentMethod]
(
    [Payment Method Key] INT IDENTITY(1,1),
    [WWI Payment Method ID] int NOT NULL,
	[Payment Method] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
