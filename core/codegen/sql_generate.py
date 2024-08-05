from utility import create_file
from sql_templates import *


# SQL formating helpers ---------------------------------------------------------
seperator = ",\n\t"
def blank(cols):
    return seperator.join([f"'' AS [{col_name}]" for col_name in cols])

def simple(cols):
    return seperator.join([f"[{col_name}]" for col_name in cols])
        
def quoted(cols):
    return seperator.join([f"'{col_name}'" for col_name in cols])

def source_target(cols):
    return seperator.join([f"T.[{col_name}] = S.[{col_name}]" for col_name in cols])

def source(cols):
    return seperator.join([f"S.[{col_name}]" for col_name in cols])

def data_type(column_list, columns_data):
    output = []
    for column in columns_data:
        if column.name in column_list:
            _length         = "max" if column.length == -1 else column.length
            length          = "" if _length is None else f"({_length})"  
            output.append(f"[{column.name}] {column.data_type}{length}")
    return seperator.join(output)

def verbosed(column_list, columns_data): 
    output = [] # [Employee Key] int NOT NULL
    for column in columns_data:
        if column.name in column_list:
            _length         = "max" if column.length == -1 else column.length
            length          = "" if _length is None else f"({_length})"
            nullable        = "NULL" if column.nullable else "NOT NULL"
            output.append(f"[{column.name}] {column.data_type}{length} {nullable}")
    return seperator.join(output)
    


# Curation stages --------------------------------------------------------
def schemas():
    target_path = "./src/azure.sql/data_warehouse/schema/"
    schemas = ["stage","enriched","curated","model","tests"]

    for schema in schemas:
        query = f"""
    CREATE SCHEMA [{schema}]
        AUTHORIZATION [dbo];
    """
        
        file_name = f"{target_path}{schema}.sql"
        create_file(query, file_name)

def stage(contract):
    #create_file(staging_table, f"{base_path}/stage/Tables/{contract.collection_name}_{contract.code}.sql")
    pass


def enriched(contract):
    name  = f"{contract.prefix}_{contract.code}"
    blank_non_primary_keys  = blank(contract.non_primary_keys)
    simple_non_primary_keys = simple(contract.non_primary_keys)
    verbosed_non_primary_keys   = verbosed(contract.non_primary_keys, contract.columns)

    if contract.collection_system == "synapse":
        path_proc       = ""
        path_table      = ""

        enriched_table  = template_enriched_table.format(
            name=name, 
            columns=simple_non_primary_keys
            )

        enriched_proc   = template_enriched_stored_procedure.format(
            name=name,
            columns=blank_non_primary_keys
            )

    
    elif contract.collection_system == "database":
        path_table      = f"src/azure.sql/data_warehouse/enriched/Tables/{name}.sql"
        path_proc       = f"src/azure.sql/data_warehouse/enriched/Stored Procedures/{name}.sql"

        enriched_table  = template_enriched_table.format( 
            name=name,
            columns=verbosed_non_primary_keys
            )

        enriched_proc   = template_enriched_stored_procedure.format( 
            name=name,
            columns=blank_non_primary_keys
            )
    
    
    #create_file(enriched_proc, f"{base_path}/enriched/Stored Procedures/{name}.sql")

    create_file(enriched_table, path_table, overwrite=True)
    create_file(enriched_proc, path_proc, overwrite=False)



def curated(contract):
    name                        = f"{contract.prefix}_{contract.code}"
    simple_non_primary_keys     = simple(contract.non_primary_keys)
    simple_primary_keys         = simple(contract.primary_keys)
    simple_natural_keys         = simple(contract.natural_keys)
    source_non_primary_keys     = source(contract.non_primary_keys)

    verbosed_non_primary_keys   = verbosed(contract.non_primary_keys, contract.columns)
    type1_scd_keys              = simple(contract.scd1)
    natural_key_hash            = '' if simple_natural_keys == '' else simple_natural_keys + ','
    type1_scd_hash              = '' if type1_scd_keys == '' else type1_scd_keys + ','

    if contract.collection_system == "synapse":
        path_table  = f"transform/synapse/{contract.collection_name}/curated/{name}.sql"
        path_proc  = f"transform/synapse/{contract.collection_name}/curated/{name}.sql"

        curated_table   = curated_table_database_table.format(
            name=name, 
            columns=verbosed_non_primary_keys,
            primary_key=simple_primary_keys
            )
        
        curated_proc    = curated_table_database_table.format(
            name=name, 
            columns=simple_non_primary_keys, 
            natural_key_hash=natural_key_hash, 
            type1_scd_hash=type1_scd_hash
            )

    elif contract.collection_system == "database":
        path_table      = f"src/azure.sql/data_warehouse/curated/Tables/{name}.sql"
        path_proc       = f"src/azure.sql/data_warehouse/curated/Stored Procedures/{name}.sql"

        curated_table   = curated_table_database_table.format(
            name=name, 
            columns=verbosed_non_primary_keys, 
            primary_key=simple_primary_keys
            )

        if contract.load_method == "incremental":
            curated_proc    = curated_table_database_incremental_proc.format(
                name =name, 
                create_columns =verbosed_non_primary_keys, 
                columns =simple_non_primary_keys,
                source_columns =source_non_primary_keys,
                natural_key_hash =natural_key_hash, 
                type1_scd_hash =type1_scd_hash
                )
        elif contract.load_method == "snapshot":
            curated_proc    = curated_table_database_snapshot_proc.format(
                name =name, 
                create_columns =verbosed_non_primary_keys, 
                columns =simple_non_primary_keys,
                natural_key_hash =natural_key_hash, 
                type1_scd_hash =type1_scd_hash
                )
        else: # Default load method = truncate & reload
            curated_proc    = curated_table_database_default_proc.format(
                name=name, 
                create_columns=verbosed_non_primary_keys, 
                columns=simple_non_primary_keys,
                source_columns=source_non_primary_keys,
                natural_key_hash=natural_key_hash, 
                type1_scd_hash=type1_scd_hash
                )
        
    create_file(curated_table, path_table, overwrite=True)
    create_file(curated_proc, path_proc, overwrite=True)


def model(contract):
    name  = f"{contract.prefix}_{contract.code}"
    simple_all_columns  = simple(contract.all)

    if contract.collection_system == "synapse":
        path_model  = f"transform/synapse/{contract.collection_name}/model/{name}.sql"
        model = model_synapse.format(
            name=name, 
            columns=simple_all_columns
            )

    elif contract.collection_system == "database":
        path_model  = f"src/azure.sql/data_warehouse/model/Views/{name}.sql"
        model = model_database.format(
            name = name, 
            columns = simple_all_columns
            )

    create_file(model, path_model, overwrite=True)



# Generate SQL ---------------------------------------------------------
def sql_generator(contracts):
    for collection_system in ['synapse', 'database']:
        print(f'[+] Generating "{collection_system}" SQL')
        for contract in contracts:
            if contract.collection_system   == collection_system or contract.collection_type == 'datasource' :

                if contract.collection_type != 'datasource':
                    base_path = "src/azure.sql/data_warehouse/"
                    schemas()
                    stage(contract)
                    enriched(contract)
                    curated(contract)
                    model(contract)