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
def create_file(data, filename):
    os.makedirs(os.path.dirname(filename), exist_ok=True)
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

    

# = POSTGRE CONNECTION =====================================================================
def postgresql_db():
  import psycopg2
  conn = psycopg2.connect(host=cs[0],port=cs[1],database=cs[2],user=cs[3],password=cs[4])
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM INFORMATION_SCHEMA.COLUMNS")
  query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
  return query_result


# = ORACLE CONNECTION =====================================================================
def oracle_db():
  import cx_Oracle
  cx_Oracle.init_oracle_client(lib_dir="C:\\Oracle\\instantclient_21_9") # Pre installed Oracle client
  conn = cx_Oracle.connect(dsn=cx_Oracle.makedsn(cs[0], cs[1], cs[2]),user=cs[3], password=cs[4]),
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM INFORMATION_SCHEMA.COLUMNS")
  query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
  return query_result


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



# = BUILD YAML Contract ====================================================================
def generate_server_contract(database_name, table_schema, table_name, connection_string):
    # query to run against database to obtain metadata
    query = f"""
        SELECT
             concat(C.TABLE_SCHEMA,'_',C.TABLE_NAME)    AS table_name
            ,concat('Staging table ', C.TABLE_NAME)     AS description
            ,'true'                                     AS enabled
            ,'staging'                                  AS type
            ,'default'                                  AS load_sytle
            ,'default'                                  AS load_method
            ,C.ORDINAL_POSITION                         AS sort_order
            ,C.COLUMN_NAME                              AS name
            ,C.DATA_TYPE                                AS data_type
            ,C.CHARACTER_MAXIMUM_LENGTH                 AS length
            ,case when C.DATA_TYPE in ('decimal','numeric') then C.NUMERIC_PRECISION  else null end AS precision
            ,case when C.DATA_TYPE in ('decimal','numeric') then C.NUMERIC_SCALE  else null end      AS scale
            ,case when C.IS_NULLABLE = 'YES' then 'true'  else null end      AS is_nullable
            ,null                                       AS is_natural_key
            ,null                                       AS is_primary_key
        FROM INFORMATION_SCHEMA.COLUMNS C
        INNER JOIN INFORMATION_SCHEMA.TABLES T
            ON T.TABLE_NAME = C.TABLE_NAME
            AND T.TABLE_SCHEMA = C.TABLE_SCHEMA
            AND T.TABLE_CATALOG = C.TABLE_CATALOG
            AND T.TABLE_TYPE = 'BASE TABLE'
        WHERE C.TABLE_NAME      = '{table_name}'
            AND C.TABLE_SCHEMA  = '{table_schema}'
        """
    # execute query and obtain meta data
    metadata    = sql_server_db(connection_string, query)
    yaml_data   = build_contract(metadata)
    target_path = f"contracts/datasource/{database_name}/{table_schema}_{table_name}.yml"
    create_file(yaml_data, target_path)