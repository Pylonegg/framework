from contracts import Contracts
from utility import deploy_sql, generate_server_contract


# Generate staging

cs_warehouse    = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wide_world_importers;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'
generate_server_contract('wide_world_importers', 'Application', 'People', cs_warehouse)


# Run
# contracts = Contracts()
# contracts.deploy()
# contracts.generate_sql()
