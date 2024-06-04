param resourceLocation            string
param sqlServerName               string
param networkIsolationMode        string
param sqlAdminLogin               string
param aadAdminObjectIds           object
param databaseNames               array
param tags                        object
@secure()
param sqlAdminPassword            string

@description('Deploy Sql Server Resource')
resource r_sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: resourceLocation
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    publicNetworkAccess: networkIsolationMode == 'vNet' ? 'Disabled' : 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

@description('Deploy Sql Server Database Resources')
resource r_sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = [for databaseName in databaseNames: {
  parent: r_sqlServer
  name: databaseName
  location: resourceLocation
  sku: {
    name: 'basic'
  }
}]

@description('Deploy Sql Server Database Resources')
resource r_aadAdminRoleAssignment 'Microsoft.Sql/servers/administrators@2023-05-01-preview' = [for item in items(aadAdminObjectIds): {
  name: 'AD-${item.key}'
  parent: r_sqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: item.key
    sid: item.value
    tenantId: tenant().tenantId
  }
}]
