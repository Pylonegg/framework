from utility import sql_server_db, create_file, build_contract


# Generate staging
staging_tables = [ ["Warehouse","Colors"],["Sales","OrderLines"],["Warehouse","PackageTypes"],["Warehouse","StockGroups"],["Warehouse","StockItemStockGroups"],["Application","StateProvinces"],["Sales","CustomerTransactions"],["Application","Cities"],["Application","SystemParameters"],["Sales","InvoiceLines"],["Purchasing","Suppliers"],["Warehouse","StockItemTransactions"],["Sales","Customers"],["Purchasing","PurchaseOrders"],["Sales","Orders"],["Warehouse","ColdRoomTemperatures"],["Warehouse","VehicleTemperatures"],["Application","People"],["Warehouse","StockItems"],["Application","Countries"],["Warehouse","StockItemHoldings"],["Purchasing","PurchaseOrderLines"],["Application","DeliveryMethods"],["Application","PaymentMethods"],["Purchasing","SupplierTransactions"],["Application","TransactionTypes"],["Sales","SpecialDeals"],["Purchasing","SupplierCategories"],["Sales","BuyingGroups"],["Sales","Invoices"],["Sales","CustomerCategories"]]
cs_warehouse   = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=wide_world_importers;UID=sa;PWD=Password01234;TrustServerCertificate=yes;'

def generate_server_contract(database_name, connection_string):
    for i in staging_tables:
        table_schema = i[0]
        table_name   = i[1]

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
        print(f"[+] Generating Staging Contract: {database_name} - {table_schema}-{table_name}")
        create_file(yaml_data, target_path)


generate_server_contract("WideWorldImporters", cs_warehouse)