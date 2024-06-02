param ctrlDeploySynapse bool
param ctrlDeployPurview bool
param ctrlDeployAI bool
param ctrlDeployDataShare bool 
param ctrlDeployStreaming bool
param ctrlDeployOperationalDB bool
param ctrlDeployCosmosDB bool
param ctrlSynapseDeploySparkPool bool

param dataLakeAccountName string
param azureMLWorkspaceName string
param purviewAccountName string
param synapseWorkspaceName string
param synapseWorkspaceIdentityPrincipalID string
param purviewIdentityPrincipalID string
param UAMIPrincipalID string
param dataShareAccountPrincipalID string
param streamAnalyticsIdentityPrincipalID string
param ctrlStreamingIngestionService string
param iotHubPrincipalID string

param databaseName string
param serverName string
param sqlAdminPassword string
param cosmosDBAccountName string
param cosmosDBDatabaseName string


param ctrlStreamIngestionService string
param resourceLocation string
param keyVaultName string
param dataLakeAccountID string
param dataLakeContainerNames array
param eventHubNamespaceName string
param eventHubName string
param eventHubPartitionCount int
param textAnalyticsAccountName string
param anomalyDetectorAccountName string
param synapseSparkPoolID string
param synapseSparkPoolName string
param synapseWorkspaceID string

var storageEnvironmentDNS = environment().suffixes.storage

var azureRBACStorageBlobDataReaderRoleID      = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'  // Storage Blob Data Reader Role: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-reader
var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'  // Storage Blob Data Contributor Role: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor
var azureRBACContributorRoleID                = 'b24988ac-6180-42a0-ab88-20f7382dd24c'  // Contributor: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor
var azureRBACOwnerRoleID                      = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'  // Owner: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner
var azureRBACReaderRoleID                     = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'  // Reader: https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#reader
var cosmosDBDataContributorRoleID             = '00000000-0000-0000-0000-000000000002'  // Cosmos DB Built-in Data Contributor: https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac#built-in-role-definitions

//Reference existing resources for permission assignment scope
resource r_dataLakeStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: dataLakeAccountName
}
// resource r_purviewAccount 'Microsoft.Purview/accounts@2021-07-01' existing = {
//   name: purviewAccountName
// }


//------------------------------------------------------------------------------------------
// Keyvault Access Policy
//------------------------------------------------------------------------------------------
@description('Set Keyvault Access Policy for Service Connection')
module m_KeyVaultServiceConnectionAccessPolicy 'modules/keyvault_policy.bicep' = {
  name: 'KeyVaultSPAccessPolicy'
  params: {
    keyVaultName: keyVaultName
    PrincipalID: '3809d824-2e13-4883-a19c-dfd86ec9e012'
    secrets: ['all']
  }
}

@description('Set Keyvault Access Policy for Active Directory Group')
module m_KeyVaultAAGroupAccessPolicy 'modules/keyvault_policy.bicep' = {
  name: 'KeyVaultAADAccessPolicy'
  params: {
    keyVaultName: keyVaultName
    PrincipalID: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
    secrets: ['all']
  }
}

@description('Set Keyvault Access Policy for Synapse Workspace')
module m_KeyVaultSynapseAccessPolicy 'modules/keyvault_policy.bicep' = if (ctrlDeploySynapse == true) {
  name: 'KeyVaultSynapseAccessPolicy'
  params: {
    keyVaultName: keyVaultName
    PrincipalID: synapseWorkspaceIdentityPrincipalID
    secrets: ['get', 'list']

  }
}

@description('Set Keyvault Access Policy for Purview')
module m_KeyVaultPurviewAccessPolicy 'modules/keyvault_policy.bicep' = if (ctrlDeployPurview == true) {
  name: 'KeyVaultPurviewAccessPolicy'
  dependsOn:[
    m_KeyVaultSynapseAccessPolicy
  ]
  params:{
    keyVaultName: keyVaultName
    PrincipalID: purviewIdentityPrincipalID
    secrets: ['get', 'list']
  }
}


//------------------------------------------------------------------------------------------
// Add Account Keys to Keyvault
//------------------------------------------------------------------------------------------
//Reference existing Key Vault created by CoreServicesDeploy.bicep
resource r_keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: keyVaultName
}

resource db_secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: r_keyVault
  name: 'sqlAdmin'
  properties: {
    value: sqlAdminPassword
  }
}


@description('Lookup ')
resource r_textAnalytics 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: textAnalyticsAccountName
}
@description('Add ? key to keyvault')
resource r_textAnalyticsAccountKey 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if(ctrlDeployAI == true) {
  name:'${textAnalyticsAccountName}-Key'
  parent: r_keyVault
  properties:{
    value:  ctrlDeployAI ? listKeys(r_textAnalytics.id, r_textAnalytics.apiVersion).key1 : ''
  }
}


@description('Lookup Anomaly Detector account')
resource r_anomalyDetector 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: anomalyDetectorAccountName
}
@description('Add Anomaly Detector account key to keyvault')
resource r_anomalyDetectorAccountKey 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if(ctrlDeployAI == true) {
  name:'${anomalyDetectorAccountName}-Key'
  parent: r_keyVault
  properties:{
    value: ctrlDeployAI ? listKeys(r_anomalyDetector.id, r_anomalyDetector.apiVersion).key1 : ''
  }
}


@description('Lookup cosmos db account')
resource r_cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-11-15-preview' existing = {
  name: cosmosDBAccountName
}
@description('Add cosmos db connection string to keyvault')
resource r_cosmosDBConnectionString 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if(ctrlDeployCosmosDB == true) {
  name:'${cosmosDBAccountName}-Key'
  parent: r_keyVault
  properties:{
    value:  ctrlDeployCosmosDB ? listConnectionStrings(r_cosmosDBAccount.id, r_cosmosDBAccount.apiVersion).connectionStrings[0].connectionString : ''
  }
}


//------------------------------------------------------------------------------------------
// RBAC
//------------------------------------------------------------------------------------------
// Get resource IDs
resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' existing = {
  name: serverName
  scope: resourceGroup()
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-05-01-preview' existing = {
  parent: sqlServer
  name: databaseName
}

// SQL Database Contributor role definition ID
var sqlDbContributorRoleId = 'f78a3032-8c2a-43f0-883d-29e6b73c06db'

// Assign SQL Database Contributor role to the managed identity
resource r_sqlDbRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(sqlDatabase.id, UAMIPrincipalID, sqlDbContributorRoleId)
  scope: sqlDatabase
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', sqlDbContributorRoleId)
    principalId: UAMIPrincipalID
    principalType: 'ServicePrincipal'
  }
}


@description('Deployment script UAMI is set as Resource Group owner so it can have authorisation to perform post deployment tasks')
resource r_deploymentScriptUAMIRGOwner 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('139d07dd-a26c-4b29-9619-8f70ea215795', subscription().subscriptionId, resourceGroup().id)
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACOwnerRoleID)
    principalId: UAMIPrincipalID
    principalType:'ServicePrincipal'
  }
}


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


@description('Assign Storage Blob Data Contributor Role to Synapse Workspace in the Raw Data Lake Account as per https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-grant-workspace-managed-identity-permissions#grant-the-managed-identity-permissions-to-adls-gen2-storage-account')
resource r_synapseWorkspaceStorageBlobDataContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeploySynapse == true) {
  name: guid('a1fb98aa-4c53-4a4d-951f-3ac730a27a5b', subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: ctrlDeploySynapse ? synapseWorkspaceIdentityPrincipalID : '' 
    principalType:'ServicePrincipal'
  }
}


@description('Assign Storage Blob Reader Role to Purview MSI in the Resource Group as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace')
resource r_purviewRGStorageBlobDataReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if (ctrlDeployPurview == true) {
  name: guid('3f2019ca-ce91-4153-920a-19e6dae191a8', subscription().subscriptionId, resourceGroup().id)
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataReaderRoleID)
    principalId: ctrlDeployPurview ? purviewIdentityPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}


@description('Assign Reader Role to Purview MSI in the Resource Group as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace')
resource r_purviewRGReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = if (ctrlDeployPurview == true) {
  name: guid(resourceGroup().name, purviewAccountName, 'Reader')
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACReaderRoleID)
    principalId: ctrlDeployPurview ? purviewIdentityPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}


@description('Azure Synaspe MSI needs to have Contributor permissions in the Azure ML workspace.')
//https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/quickstart-integrate-azure-machine-learning#give-msi-permission-to-the-azure-ml-workspace
resource r_synapseAzureMLContributor 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployAI == true && ctrlDeploySynapse == true) {
  name: guid('dfe59492-dd91-45d5-804a-ebf18e820dcc', subscription().subscriptionId, resourceGroup().id)
  scope: r_azureMLWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACContributorRoleID)
    principalId: ctrlDeploySynapse ? synapseWorkspaceIdentityPrincipalID : '' 
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
//https://docs.microsoft.com/en-us/azure/stream-analytics/blob-output-managed-identity#grant-access-via-the-azure-portal
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


@description('Assign Purview the Reader role in the Synapse Workspace as per https://docs.microsoft.com/en-us/azure/purview/register-scan-synapse-workspace#authentication-for-enumerating-serverless-sql-database-resources')
resource r_purviewSynapseReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = if(ctrlDeployPurview == true) {
  name: guid('f4191dd4-2d87-47c0-9f38-d3d24cc13f5c', subscription().subscriptionId, resourceGroup().id)
  scope: r_synapseWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACReaderRoleID)
    principalId: ctrlDeployPurview ? purviewIdentityPrincipalID : ''
    principalType:'ServicePrincipal'
  }
}


@description('CosmosDB SQL Role Assignment as per: https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac?msclkid=0c60517dac2011ec89f6c50e70ceb530#built-in-role-definitions')
resource r_SynapseSQLRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-10-15' = if (ctrlDeployOperationalDB && ctrlDeployCosmosDB){
  name: '${cosmosDBAccountName}/${guid('d9b6b1c6-7e97-4693-b58a-5d1a567d413f', subscription().subscriptionId, resourceGroup().id)}'
  properties:{
    principalId: r_synapseWorkspace.identity.principalId
    roleDefinitionId: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/sqlRoleDefinitions/${cosmosDBDataContributorRoleID}' // Cosmos DB Built-in Data Contributor
    scope: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/dbs/${cosmosDBDatabaseName}'
  }
}




//------------------------------------------------------------------------------------------
// MISC for now.
//------------------------------------------------------------------------------------------


resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseWorkspaceName

  resource r_workspaceAADAdmin 'administrators' = {
    name:'activeDirectory'
    properties:{
      administratorType:'ActiveDirectory'
      tenantId: subscription().tenantId
      sid: UAMIPrincipalID
    }
  }
}

//Azure Machine Learning Datastores
resource r_azureMLWorkspace 'Microsoft.MachineLearningServices/workspaces@2021-07-01' existing = {
  name: azureMLWorkspaceName

  //Data Lake Datastores
  resource r_azureMLRawDataLakeStores 'datastores@2021-03-01-preview' = [for containerName in dataLakeContainerNames: if(ctrlDeployAI == true) {
    name: '${dataLakeAccountName}_${containerName}'
    properties: {
      contents: {
        contentsType:'AzureDataLakeGen2'
        accountName: dataLakeAccountName
        containerName: containerName
        credentials: {
          credentialsType: 'None'
        }
        endpoint: storageEnvironmentDNS
        protocol: 'https'
      }
    }
  }]
}

resource r_azureMLSynapseSparkCompute 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if(ctrlDeployAI == true && ctrlSynapseDeploySparkPool == true) {
  parent: r_azureMLWorkspace
  name: synapseSparkPoolName
  location: resourceLocation
  properties:{
    computeType:'SynapseSpark'
    resourceId: ctrlSynapseDeploySparkPool ? synapseSparkPoolID : ''
  }
}

resource r_azureMLSynapseLinkedService 'Microsoft.MachineLearningServices/workspaces/linkedServices@2020-09-01-preview' = if(ctrlDeployAI == true) {
  parent: r_azureMLWorkspace
  name: synapseWorkspaceName
  location: resourceLocation
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    linkedServiceResourceId: synapseWorkspaceID
  }
}

//Event Hub Capture
resource r_eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: eventHubNamespaceName

  resource r_eventHub 'eventhubs' = if(ctrlDeployStreaming == true && ctrlStreamIngestionService == 'eventhub') {
    name: eventHubName
    properties:{
      messageRetentionInDays:1
      partitionCount:eventHubPartitionCount
      captureDescription:{
        enabled:true
        skipEmptyArchives: true
        encoding: 'Avro'
        intervalInSeconds: 300
        sizeLimitInBytes: 314572800
        destination: {
          name: 'EventHubArchive.AzureBlockBlob'
          properties: {
            storageAccountResourceId: dataLakeAccountID
            blobContainer: 'raw'
            archiveNameFormat: '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
          }
        }
      }
    }
  }
}

output azureMLSynapseLinkedServicePrincipalID string = ctrlDeployAI ? r_azureMLSynapseLinkedService.identity.principalId : ''
