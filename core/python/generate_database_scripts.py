from utility import create_file
# =======================================================================================
# 
# =======================================================================================

def database_sql(contract):
    prefix          = contract.prefix
    dataset_name    = contract.code
    object_name     = f"{prefix}_{dataset_name}"
    sql             = contract.format


# = STAGING TABLE =================================================================================
    staging_table = f"""
CREATE TABLE [stage].[{contract.collection_name}_{dataset_name}]
    (
    {sql.npk_type}
    );
"""
# = ENRICHED TABLE =================================================================================
    enriched_table = f"""
CREATE TABLE [enriched].[{object_name}]
    (
    {sql.npk_type}
    );
"""
# = ENRICHED PROCEDURE =============================================================================
    enriched_stored_procedure = f"""       
CREATE PROCEDURE [enriched].[sp_{object_name}]
AS

BEGIN
TRUNCATE TABLE [enriched].[{object_name}];

INSERT INTO [enriched].[{object_name}]
SELECT
    {sql.npk_blank}
END
    """

# = CURATED TABLE =================================================================================
    curated_table = f"""
CREATE TABLE [curated].[{object_name}]
(
    {sql.pk_simple} INT IDENTITY(1,1),
    {sql.npk_verbosed},
    [type1_scd_hash] varchar(256) NOT NULL,
    [natural_key_hash] varchar(256) NOT NULL
)"""

# = CURATED PROCEDURE ==============================================================================
    curated_stored_procedure = f"""
CREATE PROCEDURE [curated].[sp_{object_name}]
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
CREATE VIEW [model].[{object_name}]
AS
SELECT
    {sql.all_simple}
FROM [curated].[{object_name}]
    """


# == OUTPUT FILE ==============================================================================
    base_path = "transform/databases/data_warehouse/"

    if contract.collection_type == 'datasource':
        create_file(staging_table, f"{base_path}/stage/Tables/{contract.collection_name}_{dataset_name}.sql")
    else:
        create_file(enriched_table, f"{base_path}/enriched/Tables/{object_name}.sql")
        #create_file(enriched_stored_procedure, f"{base_path}/enriched/Stored Procedures/{object_name}.sql")
        create_file(curated_table, f"{base_path}/curated/Tables/{object_name}.sql")
        create_file(curated_stored_procedure, f"{base_path}/curated/Stored Procedures/{object_name}.sql")
        create_file(model, f"{base_path}/model/Views/{object_name}.sql")
    



# = SCHEMAS ====================================================================================
def schemas():
    target_path = "./transform/databases/data_warehouse/schema/"
    schemas = ["stage","enriched","curated","model","tests"]

    for schema in schemas:

        query = f"""
    CREATE SCHEMA [{schema}]
        AUTHORIZATION [dbo];
    """
        
        file_name = f"{target_path}{schema}.sql"
        create_file(query, file_name)