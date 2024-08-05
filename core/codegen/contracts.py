import os
from utility import open_yaml, pretty_execute


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
            path = os.path.join("src",f"metadata.{collection_type}", collection_name)

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



class Contract:
    def __init__(self, contract):
        self.contract              = contract
        self.dependencies          = self.contract.get('depends_on')
        self.collection_name       = contract.get('collection_name')
        self.collection_type       = contract.get('collection_type')
        self.collection_system     = contract.get('collection_system')        
        self.dataset               = contract.get('dataset')
        self.code                  = self.dataset.get('name')
        self.name                  = self.dataset.get('name')
        self.description           = self.dataset.get('decription')
        self.is_enabled            = self.dataset.get('enabled')
        self.type                  = self.dataset.get('type')
        self.load_method           = self.dataset.get('load_method')
        self.prefix                = 'dim' if (self.type).lower() == 'dimension' else 'fact'
        self.columns               = [Columns(column) for column in self.contract['columns']]
        self.all                   = [col.name for col in self.columns]
        self.scd1                  = [col.name for col in self.columns if col.scd1 ]   
        self.primary_keys          = [col.name for col in self.columns if col.primary_keys]
        self.natural_keys          = [col.name for col in self.columns if col.natural_keys]
        self.non_primary_keys      = [col.name for col in self.columns if not col.primary_keys]  

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