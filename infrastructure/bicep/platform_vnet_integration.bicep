param vNetID string
param vNetName string
param subnetID string

param resourceLocation string

param ctrlDeployPrivateDNSZones bool
param ctrlDeployAI bool
param ctrlDeployPurview bool
param ctrlDeployStreaming bool 
param ctrlDeployCosmosDB bool
param ctrlStreamIngestionService string

//Key Vault Params
param keyVaultID string
param keyVaultName string

//Synapse Analytics Params
param synapseWorkspaceID string
param synapseWorkspaceName string
param synapsePrivateLinkHubName string

param dataLakeAccountID string
param dataLakeAccountName string

//Purview Params
param purviewAccountID string
param purviewAccountName string
param purviewManagedStorageAccountID string
param purviewManagedEventHubNamespaceID string

//Event Hub Namespace Params
param eventHubNamespaceID string
param eventHubNamespaceName string

//IoT Hub Params
param iotHubID string
param iotHubName string

//Congnitive Services Params
param textAnalyticsAccountID string
param textAnalyticsAccountName string

param anomalyDetectorAccountID string
param anomalyDetectorAccountName string

//Azure ML Workspace Params
param azureMLStorageAccountID string
param azureMLStorageAccountName string
param azureMLContainerRegistryID string
param azureMLContainerRegistryName string
param azureMLWorkspaceID string
param azureMLWorkspaceName string

//CosmosDB account params
param cosmosDBAccountID string
param cosmosDBAccountName string

var storageEnvironmentDNS = environment().suffixes.storage


//Deploy Private DNS Zones required to suppport Private Endpoints
module m_DeployPrivateDNSZones 'private_dns_zones.bicep' = if (ctrlDeployPrivateDNSZones == true){
  name: 'DeployPrivateDNSZones'
  params: {
    vNetID: vNetID
    vNetName: vNetName
    ctrlDeployAI: ctrlDeployAI
    ctrlDeployPurview: ctrlDeployPurview
    ctrlDeployStreaming: ctrlDeployStreaming
    ctrlDeployCosmosDB: ctrlDeployCosmosDB
  }
}

//==================================================================================================================

//Private DNS Zone References
resource r_privateDNSZoneStorageDFS 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.dfs.${storageEnvironmentDNS}'
}

resource r_privateDNSZoneKeyVault 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.vaultcore.azure.net'
}

resource r_privateDNSZoneBlob 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.blob.${storageEnvironmentDNS}'
}

resource r_privateDNSZoneStorageQueue 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.queue.${storageEnvironmentDNS}'
}

resource r_privateDNSZoneServiceBus 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.servicebus.windows.net'
}

resource r_privateDNSZonePurviewAccount 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.purview.azure.com'
}

resource r_privateDNSZonePurviewPortal 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.purviewstudio.azure.com'
}

resource r_privateDNSZoneIoTHub 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.azure-devices.net'
}


resource r_privateDNSZoneStorageBlob 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.blob.${storageEnvironmentDNS}'
} 

resource r_privateDNSZoneStorageFile 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.file.${storageEnvironmentDNS}'
} 

//Private DNS Zone for Azure Container Registry
resource r_privateDNSZoneACR 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.azurecr.io'
} 

//Azure Machine Learning API DNS Zone: privatelink.api.azureml.ms
resource r_privateDNSZoneAzureMLAPI 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.api.azureml.ms'
}
//Azure Machine Learning Notebooks DNS Zone: privatelink.notebooks.azure.net
resource r_privateDNSZoneAzureMLNotebooks 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.notebooks.azure.net'
}

//Azure Cognitive Services DNS Zone: privatelink.cognitiveservices.azure.com
resource r_privateDNSZoneCognitiveService 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.cognitiveservices.azure.com'
}

//Private DNS Zones required for Synapse Private Link
resource r_privateDNSZoneSynapseSQL 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.sql.azuresynapse.net'
}

//Private DNS Zones required for Synapse Private Link
resource r_privateDNSZoneSynapseDev 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.dev.azuresynapse.net'
}

//Private DNS Zones required for Synapse Private Link
resource r_privateDNSZoneSynapseWeb 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.azuresynapse.net'
}

//Private DNS Zones required for CosmosDB SQL
resource r_privateDNSZoneCosmosDBSQL 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.documents.azure.com'
}

//Private DNS Zones required for CosmosDB Analytics
resource r_privateDNSZoneCosmosDBAnalytical 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.analytics.cosmos.azure.com'
}

//==================================================================================================================

//Azure Synapse Private Link Hub
resource r_synapsePrivateLinkhub 'Microsoft.Synapse/privateLinkHubs@2021-03-01' = {
  name: synapsePrivateLinkHubName
  location:resourceLocation
}

//Private Endpoint for Synapse SQL
module m_synapseSQLPrivateLink 'private_endpoint.bicep' = {
  name: 'SynapseSQLPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'Sql'
    privateEndpoitName: '${synapseWorkspaceName}-sql'
    privateLinkServiceId: synapseWorkspaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-sql-azuresynapse-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneSynapseSQL.id
        }
      }
    ]
  }
}

//Private Endpoint for Synapse SQL Serverless
module m_synapseSQLServerlessPrivateLink 'private_endpoint.bicep' = {
  name: 'SynapseSQLServerlessPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'SqlOnDemand'
    privateEndpoitName: '${synapseWorkspaceName}-sqlserverless'
    privateLinkServiceId: synapseWorkspaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name: 'privatelink-sql-azuresynapse-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneSynapseSQL.id
        }
      }
    ]
  }
}

//Private Endpoint for Synapse Dev
module m_synapseDevPrivateLink 'private_endpoint.bicep' = {
  name: 'SynapseDevPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'Dev'
    privateEndpoitName: '${synapseWorkspaceName}-dev'
    privateLinkServiceId: synapseWorkspaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-web-azuresynapse-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneSynapseDev.id
        }
      }
    ]
  }
}

//Private Endpoint for Synapse Web
module m_synapseWebPrivateLink 'private_endpoint.bicep' = {
  name: 'SynapseWebPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'Web'
    privateEndpoitName: '${synapseWorkspaceName}-web'
    privateLinkServiceId: r_synapsePrivateLinkhub.id
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-dev-azuresynapse-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneSynapseWeb.id
        }
      }
    ]
  }
}

//Key Vault Private Endpoint
module m_keyVaultPrivateLink 'private_endpoint.bicep' = {
  name: 'KeyVaultPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'vault'
    privateEndpoitName: keyVaultName
    privateLinkServiceId: keyVaultID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup:ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-vaultcore-azure-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneKeyVault.id
        }
      }
    ]
  }
}


//Private Link for Raw Data Lake DFS
module m_dataLakePrivateLinkDFS 'private_endpoint.bicep' = {
  name: 'dataLakePrivateLinkDFS'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'dfs'
    privateEndpoitName: '${dataLakeAccountName}-dfs'
    privateLinkServiceId: dataLakeAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-dfs-core-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneStorageDFS.id
        }
      }
    ]
  }
}


module m_purviewBlobPrivateLink 'private_endpoint.bicep' = if(ctrlDeployPurview == true) {
  name: 'PurviewBlobPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'blob'
    privateEndpoitName: '${purviewAccountName}-blob'
    privateLinkServiceId: purviewManagedStorageAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-blob-core-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneBlob.id
        }
      }
    ]
  }
}

module m_purviewQueuePrivateLink 'private_endpoint.bicep' = if(ctrlDeployPurview == true) {
  name: 'PurviewQueuePrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'queue'
    privateEndpoitName: '${purviewAccountName}-queue'
    privateLinkServiceId: purviewManagedStorageAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs:[
      {
        name:'privatelink-queue-core-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneStorageQueue.id
        }
      }
    ]
  }
}

module m_purviewEventHubPrivateLink 'private_endpoint.bicep' = if(ctrlDeployPurview == true) {
  name: 'PurviewEventHubPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'namespace'
    privateEndpoitName: '${purviewAccountName}-namespace'
    privateLinkServiceId: purviewManagedEventHubNamespaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-servicebus-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneServiceBus.id
        }
      }
    ]
  }
}

module m_purviewAccountPrivateLink 'private_endpoint.bicep' = if(ctrlDeployPurview == true) {
  name: 'PurviewAccountPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'account'
    privateEndpoitName: '${purviewAccountName}-account'
    privateLinkServiceId: purviewAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-purview-azure-com-account'
        properties:{
          privateDnsZoneId: r_privateDNSZonePurviewAccount.id
        }
      }
    ]
  }
}

module m_purviewPortalPrivateLink 'private_endpoint.bicep' = if(ctrlDeployPurview == true) {
  name: 'PurviewPortalPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'portal'
    privateEndpoitName: '${purviewAccountName}-portal'
    privateLinkServiceId: purviewAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-purview-azure-com-portal'
        properties:{
          privateDnsZoneId: r_privateDNSZonePurviewPortal.id
        }
      }
    ]
  }
}

module m_eventHubPrivateLink 'private_endpoint.bicep' = if(ctrlDeployStreaming == true && ctrlStreamIngestionService == 'eventhub') {
  name: 'EventHubPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'namespace'
    privateEndpoitName: '${eventHubNamespaceName}-namespace'
    privateLinkServiceId: eventHubNamespaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-servicebus-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneServiceBus.id
        }
      }
    ]
  }
}

module m_iotHubPrivateLink 'private_endpoint.bicep' = if(ctrlDeployStreaming == true && ctrlStreamIngestionService == 'iothub') {
  name: 'IoTHubPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'iotHub'
    privateEndpoitName: '${iotHubName}-iotHub'
    privateLinkServiceId: iotHubID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-azure-devices-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneIoTHub.id
        }
      }
    ]
  }
}

//Private Link for Text Analytics
module m_textAnalyticsPrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true){
  name: 'TextAnalyticsPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'account'
    privateEndpoitName: '${textAnalyticsAccountName}-account'
    privateLinkServiceId: textAnalyticsAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs:[
      {
        name:'privatelink-cognitiveservices-azure-com'
        properties:{
          privateDnsZoneId: r_privateDNSZoneCognitiveService.id
        }
      }
    ]
  }
}

//Private Link for Anomaly Detector
module m_anomalyDetectorPrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true){
  name: 'AnomalyDetectorPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'account'
    privateEndpoitName: '${anomalyDetectorAccountName}-account'
    privateLinkServiceId: anomalyDetectorAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs:[
      {
        name:'privatelink-cognitiveservices-azure-com'
        properties:{
          privateDnsZoneId: r_privateDNSZoneCognitiveService.id
        }
      }
    ]
  }
}

//Private Link for Storage Account Blob Service
module m_dataLakeStorageAccountBlobPrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true){
  name: 'AzMLStorageAccountBlobPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'blob'
    privateEndpoitName: '${azureMLStorageAccountName}-blob'
    privateLinkServiceId: azureMLStorageAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs:[
      {
        name:'privatelink-blob-core-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneStorageBlob.id
        }
      }
    ]
  }
}

//Private Link for Storage Account File Service
module m_dataLakeStorageAccountFilePrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true){
  name: 'AzMLStorageAccountFilePrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'file'
    privateEndpoitName: '${azureMLStorageAccountName}-file'
    privateLinkServiceId: azureMLStorageAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-file-core-windows-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneStorageFile.id
        }
      }
    ]
  }
}

//Private Link for CosmosDB SQL subsystem
module m_cosmosDBSQLPrivateLink 'private_endpoint.bicep' = if(ctrlDeployCosmosDB == true){
  name: 'CosmosDBSQLPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'Sql'
    privateEndpoitName: '${cosmosDBAccountName}-sql'
    privateLinkServiceId: cosmosDBAccountID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-documents-azure-com'
        properties:{
          privateDnsZoneId: r_privateDNSZoneCosmosDBSQL.id
        }
      }
    ]
  }
}

//Private Link for Azure Container Registry
module m_azureMLContainerRegistryPrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true){
  name: 'AzureMLContainerRegistryPrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'registry'
    privateEndpoitName: '${azureMLContainerRegistryName}-registry'
    privateLinkServiceId: azureMLContainerRegistryID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:'privatelink-azurecr-io'
        properties:{
          privateDnsZoneId: r_privateDNSZoneACR.id
        }
      }
    ]
  }
}

module m_azureMLWorkspacePrivateLink 'private_endpoint.bicep' = if(ctrlDeployAI == true) {
  name: 'AzureMLWorkspacePrivateLink'
  dependsOn:[
    m_DeployPrivateDNSZones
  ]
  params: {
    groupID: 'amlworkspace'
    privateDNSZoneConfigs: [
      {
        name:'privatelink-api-azureml-ms'
        properties:{
          privateDnsZoneId: r_privateDNSZoneAzureMLAPI.id
        }
      }
      {
        name:'privatelink-notebooks-azure-net'
        properties:{
          privateDnsZoneId: r_privateDNSZoneAzureMLNotebooks.id
        }
      }
    ]
    privateEndpoitName: '${azureMLWorkspaceName}-amlworkspace'
    privateLinkServiceId: azureMLWorkspaceID
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
  }
}
