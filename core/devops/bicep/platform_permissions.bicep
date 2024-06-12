param ctrlDeploySynapse             bool
param ctrlDeployPurview             bool
param ctrlDeployAI                  bool
param ctrlDeployDataShare           bool 
param ctrlDeployStreaming           bool
param ctrlDeployOperationalDB       bool
param ctrlDeployCosmosDB            bool
param ctrlStreamingIngestionService string

param cosmosDBAccountName           string
param cosmosDBDatabaseName          string
param azureMLWorkspaceName          string
param textAnalyticsAccountName      string
param anomalyDetectorAccountName    string
param keyVaultName string
param dataLakeAccountName           string
param purviewAccountName            string
param synapseWorkspaceName          string

param UAMIPrincipalID string
param dataShareAccountPrincipalID string
param streamAnalyticsIdentityPrincipalID string
param iotHubPrincipalID string


//==============================================================================================================
//== Get Existing Resources                  ===================================================================
//==============================================================================================================
resource r_dataLakeStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: dataLakeAccountName
}
resource r_purviewAccount 'Microsoft.Purview/accounts@2021-07-01' existing = {
  name: purviewAccountName
}
resource r_azureMLWorkspace 'Microsoft.MachineLearningServices/workspaces@2021-07-01' existing = {
  name: azureMLWorkspaceName
}
resource r_azureMLSynapseLinkedService 'Microsoft.MachineLearningServices/workspaces/linkedServices@2020-09-01-preview' existing = {
  parent: r_azureMLWorkspace
  name: synapseWorkspaceName
}
resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName
}

@description('Lookup cosmos db account')
resource r_cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-11-15-preview' existing = {
  name: cosmosDBAccountName
}
@description('Lookup ')
resource r_textAnalytics 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: textAnalyticsAccountName
}
@description('Lookup Anomaly Detector account')
resource r_anomalyDetector 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: anomalyDetectorAccountName
}

//==============================================================================================================
//== KEYVAULT                                ===================================================================
//==============================================================================================================
module m_keyvaultPermissions 'modules/keyvault_permissions.bicep' = {
  name: '${keyVaultName}Permissions'
  params:{
    keyVaultName: keyVaultName
    policies: [
      {
        condition: true
        principalId: '3809d824-2e13-4883-a19c-dfd86ec9e012'
        secrets: ['all']
      }
      {
        condition: true
        principalId: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
        secrets: ['all']
      }
      //{
      //  condition: ctrlDeploySynapse
      //  principalId: ctrlDeploySynapse ? r_synapseWorkspace.identity.principalId : ''
      //  secrets: ['get', 'list']
      //}
      //{
      //  condition: ctrlDeployPurview
      //  principalId: ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewIdentityPrincipalID :''
      //  secrets: ['get', 'list']
      //}
      //  Conditions do not work here implement an alternative!!
    ]
  secrets:[
      {
        condition: ctrlDeployAI
        name: textAnalyticsAccountName
        value: ctrlDeployAI ? r_textAnalytics.listKeys().key1 : ''
      }
      {
        condition: ctrlDeployAI
        name: anomalyDetectorAccountName
        value: ctrlDeployAI ? r_anomalyDetector.listKeys().key1 : ''
      }
      {
        condition: ctrlDeployCosmosDB
        name: cosmosDBAccountName
        value: ctrlDeployCosmosDB ? r_cosmosDBAccount.listConnectionStrings().connectionStrings[0].connectionString : ''
      }
      {
        condition: false
        name: 'sqlAdmin'
        value: 'sqlAdminPassword'
      }
    ]
  }
}

//==============================================================================================================
// == ROLE BASED ACCESS CONTROL                            =====================================================
//==============================================================================================================
var azureRBACStorageBlobDataReaderRoleID      = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'  
var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'  
var azureRBACContributorRoleID                = 'b24988ac-6180-42a0-ab88-20f7382dd24c'  
var azureRBACOwnerRoleID                      = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'  
var azureRBACReaderRoleID                     = 'acdd72a7-3385-48ef-bd42-f606fba81ae7' 
var cosmosDBDataContributorRoleID             = '00000000-0000-0000-0000-000000000002' 

// -- DataLake ==============================================================================================
@description('Assign Storage Blob Data Reader Role to Azure Data Share in the Raw Data Lake Account as per https://docs.microsoft.com/en-us/azure/data-share/concepts-roles-permissions')
resource r_azureDataShareStorageBlobDataReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployDataShare == true) {
  name: guid('bbcbc4e3-e2bb-4cde-97c8-02636e6f1632', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataReaderRoleID)
    principalId: ctrlDeployDataShare ? dataShareAccountPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Data Contributor Role to Azure Stream Analytics in the Raw Data Lake Account')
resource r_streamAnalyticsStorageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployStreaming == true) {
  name: guid('5411c956-6918-4e05-b23b-a8260d63799c', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: ctrlDeployStreaming ? streamAnalyticsIdentityPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Data Contributor Role to IoTHub in the Raw Data Lake Account')
resource r_iotHubStorageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployStreaming == true && ctrlStreamingIngestionService == 'iothub') {
  name: guid('67c87aaa-7c65-4ca0-96bd-cc5ae82bd2f4', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: (ctrlDeployStreaming == true && ctrlStreamingIngestionService == 'iothub') ? iotHubPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Data Reader Role to Azure ML MSI in the Raw Data Lake Account as per https://docs.microsoft.com/en-us/azure/machine-learning/how-to-identity-based-data-access')
resource r_azureMLStorageBlobDataReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployAI == true && ctrlDeploySynapse == true) {
  name: guid('be61ada6-1a00-47ff-8027-81b1b6c7b82a', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataReaderRoleID)
    principalId: ctrlDeployAI ? r_azureMLSynapseLinkedService.identity.principalId : ''
    principalType:'ServicePrincipal'
  }
}

// -- Synapse ==============================================================================================
@description('Assign Owner Role to UAMI in the Synapse Workspace. UAMI needs to be Owner so it can assign itself as Synapse Admin and create resources in the Data Plane.')
resource r_synapseWorkspaceOwner 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeploySynapse == true) {
  name: guid('cbe28037-09a6-4b35-a751-8dfd3f03f59d', subscription().subscriptionId, resourceGroup().id)
  scope: r_synapseWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACOwnerRoleID)
    principalId: UAMIPrincipalID
    principalType:'ServicePrincipal'
  }
}

@description('Assign Purview the Reader role in the Synapse Workspace as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace#authentication-for-enumerating-serverless-sql-database-resources')
resource r_purviewSynapseReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployPurview == true) {
  name: guid('f4191dd4-2d87-47c0-9f38-d3d24cc13f5c', subscription().subscriptionId, resourceGroup().id)
  scope: r_synapseWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACReaderRoleID)
    principalId: ctrlDeployPurview ? r_purviewAccount.identity.principalId : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Data Contributor Role to Synapse Workspace in the Raw Data Lake Account as per https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-grant-workspace-managed-identity-permissions#grant-the-managed-identity-permissions-to-adls-gen2-storage-account')
resource r_synapseWorkspaceStorageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeploySynapse == true) {
  name: guid('a1fb98aa-4c53-4a4d-951f-3ac730a27a5b', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: ctrlDeploySynapse ? r_synapseWorkspace.identity.principalId : ''
    principalType:'ServicePrincipal'
  }
}

// -- Others ==============================================================================================
@description('Deployment script UAMI is set as Resource Group owner so it can have authorisation to perform post deployment tasks')
resource r_deploymentScriptUAMIRGOwner 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('139d07dd-a26c-4b29-9619-8f70ea215795', subscription().subscriptionId, resourceGroup().id)
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACOwnerRoleID)
    principalId: UAMIPrincipalID
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Reader Role to Purview MSI in the Resource Group as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace')
resource r_purviewRGStorageBlobDataReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployPurview == true) {
  name: guid('3f2019ca-ce91-4153-920a-19e6dae191a8', subscription().subscriptionId, resourceGroup().id)
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataReaderRoleID)
    principalId: ctrlDeployPurview ? r_purviewAccount.identity.principalId  : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Reader Role to Purview MSI in the Resource Group as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace')
resource r_purviewRGReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = if (ctrlDeployPurview == true) {
  name: guid(resourceGroup().name, purviewAccountName, 'Reader')
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACReaderRoleID)
    principalId: ctrlDeployPurview ? r_purviewAccount.identity.principalId  : ''
    principalType:'ServicePrincipal'
  }
}

@description('Azure Synaspe MSI needs to have Contributor permissions in the Azure ML workspace.')
resource r_synapseAzureMLContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployAI == true && ctrlDeploySynapse == true) {
  name: guid('dfe59492-dd91-45d5-804a-ebf18e820dcc', subscription().subscriptionId, resourceGroup().id)
  scope: r_azureMLWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACContributorRoleID)
    principalId: ctrlDeploySynapse ? r_synapseWorkspace.identity.principalId : ''
    principalType:'ServicePrincipal'
  }
}

@description('CosmosDB SQL Role Assignment as per: https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac?msclkid=0c60517dac2011ec89f6c50e70ceb530#built-in-role-definitions')
resource r_SynapseSQLRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-10-15' = if (ctrlDeployOperationalDB && ctrlDeployCosmosDB){
  name: '${cosmosDBAccountName}/${guid('d9b6b1c6-7e97-4693-b58a-5d1a567d413f', subscription().subscriptionId, resourceGroup().id)}'
  properties:{
    principalId: ctrlDeploySynapse ? r_synapseWorkspace.identity.principalId : ''
    roleDefinitionId: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/sqlRoleDefinitions/${cosmosDBDataContributorRoleID}' // Cosmos DB Built-in Data Contributor
    scope: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/dbs/${cosmosDBDatabaseName}'
  }
}





//==============================================================================================================
// -- OUTPUTS ==============================================================================================
//==============================================================================================================
output azureMLSynapseLinkedServicePrincipalID string = ctrlDeployAI ? r_azureMLSynapseLinkedService.identity.principalId : ''
