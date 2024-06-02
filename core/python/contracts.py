import os
from utility import error_log, execute, open_yaml
from generate_database_scripts import database_sql
from generate_synapse_scripts import synapse_sql

class Config:
    def __init__(self):
        self.config                 = open_yaml('config.yml')
        self.cnxn                   = self.config.get('connection_string')
        self.mart_path              = self.config.get('data_mart_path')
        self.mart_active            = []
        self.mart_type              = self.config.get('data_mart_path')
        self.marts()
    
    def marts(self):
        for mart in self.config['data_marts']:
            if mart['is_enabled']:
                self.mart_active .append(mart['name'])
        return



class Columns:
    def __init__(self, column):
        self.column                 = column
        self.sort_order             = column.get('sort_order')
        self.code                   = column.get('name')
        self.name                   = column.get('name')
        self.data_type              = column.get('data_type')
        self.length                 = column.get('length')
        self.nullable               = column.get('is_nullable')
        self.primary_keys           = column.get('is_primary_key')
        self.natural_keys           = column.get('is_natural_key')
        self.scd1                   = column.get('is_scd1')
    
    def __repr__(self) -> str:
        return self.code
    


class Contract:
    def __init__(self, contract):
        self.contract               = contract
        self.dependencies           = self.contract.get('depends_on')
        self.mart_name              = contract.get('mart_name')
        self.mart_type              = contract.get('mart_type')
        self.dataset                = contract.get('dataset')
        self.code                   = self.dataset.get('name')
        self.name                   = self.dataset.get('name')
        self.description            = self.dataset.get('decription')
        self.is_enabled             = self.dataset.get('enabled')
        self.type                   = self.dataset.get('type')
        self.prefix                 = 'dim' if (self.type).lower() == 'dimension' else 'fact'
        self.columns                = [Columns(column) for column in self.contract['columns']]
        self.format                 = Formats(self.columns)

    def __repr__(self) -> str:
        return self.code
    


class Contracts:
    def __init__(self):
        self.config             = open_yaml('config.yml')
        self.contracts          = []
        self.load_contracts()

    def __len__(self):
        return len(self.contracts)
    
    def __getitem__(self, index):
        return self.contracts[index]
    
    def load_contracts(self): 
        for data_mart   in self.config['data_marts']:
            mart_name   = data_mart['name']
            mart_type   = data_mart['type']
            is_enabled  = data_mart['is_enabled']
            mart_path   = self.config['data_mart_path'] + "/" + mart_name

            if is_enabled:
                print(f"[+] Processing mart: {mart_name}")
                for filename in os.listdir(mart_path):
                    data = open_yaml(os.path.join(mart_path,filename))
                    data['mart_name'] = mart_name
                    data['mart_type'] = mart_type
                    message = f"Loading Contract: {data['dataset']['name']}"
                    try:
                        self.contracts.append(Contract(data))
                        error_log('pass',message)
                    except Exception as e:
                        error_log('fail', message, e)
            else:
                print(f"[!] Skipping disabled mart: {mart_name}")


    def generate_sql(self):
        mart_types = ['synapse', 'database']
        for mart_type in mart_types:
            print(f"[+] Generating {mart_type} SQL")
            for contract in self.contracts:             # Maybe add loop [model, curated, enriched]
                if contract.mart_type   == mart_type:
                    try:
                        database_sql(contract)
                        error_log('pass',contract.name)
                    except Exception as e:
                        error_log('fail', contract.name, e)


# >>> Refactor ======================================================================================
    def deploy(self):
        print("\n[+] Deploying Contracts")
        all_datasets = []
        all_dependencies = []
        for contract in self.contracts:
            all_datasets.append(f"('{contract.code}', '', '{contract.is_enabled}','{contract.type}')")

            if contract.dependencies is not None:
                for dependency in contract.dependencies:
                    all_dependencies.append(f"('{contract.code}','{dependency['name']}','{dependency['type']}')")

    
        query = f"TRUNCATE TABLE [tmp].[datasets]\nGO\nINSERT INTO [tmp].[datasets] VALUES  {','.join(all_datasets)}\nGO\n"
        # query += f"TRUNCATE TABLE tmp.dependencies\nGO\nINSERT INTO tmp.dependencies VALUES  {','.join(all_dependencies)}\nGO\n"
        query += "EXEC [audit].[setup]"
        execute((self.config['connection_string']), query, "Writing datasets to control database")
# <<< Refactor ======================================================================================


class Formats:
    def __init__(self, columns):
        self._seperator            = ",\n\t"
        self.columns               = columns
        self.all                   = [col.name for col in self.columns]
        self.scd1                  = [col.name for col in self.columns if col.scd1 ]   
        self.primary_keys          = [col.name for col in self.columns if col.primary_keys]
        self.natural_keys          = [col.name for col in self.columns if col.natural_keys]
        self.non_primary_keys      = [col.name for col in self.columns if not col.primary_keys]  

        # formats 
        self.all_simple            = self.simple(self.all)
        self.scd1_simple           = self.simple(self.scd1)
        self.nk_simple             = self.simple(self.natural_keys)
        self.pk_simple             = self.simple(self.primary_keys)
        self.npk_simple            = self.simple(self.non_primary_keys)
        self.nk_blank              = self.blank(self.natural_keys)
        self.pk_blank              = self.blank(self.primary_keys)
        self.npk_blank             = self.blank(self.non_primary_keys)
        self.npk_type              = self.data_type(self.non_primary_keys)
        self.npk_verbosed          = self.verbosed(self.non_primary_keys)

        # self.primaryKeys_simple            = sql_bits(self.columns, "primary_key", "simple")
        # self.primaryKeys_blank             = sql_bits(self.columns, "primary_key", "blank")
        # self.nonPrimaryKeys_dataType       = sql_bits(self.columns, "non_primary_key", "data_type")
        # self.nonPrimaryKeys_simple         = sql_bits(self.columns, "non_primary_key", "simple")
        # self.nonPrimaryKeys_blank          = sql_bits(self.columns, "non_primary_key", "blank")
        # self.nonPrimaryKeys_defaults       = sql_bits(self.columns, "non_primary_key", "defaults")
        # self.naturalKeys_simple            = sql_bits(self.columns, "natural_key", "simple")
        # self.all_simple                    = sql_bits(self.columns, "all", "simple")
        # self.all_verbosed                  = sql_bits(self.columns, "all", "verbosed")
        # self.scd1_simple                   = sql_bits(self.columns, "scd1", "simple")
        # self.scd1_source                   = sql_bits(self.columns, "scd1", "source")
        # self.scd1_sourceTarget             = sql_bits(self.columns, "scd1", "source_target")



    def blank(self, cols):
        return self._seperator.join([f"'' AS [{col_name}]" for col_name in cols])

    def simple(self, cols):
        return self._seperator.join([f"[{col_name}]" for col_name in cols])
            
    def quoted(self, cols):
        return self._seperator.join([f"'{col_name}'" for col_name in cols])

    def source_target(self, cols):
        return self._seperator.join([f"T.[{col_name}] = S.[{col_name}]" for col_name in cols])
    
    def source(self, cols):
        return self._seperator.join([f"S.[{col_name}]" for col_name in cols])

    def data_type(self, column_list):
        output = []
        for column in self.columns:
            if str(column) in column_list:
                _length         = "max" if column.length == -1 else column.length
                length          = "" if _length is None else f"({_length})"  
                output.append(f"[{column.name}] {column.data_type}{length}")
        return ",\n\t".join(output)



    def verbosed(self, column_list): 
        output = [] # [Employee Key] int NOT NULL
        for column in self.columns:
            if str(column) in column_list:
                _length         = "max" if column.length == -1 else column.length
                length          = "" if _length is None else f"({_length})"
                nullable        = "NULL" if column.nullable else "NOT NULL"
                output.append(f"[{column.name}] {column.data_type}{length} {nullable}")
        return ",\n\t".join(output)
