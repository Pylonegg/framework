import os
from utility import error_log, execute, open_yaml
from generate_sql import create_sql

class Config:
    def __init__(self):
        self.config                 = open_yaml('config.yml')
        self.cnxn                   = self.config.get('connection_string')
        self.mart_path              = self.config.get('data_mart_path')
        self.mart_active            = []
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
        self.config                 = Config()
        self.contracts              = []
        self.load_contracts()

    def __len__(self):
        return len(self.contracts)
    
    def __getitem__(self):
        pass
    
    def load_contracts(self):
        print("\n[+] Loading Contracts")
        config = self.config
        for mart_name in config.mart_active:
            path = os.path.join(config.mart_path, mart_name)
            for filename in os.listdir(path):
                data = open_yaml(os.path.join(path,filename))
                message = ""
                try:
                    message = f"Loading Contract - {data['dataset']['name']}"
                    error_log('pass',message)
                    self.contracts.append(Contract(data))
                except Exception as error:
                    error_log('fail', message, error)


    def generate_sql(self):
        for contract in self.contracts:
            create_sql(contract) # Maybe add loop [model, curated, enriched]


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
        execute((self.config.cnxn), query, "Writing datasets to control database")
# <<< Refactor ======================================================================================


class Formats:
    def __init__(self, columns):
        self._seperator            = ",\n\t"
        self.columns               = columns
        self.all                   = [col.name                                      for col in self.columns]
        self.scd1                  = [col.name  if col.scd1             else None   for col in self.columns]   
        self.primary_keys          = [col.name  if col.primary_keys     else None   for col in self.columns]
        self.natural_keys          = [col.name  if col.natural_keys     else None   for col in self.columns]
        self.non_primary_keys      = [col.name  if not col.primary_keys else None   for col in self.columns]  

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
        return self._seperator.join([f"'' AS [{col_name}]" for col_name in cols if col_name is not None])

    def simple(self, cols):
        return self._seperator.join([f"[{col_name}]" for col_name in cols if col_name is not None])
            
    def quoted(self, cols):
        return self._seperator.join([f"'{col_name}'" for col_name in cols if col_name is not None])

    def source_target(self, cols):
        return self._seperator.join([f"T.[{col_name}] = S.[{col_name}]" for col_name in cols if col_name is not None])
    
    def source(self, cols):
        return self._seperator.join([f"S.[{col_name}]" for col_name in cols if col_name is not None])

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
