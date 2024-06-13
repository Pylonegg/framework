# Quick Start
Lorem ipsum
- Populate excel file.
- Populate config.yml
- Add enrich logic
- Build


## Populate Excel file
## Populate config.yml
## Add enrich logic

- Include ad group as Server Admin|
- Add Service Connection (Application Pricipal) to above AD group
- Microsoft.AAD/DomainServices/domainService
- Grant ADF permision to Key Vault
- Connot have spaced in the 'login' name for aad authentication with sql server.


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

