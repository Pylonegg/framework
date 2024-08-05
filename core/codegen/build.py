from contracts import Contracts
from sql_generate import sql_generator
from utility import deploy, create_parameters
from reporting import create_semantic_model


# Run
create_parameters()
contracts = Contracts()
# contracts.generate_sql()
create_semantic_model(contracts)

connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=control;Trusted_Connection=yes;'
#connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=dev01xctrlserver.database.windows.net;DATABASE=dev01xctrldb;UID=corleone;PWD=;TrustServerCertificate=yes;'

# deploy(contracts, connection_string)

sql_generator(contracts)
