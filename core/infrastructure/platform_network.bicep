param vNetID string
param vNetName string
param subnetID string

param resourceLocation string

param ctrlDeploySynapse bool
param ctrlDeployPrivateDNSZones bool
param ctrlDeployPurview bool
param ctrlDeployStreaming bool
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

var environmentStorageDNS = environment().suffixes.storage

//==================================================================================================================
var dnsZones = [
  {
    condition: true
    name: 'PrivateDNSZoneStorageDFS'
    dnsZoneName: 'privatelink.dfs.${environmentStorageDNS}'
  }
  {
    condition: ctrlDeployPurview
    name: 'PrivateDNSZoneStorageQueue'
    dnsZoneName: 'privatelink.queue.${environmentStorageDNS}'
  }
  {
    condition: true
    name: 'PrivateDNSZoneSynapseSQL'
    dnsZoneName: 'privatelink.sql.azuresynapse.net'
  }
  {
    condition: true
    name: 'PrivateDNSZoneSynapseDev'
    dnsZoneName: 'privatelink.dev.azuresynapse.net'
  }
  {
    condition: true
    name: 'PrivateDNSZoneSynapseWeb'
    dnsZoneName: 'privatelink.azuresynapse.net'
  }
  {
    condition: true
    name: 'PrivateDNSZoneKeyVault'
    dnsZoneName: 'privatelink.vaultcore.azure.net'
  }
  {
    condition: true
    name: 'PrivateDNSZonePurviewServiceBus'
    dnsZoneName: 'privatelink.servicebus.windows.net'
  }
  {
    condition: ctrlDeployPurview
    name: 'PrivateDNSZonePurviewAccount'
    dnsZoneName: 'privatelink.purview.azure.com'
  }
  {
    condition: ctrlDeployPurview
    name: 'PrivateDNSZonePurviewAccount'
    dnsZoneName: 'privatelink.purview.azure.com'
  }
  {
    condition: ctrlDeployPurview
    name: 'PrivateDNSZonePurviewPortal'
    dnsZoneName: 'privatelink.purviewstudio.azure.com'
  }
  {
    condition: ctrlDeployStreaming
    name: 'PrivateDNSZoneIoTHub'
    dnsZoneName: 'privatelink.azure-devices.net'
  }
]

// Loop through above variable to create dns zones
module m_privateDNSZone 'modules/private_dns_zone.bicep' = [for dnsZone in dnsZones: if (ctrlDeployPrivateDNSZones && dnsZone.condition) {
  name: dnsZone.name
  params: {
    dnsZoneName: dnsZone.dnsZoneName
    vNetID: vNetID
    vNetName: vNetName
  }
}
]



// Lookup Private DNS Zones ======================================================================================
resource r_privateDNSZoneStorageDFS 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.dfs.${environmentStorageDNS}'
}

resource r_privateDNSZoneKeyVault 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.vaultcore.azure.net'
}

resource r_privateDNSZoneBlob 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.blob.${environmentStorageDNS}'
}

resource r_privateDNSZoneStorageQueue 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.queue.${environmentStorageDNS}'
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



//==================================================================================================================

//Azure Synapse Private Link Hub
resource r_synapsePrivateLinkhub 'Microsoft.Synapse/privateLinkHubs@2021-03-01' = {
  name: synapsePrivateLinkHubName
  location:resourceLocation
}

var privateEndpoints = [
  {
    condition: (ctrlDeployStreaming == true && ctrlStreamIngestionService == 'iothub')
    name: 'IotHubPrivateLink'
    groupId: 'iotHub'
    privateEndpoitName: '${iotHubName}-iotHub'
    privateLinkServiceId: iotHubID
    dnsZoneName: 'privatelink-azure-devices-net'
    privateDnsZoneId: r_privateDNSZoneIoTHub.id
  }
  {
    condition: ctrlDeploySynapse
    name: 'SynapseSQLPrivateLink'
    groupId: 'Sql'
    privateEndpoitName: '${synapseWorkspaceName}-sql'
    privateLinkServiceId: synapseWorkspaceID
    dnsZoneName: 'privatelink-sql-azuresynapse-net'
    privateDnsZoneId: r_privateDNSZoneSynapseSQL.id
  }
  {
    condition: ctrlDeploySynapse
    name: 'SynapseSQLServerlessPrivateLink'
    groupId: 'SqlOnDemand'
    privateEndpoitName: '${synapseWorkspaceName}-sqlserverless'
    privateLinkServiceId: synapseWorkspaceID
    dnsZoneName: 'privatelink-sql-azuresynapse-net'
    privateDnsZoneId: r_privateDNSZoneSynapseSQL.id
  }
  {
    condition: ctrlDeploySynapse
    name: 'SynapseDevPrivateLink'
    groupId: 'Dev'
    privateEndpoitName: '${synapseWorkspaceName}-dev'
    privateLinkServiceId: synapseWorkspaceID
    dnsZoneName: 'privatelink-web-azuresynapse-net'
    privateDnsZoneId: r_privateDNSZoneSynapseDev.id
  }
  {
    condition: ctrlDeploySynapse
    name: 'SynapseWebPrivateLink'
    groupId: 'Web'
    privateEndpoitName: '${synapseWorkspaceName}-web'
    privateLinkServiceId: r_synapsePrivateLinkhub.id
    dnsZoneName: 'privatelink-dev-azuresynapse-net'
    privateDnsZoneId: r_privateDNSZoneSynapseWeb.id
  }
  {
    condition: true
    name: 'KeyVaultPrivateLink'
    groupId: 'vault'
    privateEndpoitName: keyVaultName
    privateLinkServiceId: keyVaultID
    dnsZoneName: 'privatelink-vaultcore-azure-net'
    privateDnsZoneId: r_privateDNSZoneKeyVault.id
  }
  {
    condition: true
    name: 'DataLakePrivateLinkDFS'
    groupId: 'dfs'
    privateEndpoitName: '${dataLakeAccountName}-dfs'
    privateLinkServiceId: dataLakeAccountID
    dnsZoneName: 'privatelink-dfs-core-windows-net'
    privateDnsZoneId: r_privateDNSZoneStorageDFS.id
  }
  {
    condition: (ctrlDeployPurview == true)
    name: 'PurviewBlobPrivateLink'
    groupId: 'blob'
    privateEndpoitName: '${purviewAccountName}-blob'
    privateLinkServiceId: purviewManagedStorageAccountID
    dnsZoneName: 'privatelink-blob-core-windows-net'
    privateDnsZoneId: r_privateDNSZoneBlob.id
  }
  {
    condition: (ctrlDeployPurview == true)
    name: 'PurviewQueuePrivateLink'
    groupId: 'queue'
    privateEndpoitName: '${purviewAccountName}-queue'
    privateLinkServiceId: purviewManagedStorageAccountID
    dnsZoneName: 'privatelink-queue-core-windows-net'
    privateDnsZoneId: r_privateDNSZoneStorageQueue.id
  }
  {
    condition: (ctrlDeployPurview == true)
    name: 'PurviewEventHubPrivateLink'
    groupId: 'namespace'
    privateEndpoitName: '${purviewAccountName}-namespace'
    privateLinkServiceId: purviewManagedEventHubNamespaceID
    dnsZoneName: 'privatelink-servicebus-windows-net'
    privateDnsZoneId: r_privateDNSZoneServiceBus.id
  }
  {
    condition: (ctrlDeployPurview == true)
    name: 'PurviewAccountPrivateLink'
    groupId: 'account'
    privateEndpoitName: '${purviewAccountName}-account'
    privateLinkServiceId: purviewAccountID
    dnsZoneName: 'privatelink-purview-azure-com-account'
    privateDnsZoneId: r_privateDNSZonePurviewAccount.id
  }
  {
    condition: (ctrlDeployPurview == true)
    name: 'PurviewPortalPrivateLink'
    groupId: 'portal'
    privateEndpoitName: '${purviewAccountName}-portal'
    privateLinkServiceId: purviewAccountID
    dnsZoneName: 'privatelink-purview-azure-com-portal'
    privateDnsZoneId: r_privateDNSZonePurviewPortal.id
  }
  {
    condition: (ctrlDeployStreaming == true && ctrlStreamIngestionService == 'eventhub')
    name: 'EventHubPrivateLink'
    groupId: 'namespace'
    privateEndpoitName: '${eventHubNamespaceName}-namespace'
    privateLinkServiceId: eventHubNamespaceID
    dnsZoneName: 'privatelink-servicebus-windows-net'
    privateDnsZoneId: r_privateDNSZoneServiceBus.id
  }
]

module m_PrivateLink 'modules/private_endpoint.bicep' = [for privateEndpoint in privateEndpoints:  if(ctrlDeployPrivateDNSZones && privateEndpoint.condition) {
  name: privateEndpoint.name
  dependsOn:[
    m_privateDNSZone
  ]
  params: {
    groupID: privateEndpoint.groupId
    privateEndpoitName: privateEndpoint.privateEndpoitName
    privateLinkServiceId: privateEndpoint.privateLinkServiceId
    resourceLocation: resourceLocation
    subnetID: subnetID
    deployDNSZoneGroup: ctrlDeployPrivateDNSZones
    privateDNSZoneConfigs: [
      {
        name:privateEndpoint.dnsZoneName
        properties:{
          privateDnsZoneId: privateEndpoint.privateDnsZoneId
        }
      }
    ]
  }
}
]
