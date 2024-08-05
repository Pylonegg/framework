
CREATE TABLE [curated].[dim_TransactionType]
(
    [Transaction Type Key] INT IDENTITY(1,1),
    [WWI Transaction Type ID] int NOT NULL,
	[Transaction Type] nvarchar(50) NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
