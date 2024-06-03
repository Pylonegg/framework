param resourceLocation            string
param sqlServerName               string
param networkIsolationMode        string
param sqlAdminLogin               string
@secure()
param sqlAdminPassword            string
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
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
  //  administrators: {
  //    administratorType: 'ActiveDirectory'
  //    azureADOnlyAuthentication: bool
  //    login: 'string'
  //    principalType: 'string'
  //    sid: 'string'
  //    tenantId: 'string'
  //  }
    publicNetworkAccess: networkIsolationMode == 'vNet' ? 'Disabled' : 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}
