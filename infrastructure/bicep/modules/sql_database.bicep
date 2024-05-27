param resourceLocation            string
param sqlServerName               string
param sqlDatabaseName             string
param skuName                     string



resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' existing = {
  name: sqlServerName
}

@description('Deploy Sql Server Database Resource')
resource r_sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: sqlDatabaseName
  location: resourceLocation
  sku: {
    name: skuName
  }
  parent: sqlServer
  identity: {
    type: 'None'
  }
}
