# Staging Table ---------------------------------
template_staging_table = """
CREATE TABLE [stage].[{collection}_{dataset}]
(
  {columns}
);
"""


# Enriched Table ---------------------------------
template_enriched_table = """
CREATE TABLE [enriched].[{name}] 
(
    {columns}
);
"""


# Enriched Procedure ---------------------------------
template_enriched_stored_procedure = """       
CREATE PROCEDURE [enriched].[sp_{name}]
AS

BEGIN
TRUNCATE TABLE [enriched].[{name}];

INSERT INTO [enriched].[{name}]
SELECT
    {columns}
END
"""


# Curated Table ----------------------------------
curated_table_database_table = """
CREATE TABLE [curated].[{name}]
(
    {primary_key} INT IDENTITY(1,1),
    {columns},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)
"""


# Curated Default Procedure ----------------------------------
curated_table_database_default_proc = """
CREATE PROCEDURE [curated].[sp_{name}]
AS
BEGIN

TRUNCATE TABLE [curated].[{name}];

INSERT INTO [curated].[{name}](
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    {columns},
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({natural_key_hash}'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({type1_scd_hash}'',''))),2) AS [type1_scd_hash]
FROM [enriched].[{name}]
END
"""

# Curated Incremental Procedure ----------------------------------
curated_table_database_incremental_proc = """
CREATE PROCEDURE [curated].[sp_{name}]
AS
BEGIN
IF OBJECT_ID('[curated].[temp_{name}]') IS NOT NULL
    DROP TABLE [curated].[temp_{name}]
CREATE TABLE [curated].[temp_{name}]
(
    {create_columns},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)

IF OBJECT_ID('[curated].[new_{name}]') IS NOT NULL
    DROP TABLE [curated].[new_{name}]
CREATE TABLE [curated].[new_{name}]
(
    {create_columns},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)

-- Copy from enriched into curated.temp_
INSERT INTO [curated].[temp_{name}](
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    {columns},
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({natural_key_hash}'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({type1_scd_hash}'',''))),2) AS [type1_scd_hash]
FROM [enriched].[{name}]


INSERT INTO [curated].[new_{name}]
SELECT -- New Rows
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
FROM [curated].[temp_{name}]
WHERE [natural_key_hash] NOT IN (SELECT [natural_key_hash] FROM [curated].[{name}])

UNION ALL

SELECT -- Changed Rows
    {source_columns},
    S.[natural_key_hash],
    S.[type1_scd_hash]
FROM [curated].[temp_{name}] S
INNER JOIN [curated].[{name}] T
    ON S.[natural_key_hash] = T.[natural_key_hash]
WHERE S.[type1_scd_hash] <> T.[type1_scd_hash]

UNION ALL

SELECT -- Unchanged
    {source_columns},
    S.[natural_key_hash],
    S.[type1_scd_hash]
FROM [curated].[{name}] S
LEFT JOIN [curated].[temp_{name}] T
    ON S.[natural_key_hash] = T.[natural_key_hash]
WHERE S.[type1_scd_hash] = T.[type1_scd_hash]
    AND S.[natural_key_hash] = T.[natural_key_hash]


IF OBJECT_ID('[curated].[old_{name}]') IS NOT NULL
    DROP TABLE [curated].[old_{name}]
EXEC sp_rename  'curated.{name}', 'old_{name}'
EXEC sp_rename  'curated.new_{name}', '{name}'

END
"""

# Curated Snapshot Procedure ----------------------------------
curated_table_database_snapshot_proc = """
CREATE PROCEDURE [curated].[sp_{name}]
AS
BEGIN
IF OBJECT_ID('[curated].[temp_{name}]') IS NOT NULL
    DROP TABLE [curated].[temp_{name}]
CREATE TABLE [curated].[temp_{name}]
(
    {create_columns},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)

IF OBJECT_ID('[curated].[new_{name}]') IS NOT NULL
    DROP TABLE [curated].[new_{name}]
CREATE TABLE [curated].[new_{name}]
(
    {create_columns},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)

-- Copy from enriched into curated.temp_
INSERT INTO [curated].[temp_{name}](
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    {columns},
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({natural_key_hash}'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({type1_scd_hash}'',''))),2) AS [type1_scd_hash]
FROM [enriched].[{name}]


INSERT INTO [curated].[new_{name}]

SELECT -- New Snapshot Rows
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
FROM [curated].[temp_{name}]

UNION ALL

SELECT -- Existing Snapshot Rows
    {columns},
    [natural_key_hash],
    [type1_scd_hash]
FROM [curated].[temp_{name}]
-- add snapshot date key to logic WHERE [snapshot_key] NOT IN (SELECT [snapshot_key] FROM [curated].[temp_{name}])


IF OBJECT_ID('[curated].[old_{name}]') IS NOT NULL
    DROP TABLE [curated].[old_{name}]
EXEC sp_rename  'curated.{name}', 'old_{name}'
EXEC sp_rename  'curated.new_{name}', '{name}'

END
"""


# Model view ---------------------------------------
model_database = """
CREATE VIEW [model].[{name}]
AS
SELECT
    {columns}
FROM [curated].[{name}]
"""





# ----------------------------------------------------------------------------------
# Synapse --------------------------------------------------------------------------
# ----------------------------------------------------------------------------------
enriched = """       
USE [{collection_name}]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_{name}]
AS

BEGIN
IF OBJECT_ID('[enriched].[{name}]') IS NOT NULL
    DROP TABLE [enriched].[{name}]

BEGIN
CREATE TABLE [enriched].[{name}]
    (
    {sql.npk_type}
    );
END

INSERT INTO [enriched].[{name}]
SELECT
    {sql.npk_blank}

END
"""

model_synapse = """
USE [{collection_name}]
GO

CREATE OR ALTER VIEW [model].[{name}]
AS
SELECT
    {columns}
FROM [curated].[{name}]
"""