import os
import logging
from utility import error_log, execute, open_yaml
from generate_database_scripts import create_sql

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


class Config:
    def __init__(self):
        self.config = open_yaml('config.yml')
        self.cnxn = self.config.get('connection_string')
        self.mart_path = self.config.get('data_mart_path')
        self.mart_active = self._active_marts()

    def _active_marts(self):
        return [mart['name'] for mart in self.config.get('data_marts', []) if mart.get('is_enabled')]


class Column:
    def __init__(self, column):
        self.column = column
        self.sort_order = column.get('sort_order')
        self.code = column.get('name')
        self.name = column.get('name')
        self.data_type = column.get('data_type')
        self.length = column.get('length')
        self.nullable = column.get('is_nullable')
        self.primary_keys = column.get('is_primary_key')
        self.natural_keys = column.get('is_natural_key')
        self.scd1 = column.get('is_scd1')

    def __repr__(self):
        return self.code


class Contract:
    def __init__(self, contract):
        self.contract = contract
        self.dependencies = contract.get('depends_on')
        self.dataset = contract.get('dataset')
        self.code = self.dataset.get('name')
        self.name = self.dataset.get('name')
        self.description = self.dataset.get('description')
        self.is_enabled = self.dataset.get('enabled')
        self.type = self.dataset.get('type')
        self.prefix = 'dim' if self.type.lower() == 'dimension' else 'fact'
        self.columns = [Column(column) for column in contract['columns']]
        self.format = Formats(self.columns)

    def __repr__(self):
        return self.code


class Contracts:
    def __init__(self):
        self.config = Config()
        self.contracts = []
        self.load_contracts()

    def __len__(self):
        return len(self.contracts)

    def __getitem__(self, index):
        return self.contracts[index]

    def load_contracts(self):
        logging.info("[+] Loading Contracts")
        for mart_name in self.config.mart_active:
            path = os.path.join(self.config.mart_path, mart_name)
            for filename in os.listdir(path):
                data = open_yaml(os.path.join(path, filename))
                message = f"Loading Contract - {data['dataset']['name']}"
                try:
                    self.contracts.append(Contract(data))
                    error_log('pass', message)
                except Exception as error:
                    error_log('fail', message, error)
                    logging.error(f"Failed to load contract: {filename}. Error: {error}")

    def generate_sql(self):
        for contract in self.contracts:
            create_sql(contract)  # Maybe add loop [model, curated, enriched]

    def deploy(self):
        logging.info("[+] Deploying Contracts")
        all_datasets = [f"('{contract.code}', '', '{contract.is_enabled}', '{contract.type}')" for contract in self.contracts]
        all_dependencies = [f"('{contract.code}', '{dependency['name']}', '{dependency['type']}')" 
                            for contract in self.contracts if contract.dependencies 
                            for dependency in contract.dependencies]

        query = f"""
        TRUNCATE TABLE [tmp].[datasets]
        GO
        INSERT INTO [tmp].[datasets] VALUES {','.join(all_datasets)}
        GO
        EXEC [audit].[setup]
        """
        execute(self.config.cnxn, query, "Writing datasets to control database")


class Formats:
    def __init__(self, columns):
        self._separator = ",\n\t"
        self.columns = columns
        self.all = [col.name for col in self.columns]
        self.scd1 = [col.name for col in self.columns if col.scd1]
        self.primary_keys = [col.name for col in self.columns if col.primary_keys]
        self.natural_keys = [col.name for col in self.columns if col.natural_keys]
        self.non_primary_keys = [col.name for col in self.columns if not col.primary_keys]

        self.all_simple = self._simple(self.all)
        self.scd1_simple = self._simple(self.scd1)
        self.nk_simple = self._simple(self.natural_keys)
        self.pk_simple = self._simple(self.primary_keys)
        self.npk_simple = self._simple(self.non_primary_keys)
        self.nk_blank = self._blank(self.natural_keys)
        self.pk_blank = self._blank(self.primary_keys)
        self.npk_blank = self._blank(self.non_primary_keys)
        self.npk_type = self._data_type(self.non_primary_keys)
        self.npk_verbosed = self._verbosed(self.non_primary_keys)

    def _blank(self, cols):
        return self._separator.join([f"'' AS [{col_name}]" for col_name in cols if col_name])

    def _simple(self, cols):
        return self._separator.join([f"[{col_name}]" for col_name in cols if col_name])

    def _data_type(self, column_list):
        output = []
        for column in self.columns:
            if column.name in column_list:
                _length = "max" if column.length == -1 else column.length
                length = "" if _length is None else f"({_length})"
                output.append(f"[{column.name}] {column.data_type}{length}")
        return self._separator.join(output)

    def _verbosed(self, column_list):
        output = []
        for column in self.columns:
            if column.name in column_list:
                _length = "max" if column.length == -1 else column.length
                length = "" if _length is None else f"({_length})"
                nullable = "NULL" if column.nullable else "NOT NULL"
                output.append(f"[{column.name}] {column.data_type}{length} {nullable}")
        return self._separator.join(output)
