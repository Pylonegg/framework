import os 
import json
import pyodbc
import yaml

# format metadata for easy contract creation
NOLEN = {"bit","date","datetime","datetime2","decimal","int","bigint","money","numeric","smallint","smallmoney","time","tinyint","uniqueidentifier","float"}


# =  OPEN YAML =====================================================================
def open_yaml(path):
    yaml_file = open(path)
    data = yaml.safe_load(yaml_file)
    return data


# = CREATE FILE ===================================================================
def create_file(data, filename, overwrite=True):
    # Create the directory if it doesn't exist
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    # Check if the file exists and overwrite is False
    if os.path.exists(filename) and not overwrite:
        print(f"File {filename} already exists. Skipping write operation.")
        return
    
    # Write the data to the file
    with open(filename, "w") as f:
        f.write(data)



# = Pretty Call =====================================================================
def pretty_execute(message:str, function:object):
    space = (60 - len(message)) * '-' + '>'
    try:
        output = function
        print(f"\033[92m[+]\33[0m - \033[90m{message}\33[0m")
    except Exception as e:
        print(f"\033[91m[x]\33[0m - \033[90m{message}\33[0m \033[91m{space}\33[0m {e}")
        output = None
    return output


# = CREATE FILE =====================================================================
def error_log(status, action, message=None):
    """
    Outputs a colour coded error message.
    """
    space = (60 - len(action)) * '-' + '>'
    END     = "\33[0m"
    AMBER   = "\033[33m"
    RED     = "\033[91m"
    GREEN   = "\033[92m"
    GREY    = "\033[90m"
    if status.lower() in ['failed','fail','f']:
        print(f"{RED}[x]{END} - {GREY}{action}{END} {RED}{space}{END} {message}")
    elif status.lower() in ['warning','warn','w',2]:
        print(f"{AMBER}[?]{END} - {GREY}{action}{END} {AMBER}{space}{END} {message}")
    else:
        print(f"{GREEN}[+]{END} - {GREY}{action}{END}")

    

# # = POSTGRE CONNECTION =====================================================================
# def postgresql_db():
#   import psycopg2
#   conn = psycopg2.connect(host=cs[0],port=cs[1],database=cs[2],user=cs[3],password=cs[4])
#   cursor = conn.cursor()
#   cursor.execute("SELECT * FROM INFORMATION_SCHEMA.COLUMNS")
#   query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
#   return query_result
# 
# 
# # = ORACLE CONNECTION =====================================================================
# def oracle_db():
#   import cx_Oracle
#   cx_Oracle.init_oracle_client(lib_dir="C:\\Oracle\\instantclient_21_9") # Pre installed Oracle client
#   conn = cx_Oracle.connect(dsn=cx_Oracle.makedsn(cs[0], cs[1], cs[2]),user=cs[3], password=cs[4]),
#   cursor = conn.cursor()
#   cursor.execute("SELECT * FROM INFORMATION_SCHEMA.COLUMNS")
#   query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
#   return query_result


# = READ SQL SERVER =====================================================================
def sql_server_db(connection_string, query):
  conn = pyodbc.connect(connection_string)
  cursor = conn.cursor()
  cursor.execute(query)
  query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
  return query_result


# = WRITE SQL SERVER =====================================================================
def execute(connection_string, query, msg):
    try:
        connection = pyodbc.connect(connection_string)
        cursor = connection.cursor()
    except Exception as e:
        error_log('fail', msg, e)

    else:
        query = query.split('GO\n')
        for q in query:
            cursor.execute(q)
        connection.commit()


# = BUILD YAML Contract ====================================================================
def format_field(label, value):
    return "" if value is None  else f"\n    {label}: {value}"

def build_contract(metadata):
    dataset = f"""
dataset:
    name: {metadata[0]['table_name']}
    description: {metadata[0]['description']}
    enabled: {metadata[0]['enabled']}
    type: {metadata[0]['type']}
    load_sytle: {metadata[0]['load_sytle']}
    load_method: {metadata[0]['load_method']}

columns:
""" 
    dataset += "\n".join(
        [
            f"""  - sort_order: {column['sort_order']}\
            {format_field('name'              , column['name'])}\
            {format_field('data_type'         , column['data_type'])}\
            {format_field('length'            , column['length'])}\
            {format_field('precision'         , column['precision'])}\
            {format_field('scale'             , column['scale'])}\
            {format_field('is_nullable'       , column['is_nullable'])}\
            {format_field('is_natural_key'    , column['is_natural_key'])}\
            {format_field('is_primary_key'    , column['is_primary_key'])}
            """
            for column in metadata
        ]
    )
    return dataset


# = DEPLOY CONTRACTS TO CONTROL DB ====================================================================
def deploy(contracts, connection_string):
    print("\n[+] Deployment in progress", end="")
    all_datasets = []
    all_dependencies = []
    for contract in contracts:
        all_datasets.append(f"('{contract.code}', '{contract.collection_name}', '{contract.is_enabled}','{contract.type}')")

        if contract.dependencies is not None:
            for dependency in contract.dependencies:
                split_dependency = dependency['name'].split('.')
                all_dependencies.append(f"('{contract.code}','{contract.collection_name}','{split_dependency[1]}','{split_dependency[0]}','{dependency['type']}')")


    query = f"""
    TRUNCATE TABLE [tmp].[datasets]
    INSERT INTO [tmp].[datasets] 
    VALUES  {','.join(all_datasets)}
    GO

    TRUNCATE TABLE tmp.dependency
    INSERT INTO tmp.dependency VALUES  {','.join(all_dependencies)}
    GO

    EXEC [audit].[setup]
    """
    execute(connection_string, query, "Writing datasets to control database")
    print("\r[+] Deployment                      \r[+] Deployment successful")


def create_parameters():
    # Load the YAML file
    with open('config.yml', 'r') as file:
        yaml_content = yaml.safe_load(file)
        infra = yaml_content['pipeline_parameters']

    parameters = {}
    for parameter in infra:
        parameters[parameter] = {}
        parameters[parameter]["value"] = infra[parameter]

    json_template = {}
    json_template["$schema"] = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"
    json_template["contentVersion"] = "1.0.0.0"
    json_template["parameters"] = parameters

    # write file out
    formatted_json = json.dumps(json_template, indent=2)
    with open('src/azure.pipelines/parameters.json', 'w') as f:
        f.write(formatted_json)
        print("[+] Parameters created!")