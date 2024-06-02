import os 
import json
import pyodbc
import yaml


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


# = LOCAL DEPLOY ===================================================================
def deploy_sql():
    connection_string = ('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wwi_data_mart;UID=sa;PWD=Password01234;TrustServerCertificate=yes;')
    curation_stages = ["enriched","curated","model","etl"]
    
    print("\n[+] Deploying SQL Objects")
    message = ""
    try:
        for curation_stage in curation_stages:
            path    = os.path.join("etl/sql_server/wwi_data_mart", curation_stage)
            folder  = os.listdir(path)
            print(f"[+] - Deploying {curation_stage} SQL Objects")

            for filename in folder:
                message = f"Deploying {curation_stage} - {filename}"
                target = os.path.join(path,filename)
                sql_query =  open(target).read()
                execute(connection_string, sql_query, "")
                error_log('pass', message)
    except Exception as e:
        error_log('fail', message, e)




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
def sql_server_db(server=str, database=str, query=str):
  import pyodbc
  conn = pyodbc.connect(f"Driver={{SQL Server}};Server={server};Database={database};Trusted_Connection=yes;")
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