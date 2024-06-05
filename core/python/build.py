from contracts import Contracts
from utility import generate_server_contract


# Generate staging
staging_tables = [
 ["Warehouse","Colors"]
,["Sales","OrderLines"]
,["Warehouse","PackageTypes"]
,["Warehouse","StockGroups"]
,["Warehouse","StockItemStockGroups"]
,["Application","StateProvinces"]
,["Sales","CustomerTransactions"]
,["Application","Cities"]
,["Application","SystemParameters"]
,["Sales","InvoiceLines"]
,["Purchasing","Suppliers"]
,["Warehouse","StockItemTransactions"]
,["Sales","Customers"]
,["Purchasing","PurchaseOrders"]
,["Sales","Orders"]
,["Warehouse","ColdRoomTemperatures"]
,["Warehouse","VehicleTemperatures"]
,["Application","People"]
,["Warehouse","StockItems"]
,["Application","Countries"]
,["Warehouse","StockItemHoldings"]
,["Purchasing","PurchaseOrderLines"]
,["Application","DeliveryMethods"]
,["Application","PaymentMethods"]
,["Purchasing","SupplierTransactions"]
,["Application","TransactionTypes"]
,["Sales","SpecialDeals"]
,["Purchasing","SupplierCategories"]
,["Sales","BuyingGroups"]
,["Sales","Invoices"]
,["Sales","CustomerCategories"]
]

connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wwi_data_mart;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'
cs_warehouse    = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wide_world_importers;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'
for i in staging_tables:
    generate_server_contract('WideWorldImporters', i[0], i[1], cs_warehouse)


# Run
contracts = Contracts()
#contracts.deploy()
contracts.generate_sql()
