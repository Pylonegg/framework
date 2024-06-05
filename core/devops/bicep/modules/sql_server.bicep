param resourceLocation            string
param sqlServerName               string
param networkIsolationMode        string
param aadAdminObjectIds           object
param databaseNames               array
param tags                        object

@description('Deploy Sql Server Resource')
resource r_sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: resourceLocation
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
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
resource r_aadAdminRoleAssignment 'Microsoft.Sql/servers/administrators@2023-05-01-preview' = {
  name: 'ServerADMIN'
  parent: r_sqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'AAD-GRP-DATA-PLATFORM-DEV'
    sid: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
    tenantId: tenant().tenantId
  }
}


// @description('Deploy Sql Server Database Resources')
// resource r_aadAdminRoleAssignment 'Microsoft.Sql/servers/administrators@2023-05-01-preview' = [for item in items(aadAdminObjectIds): {
//   name: 'AD-${item.key}'
//   parent: r_sqlServer
//   properties: {
//     administratorType: 'ActiveDirectory'
//     login: item.key
//     sid: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
//     tenantId: tenant().tenantId
//   }
// }]
