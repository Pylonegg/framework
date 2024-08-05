import json
import uuid


def string_to_uuid(string):
    uid = uuid.uuid5(uuid.NAMESPACE_DNS, string)
    return str(uid)
  


def columns(columns):
    column_list = []
    for col in columns:
      column = {}
      column["name"] = col.name
      column["annotations"] = [{
              "name": "SummarizationSetBy",
              "value": "Automatic"
            }]
      column["dataType"]     = "int64"
      column["formatString"] = "0"
      column["sourceColumn"] = col.name
      column["summarizeBy"]  = "none"
      column_list.append(column)
    return column_list


def measures():
    measure_list = []
    measure = {}
    measure["name"] = "Measure"
    measure["expression"] = "sum(financials[ Sales])"
    #LineageTag
    measure_list.append(measure)
    return measure


def relationships(contracts):
    relationship_list = []
    for contract in contracts:
      relationship = {}
      relationship["name"] = string_to_uuid("a_b")
      relationship["fromColumn"] = "City Key"
      relationship["fromTable"] = "fact_Sale"
      relationship["toColumn"] = "City Key"
      relationship["toTable"] = "dim_City"
      relationship_list.append(relationship)
    return relationship_list


def tables(contracts):
    table_list = []
    for contract in contracts:
      if contract.collection_type == 'transform':
        table = {}
        table_name = contract.prefix + '_' + contract.name
        table["name"] = table_name
        table["annotations"] = [{"name": "PBI_ResultType", "value": "Table"}]
        table["columns"]    = columns(contract.columns)
        table["measures"]   = [] #measures()
        table["partitions"] = [
              {
                "name": f"{table_name}",
                "mode": "import",
                "source": {
                  "expression": [
                    "let",
                    "    Source = Sql.Database(Server, Database),",
                    f'''    Table = Source{{[Schema=\"model\",Item=\"{table_name}\"]}}[Data]''',
                    "in",
                    "    Table"
                  ],
                  "type": "m"
                }
              }
            ]
        table_list.append(table)
    return table_list


def model(contract):
    file = {}
    file["compatibilityLevel"] = 1550
    file["model"] = {}
    file["model"]["annotations"] = [
      {
        "name": "__PBI_TimeIntelligenceEnabled",
        "value": "0"
      }
    ]
    file["model"]["culture"] = "en-GB"
    file["model"]["dataAccessOptions"] = {
      "legacyRedirects": True,
      "returnErrorValuesAsNull": True
    }
    file["model"]["defaultPowerBIDataSourceVersion"] = "powerBI_V3"
    file["model"]["expressions"] = [
      {
        "name": "Server",
        "annotations": [
          {
            "name": "PBI_NavigationStepName",
            "value": "Navigation"
          },
          {
            "name": "PBI_ResultType",
            "value": "Text"
          }
        ],
        "expression": "\"localhost\" meta [IsParameterQuery=true, Type=\"Text\", IsParameterQueryRequired=true]",
        "kind": "m",
        "lineageTag": "22b59b36-0933-49d4-bcf6-69b104b2e65e"
      },
      {
        "name": "Database",
        "annotations": [
          {
            "name": "PBI_NavigationStepName",
            "value": "Navigation"
          },
          {
            "name": "PBI_ResultType",
            "value": "Text"
          }
        ],
        "expression": "\"data_warehouse\" meta [IsParameterQuery=true, Type=\"Text\", IsParameterQueryRequired=true]",
        "kind": "m",
        "lineageTag": "2e1bba7e-bcb8-4e67-a3bd-7edfae637b78"
      }
    ]
    file["model"]["relationships"] = relationships(contract)
    file["model"]["sourceQueryCulture"] = "en-GB"
    file["model"]["tables"] = tables(contract)
    
    return file


def create_semantic_model(contract):
    
    json_file = model(contract)
    model_file = json.dumps(json_file, indent=2)   
    with open('src/microsoft.fabric/dw.SemanticModel/model.bim', 'w') as f:
        f.write(model_file)
    print("[+] Model created!")



