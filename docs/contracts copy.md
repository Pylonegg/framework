# Contracts Management
[Go Back](../readme.md)

[Contract file](../../core/python/contracts.py)

## Overview

The Contracts Management System is a Python-based framework designed to load, manage, and deploy data contracts from a configuration file. It defines several classes to handle configurations, columns, contracts, and formats for generating SQL scripts and managing data marts.

1. [Configuration](#configuration)
2. [Column Class](#column-class)
3. [Contract Class](#contract-class)
4. [Contracts Class](#contracts-class)
5. [Formats Class](#formats-class)
6. [Utilities](#utilities)
7. [Usage](#usage)

## Configuration

The `Config` class is responsible for loading and managing the configuration file (`config.yml`). It initializes the database connection string and identifies active data marts.

### Class Definition

```python
class Config:
    def __init__(self):
        self.config = open_yaml('config.yml')
        self.cnxn = self.config.get('connection_string')
        self.mart_path = self.config.get('data_mart_path')
        self.mart_active = self._active_marts()

    def _active_marts(self):
        return [mart['name'] for mart in self.config.get('data_marts', []) if mart.get('is_enabled')]
```

### Attributes

- `config`: Dictionary representation of the configuration file.
- `cnxn`: Database connection string.
- `mart_path`: Path to the data marts.
- `mart_active`: List of active data marts.

### Methods

- `_active_marts()`: Returns a list of names of enabled data marts.

## Column Class

The `Column` class represents a single column in a dataset. It encapsulates various properties of the column such as name, data type, length, and keys.

### Class Definition

```python
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
```

### Attributes

- `column`: Dictionary representation of the column.
- `sort_order`: Sort order of the column.
- `code`: Column code (name).
- `name`: Column name.
- `data_type`: Data type of the column.
- `length`: Length of the column.
- `nullable`: Indicates if the column is nullable.
- `primary_keys`: Indicates if the column is a primary key.
- `natural_keys`: Indicates if the column is a natural key.
- `scd1`: Indicates if the column is a slowly changing dimension type 1 (SCD1).

### Methods

- `__repr__()`: Returns the column code (name).

## Contract Class

The `Contract` class represents a data contract, which includes a dataset and its dependencies. It encapsulates the properties and columns of the dataset.

### Class Definition

```python
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
```

### Attributes

- `contract`: Dictionary representation of the contract.
- `dependencies`: Dependencies of the contract.
- `dataset`: Dataset information within the contract.
- `code`: Code (name) of the dataset.
- `name`: Name of the dataset.
- `description`: Description of the dataset.
- `is_enabled`: Indicates if the dataset is enabled.
- `type`: Type of the dataset (dimension or fact).
- `prefix`: Prefix based on the type of dataset.
- `columns`: List of `Column` objects representing the columns of the dataset.
- `format`: `Formats` object for generating various SQL formats for the columns.

### Methods

- `__repr__()`: Returns the dataset code (name).

## Contracts Class

The `Contracts` class manages multiple `Contract` objects. It loads contracts from the specified data marts and provides methods to generate SQL scripts and deploy contracts.

### Class Definition

```python
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
```

### Attributes

- `config`: `Config` object for managing configurations.
- `contracts`: List of `Contract` objects.

### Methods

- `__len__()`: Returns the number of contracts.
- `__getitem__(index)`: Returns the contract at the specified index.
- `load_contracts()`: Loads contracts from the active data marts.
- `generate_sql()`: Generates SQL scripts for all loaded contracts.
- `deploy()`: Deploys the contracts by writing datasets to the control database.

## Formats Class

The `Formats` class is responsible for generating various SQL formats for columns based on their properties.

### Class Definition

```python
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
```

### Attributes

- `columns`: List of `Column` objects

.
- `all`: List of all column names.
- `scd1`: List of SCD1 column names.
- `primary_keys`: List of primary key column names.
- `natural_keys`: List of natural key column names.
- `non_primary_keys`: List of non-primary key column names.

### Methods

- `_blank(cols)`: Returns a formatted string with blank values for the given columns.
- `_simple(cols)`: Returns a formatted string with simple column names for the given columns.
- `_data_type(column_list)`: Returns a formatted string with data types for the given columns.
- `_verbosed(column_list)`: Returns a detailed formatted string for the given columns.

## Utilities

The system uses utility functions from the `utility` module:

- `error_log(status, message, error=None)`: Logs an error message.
- `execute(connection_string, query, description)`: Executes a SQL query.
- `open_yaml(file_path)`: Opens and reads a YAML file.

## Usage

To use the Contracts Management System, follow these steps:

1. **Configuration**: Ensure you have a `config.yml` file with the necessary configuration.

2. **Initialize Contracts**: Create an instance of the `Contracts` class to load and manage contracts.

```python
contracts = Contracts()
```

3. **Generate SQL Scripts**: Generate SQL scripts for all loaded contracts.

```python
contracts.generate_sql()
```

4. **Deploy Contracts**: Deploy the contracts to the control database.

```python
contracts.deploy()
```

Ensure the `config.yml` file is correctly set up with the required paths and connection strings. The `Contracts` class will handle loading the contracts, generating SQL scripts, and deploying them as needed.