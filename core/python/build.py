from contracts import Contracts

# connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wwi_data_mart;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'


# Run
contracts = Contracts()
#contracts.deploy()
contracts.generate_sql()
