param ctrlDeploySynapse             bool
param ctrlDeployPurview             bool
param ctrlDeployDataFactory         bool

@secure()
param sqlAdminPassword              string
param keyVaultName string
param purviewAccountName            string
param synapseWorkspaceName          string
param dataFactoryName               string


var dummy_pid = '00000000-0000-0000-0000-000000000000'

//== Lookup  Resources                  ===================================================================
resource r_purviewAccount 'Microsoft.Purview/accounts@2021-07-01' existing = {
  name: purviewAccountName
}

resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName
}

resource r_dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}


module m_keyvaultPermissions 'modules/keyvault_permissions.bicep' = {
  name: '${keyVaultName}Permissions'
  params:{
    keyVaultName: keyVaultName
    policies: [
      {
        principalId: '3809d824-2e13-4883-a19c-dfd86ec9e012'
        secrets: ['all']
      }
      {
        principalId: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
        secrets: ['all']
      }
      {
        principalId: ctrlDeployDataFactory ? r_dataFactory.identity.principalId : dummy_pid
        secrets: ['get', 'list']
      }
      {
        principalId: ctrlDeployPurview ? r_purviewAccount.identity.principalId : dummy_pid
        secrets: ['get', 'list']
      }
      {
        principalId: ctrlDeploySynapse ? r_synapseWorkspace.identity.principalId : dummy_pid
        secrets: ['get', 'list']
      }

    ]
  secrets:[
      {
        condition: true
        name: 'corleone'
        value: sqlAdminPassword
      }
    ]
  }
}
