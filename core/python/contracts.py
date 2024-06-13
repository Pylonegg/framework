import os
from utility import error_log, execute, open_yaml, pretty_execute
from generate_scripts_database import database_sql
from generate_scripts_synapse import synapse_sql

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
        for collection in self.config['collection']:
            collection_name     = collection['name']
            collection_type     = collection['type']
            collection_system   = collection['system']
            is_enabled          = collection['is_enabled']
            path = os.path.join("contracts", collection_type, collection_name)

            if is_enabled:
                print(f"[+] Processing collection {collection_type}: {collection_name}")
                for filename in os.listdir(path):
                    data = open_yaml(os.path.join(path, filename))
                    data.update({
                        'collection_name': collection_name,
                        'collection_type': collection_type,
                        'collection_system': collection_system
                    })
                    message = f"Loading Contract: {data['dataset']['name']}"
                    pretty_execute(message=message, function=self.contracts.append(Contract(data)))
            else:
                print(f"[!] Skipping disabled collection {collection_type}: {collection_name}")

    def generate_sql(self):
        for collection_system in ['synapse', 'database']:
            print(f'[+] Generating "{collection_system}" SQL')
            for contract in self.contracts:
                if contract.collection_system   == collection_system or contract.collection_type == 'datasource' :
                    msg = contract.name
                    pretty_execute(message=msg, function=globals()[f'{collection_system}_sql'](contract))
        # NOTE  Maybe add loop [model, curated, enriched]



class Contract:
    def __init__(self, contract):
        self.contract               = contract
        self.dependencies           = self.contract.get('depends_on')
        self.collection_name        = contract.get('collection_name')
        self.collection_type        = contract.get('collection_type')
        self.collection_system      = contract.get('collection_system')        
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
            if column.name in column_list:
                _length         = "max" if column.length == -1 else column.length
                length          = "" if _length is None else f"({_length})"  
                output.append(f"[{column.name}] {column.data_type}{length}")
        return ",\n\t".join(output)



    def verbosed(self, column_list): 
        output = [] # [Employee Key] int NOT NULL
        for column in self.columns:
            if column.name in column_list:
                _length         = "max" if column.length == -1 else column.length
                length          = "" if _length is None else f"({_length})"
                nullable        = "NULL" if column.nullable else "NOT NULL"
                output.append(f"[{column.name}] {column.data_type}{length} {nullable}")
        return ",\n\t".join(output)
