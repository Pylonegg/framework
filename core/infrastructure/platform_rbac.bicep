param ctrlDeploySynapse                   bool
param ctrlDeployPurview                   bool
param ctrlDeployDataShare                 bool 
param ctrlDeployStreaming                 bool
param ctrlStreamingIngestionService       string

param dataLakeAccountName                 string
param purviewAccountName                  string
param synapseWorkspaceName                string
param dataShareAccountName                string
param streamAnalyticsJobName              string
param UAMIPrincipalID                     string
param iotHubPrincipalID                   string

var azureRBACStorageBlobDataReaderRoleID      = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'  
var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'  
var azureRBACContributorRoleID                = 'b24988ac-6180-42a0-ab88-20f7382dd24c'  
var azureRBACOwnerRoleID                      = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'  
var azureRBACReaderRoleID                     = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

//== Lookup  Resources                  ===================================================================
resource r_dataLakeStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: dataLakeAccountName
}
resource r_purviewAccount 'Microsoft.Purview/accounts@2021-07-01' existing = {
  name: purviewAccountName
}
resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName
}

resource r_dataShareAccount 'Microsoft.DataShare/accounts@2020-09-01' existing = {
  name: dataShareAccountName
}
resource r_streamAnalytics 'Microsoft.StreamAnalytics/streamingjobs@2020-03-01' existing = {
  name: streamAnalyticsJobName
}

// -- DataLake ==============================================================================================
@description('Assign Storage Blob Data Reader Role to Azure Data Share in the Raw Data Lake Account as per https://docs.microsoft.com/en-us/azure/data-share/concepts-roles-permissions')
resource r_azureDataShareStorageBlobDataReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployDataShare == true) {
  name: guid('bbcbc4e3-e2bb-4cde-97c8-02636e6f1632', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataReaderRoleID)
    principalId: ctrlDeployDataShare ? r_dataShareAccount.identity.principalId : ''
    principalType:'ServicePrincipal'
  }
}

@description('Assign Storage Blob Data Contributor Role to Azure Stream Analytics in the Raw Data Lake Account')
resource r_streamAnalyticsStorageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployStreaming == true) {
  name: guid('5411c956-6918-4e05-b23b-a8260d63799c', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: ctrlDeployStreaming ? r_streamAnalytics.identity.principalId : ''
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
resource r_purviewSynapseReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployPurview == true && ctrlDeploySynapse == true) {
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
