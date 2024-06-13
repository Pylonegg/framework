param ctrlSynapseDeploySparkPool bool

param ctrlStreamIngestionService string
param resourceLocation string
param dataLakeAccountID string
param dataLakeContainerNames array
param eventHubNamespaceName string
param eventHubName string
param eventHubPartitionCount int
param synapseSparkPoolID string
param synapseSparkPoolName string
param synapseWorkspaceID string
var storageEnvironmentDNS = environment().suffixes.storage



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







// == RBAC ============================================================
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


@description('CosmosDB SQL Role Assignment as per: https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac?msclkid=0c60517dac2011ec89f6c50e70ceb530#built-in-role-definitions')
resource r_SynapseSQLRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-10-15' = if (ctrlDeployOperationalDB && ctrlDeployCosmosDB){
  name: '${cosmosDBAccountName}/${guid('d9b6b1c6-7e97-4693-b58a-5d1a567d413f', subscription().subscriptionId, resourceGroup().id)}'
  properties:{
    principalId: r_synapseWorkspace.identity.principalId
    roleDefinitionId: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/sqlRoleDefinitions/${cosmosDBDataContributorRoleID}' // Cosmos DB Built-in Data Contributor
    scope: '${ctrlDeployCosmosDB ? r_cosmosDBAccount.id : ''}/dbs/${cosmosDBDatabaseName}'
  }
}

































//-----------------------------------------------------------------------------------------------------------
// - Virtual Network Integration
//-----------------------------------------------------------------------------------------------------------
//module m_VirtualNetworkIntegration 'platform_vnet_integration.bicep' = if(networkIsolationMode == 'vNet') {
//  name: 'VirtualNetworkIntegration'
//  scope: r_dataPlatformRG
//  dependsOn:[
//    m_vNet
//    m_SynapseDeploy
//    m_PurviewDeploy
//    m_AIServicesDeploy
//    m_StreamingServicesDeploy
//    m_DataLakeDeploy
//  ]
//  params: {
//    ctrlDeployAI                             : ctrlDeployAI
//    ctrlDeployPrivateDNSZones                : ctrlDeployPrivateDNSZones
//    ctrlDeployPurview                        : ctrlDeployPurview
//    ctrlDeployStreaming                      : ctrlDeployStreaming
//    ctrlStreamIngestionService               : ctrlStreamIngestionService
//    ctrlDeployCosmosDB                       : ctrlDeployCosmosDB
//    vNetName                                 : vNetName
//    resourceLocation                         : resourceLocation
//    synapsePrivateLinkHubName                : synapsePrivateLinkHubName
//    subnetID                                 : v_subnetID
//    vNetID                                   : v_vnetID
//    dataLakeAccountID                        : m_DataLakeDeploy.outputs.dataLakeStorageAccountID
//    dataLakeAccountName                      : m_DataLakeDeploy.outputs.dataLakeStorageAccountName
//    keyVaultID                               : m_keyVault.outputs.keyVaultID
//    keyVaultName                             : keyVaultName
//    anomalyDetectorAccountID                 : v_anomalyDetectorAccountID
//    anomalyDetectorAccountName               : v_anomalyDetectorAccountName
//    azureMLContainerRegistryID               : v_azureMLContainerRegistryID
//    azureMLContainerRegistryName             : v_azureMLContainerRegistryName
//    azureMLStorageAccountID                  : v_azureMLStorageAccountID
//    azureMLStorageAccountName                : v_azureMLStorageAccountName
//    azureMLWorkspaceID                       : v_azureMLWorkspaceID
//    azureMLWorkspaceName                     : v_azureMLWorkspaceName
//    eventHubNamespaceID                      : v_eventHubNamespaceID
//    eventHubNamespaceName                    : v_eventHubNamespaceName
//    iotHubID                                 : v_iotHubID
//    iotHubName                               : v_iotHubName
//    purviewAccountID                         : v_purviewAccountID
//    purviewAccountName                       : v_purviewAccountName
//    purviewManagedEventHubNamespaceID        : v_purviewManagedEventHubNamespaceID
//    purviewManagedStorageAccountID           : v_purviewManagedStorageAccountID
//    synapseWorkspaceID                       : v_synapseWorkspaceID
//    synapseWorkspaceName                     : v_synapseWorkspaceName
//    textAnalyticsAccountID                   : v_textAnalyticsAccountID
//    textAnalyticsAccountName                 : v_textAnalyticsAccountName
//    cosmosDBAccountID                        : v_cosmosDBAccountID
//    cosmosDBAccountName                      : v_cosmosDBAccountName
//  }
//}
// 
// 
// //=== OUTPUTS ===============================================================================================
// 
// output synapseArguments string = join([
//   '$networkIsolationMode            ="${networkIsolationMode}"'
//   '$dataLakeAccountName             ="${dataLakeAccountName}"'
//   '$cosmosDBDatabaseName            ="${cosmosDBDatabaseName}"'
//   '$synapseWorkspaceName            ="${v_synapseWorkspaceName}"'
//   '$synapseWorkspaceID              ="${v_synapseWorkspaceID}"'
//   '$keyVaultName                    ="${keyVaultName}"'
//   '$keyVaultID                      ="${v_keyVaultID}"'
//   '$dataLakeAccountID               ="${v_dataLakeAccountID}"'
//   '$uamiPrincipalID                 ="${v_uamiPrincipalID}"'
//   '$azureMLWorkspaceName            ="${v_azureMLWorkspaceName}"'
//   '$textAnalyticsAccountID          ="${v_textAnalyticsAccountID}"'
//   '$textAnalyticsAccountName        ="${v_textAnalyticsAccountName}"'
//   '$textAnalyticsEndpoint           ="${v_textAnalyticsEndpoint}"'
//   '$anomalyDetectorAccountID        ="${v_anomalyDetectorAccountID}"'
//   '$anomalyDetectorAccountName      ="${v_anomalyDetectorAccountName}"'
//   '$anomalyDetectorEndpoint         ="${v_anomalyDetectorEndpoint}"'
//   '$cosmosDBAccountID               ="${v_cosmosDBAccountID}"'
//   '$cosmosDBAccountName             ="${v_cosmosDBAccountName}"'
//   //v_AzMLSynapseLinkedServiceIdentityID
// ], ';')
