from utility import create_file
# =======================================================================================
# 
# =======================================================================================

def synapse_sql(contract):
    prefix          = contract.prefix
    collection_type = contract.collection_type
    dataset_name    = contract.code
    object_name     = f"{prefix}_{dataset_name}"
    collection_name = contract.collection_name
    sql             = contract.format



# = ENRICHED =================================================================================
    enriched = f"""       
USE [{collection_name}]
GO

CREATE OR ALTER PROCEDURE [enriched].[sp_{object_name}]
AS

BEGIN
IF OBJECT_ID('[enriched].[{object_name}]') IS NOT NULL
    DROP TABLE [enriched].[{object_name}]

BEGIN
CREATE TABLE [enriched].[{object_name}]
    (
    {sql.npk_type}
    );
END

INSERT INTO [enriched].[{object_name}]
SELECT
    {sql.npk_blank}

END
    """

# = CURATED =================================================================================
    curated = f"""
USE [{collection_name}]
GO

IF OBJECT_ID('[curated].[{object_name}]') IS NULL
BEGIN
CREATE TABLE [curated].[{object_name}]
(
    {sql.pk_simple} INT IDENTITY(1,1),
    {sql.npk_verbosed},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
);
END
GO

CREATE OR ALTER PROCEDURE [curated].[sp_{object_name}]
AS
BEGIN

TRUNCATE TABLE [curated].[{object_name}];

INSERT INTO [curated].[{object_name}](
    {sql.npk_simple},
    [natural_key_hash],
    [type1_scd_hash]
    )
SELECT
    {sql.npk_simple},
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({'' if sql.nk_simple == '' else sql.nk_simple + ','}'',''))),2) AS [natural_key_hash],
    CONVERT(VARCHAR(256),HASHBYTES('SHA2_256',UPPER(CONCAT({'' if sql.scd1_simple == '' else sql.scd1_simple + ','}'',''))),2) AS [type1_scd_hash]
FROM [enriched].[{object_name}]
END
    """


# = MODEL ====================================================================================
    model = f"""
USE [{collection_name}]
GO

CREATE OR ALTER VIEW [model].[{object_name}]
AS
SELECT
    {sql.all_simple}
FROM [curated].[{object_name}]
    """

    # == OUTPUT FILE ==============================================================================
    # NOTE Uncommenting enriched in it's current state will erase logic
    if collection_type != 'datasource':
        base_path = f'transform/synapse/{collection_name}'
        # create_file(enriched, f"{base_path}/{collection_name}/enriched/{object_name}.sql")
        create_file(curated, f"{base_path}/curated/{object_name}.sql")
        create_file(model, f"{base_path}/model/{object_name}.sql")
