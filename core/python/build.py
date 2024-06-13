from contracts import Contracts
from utility import deploy


# Run
contracts = Contracts()
contracts.generate_sql()

connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=control_table;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'
deploy(contracts, connection_string)
