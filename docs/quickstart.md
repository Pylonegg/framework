# Quick Start
Lorem ipsum
- Populate excel file.
- Populate config.yml
- Add enrich logic
- Build


## Populate Excel file
## Populate config.yml
## Add enrich logic

|Status|Task |
|---|---|
|Done | Include ad group as Server Admin|
|Todo | Add Service Connection (Application Pricipal) to above AD group |
||Microsoft.AAD/DomainServices/domainService|


Change arrays to objects
```bicep
resource myRgs 'Microsoft.Resources/resourceGroups@2021-04-01' = [for item in items(myObj): {
  name: item.key
  location: 'West US'
  tags: {
    value: item.value
  }
}]
```

Connot have spaced in the 'login' name for aad authentication with sql server.