
CREATE TABLE [curated].[dim_Employee]
(
    [Employee Key] INT IDENTITY(1,1),
    [WWI Employee ID] int NOT NULL,
	[Employee] nvarchar(50) NOT NULL,
	[Preferred Name] nvarchar(50) NOT NULL,
	[Is Salesperson] bit NOT NULL,
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
