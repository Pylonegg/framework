//=== PARAMETERS =====================================================================================
targetScope = 'subscription'
param resourceLocation              string
param resourceGroupName             string
param environment                   string
param uniqueName                    string
param uniquePrefix                  string = toLower('${environment}${uniqueName}')
param uniqueSuffix                  string = ''
param warehouseDatabaseNames        array
param controlDatabaseNames          array
param controlEntraAdminObjectIds    object
@secure()
param synapseSqlAdminPassword       string = newGuid()
param dataLakeContainerNames        array  = ['raw','trusted','curated','transient','sandpit']
param vNetName                      string = '${uniquePrefix}vnet${uniqueSuffix}'
param controlServerName             string = '${uniquePrefix}ctrlserver${uniqueSuffix}'
param warehouseServerName           string = '${uniquePrefix}warehouse${uniqueSuffix}'
param keyVaultName                  string = '${uniquePrefix}akv${uniqueSuffix}'
param analysisServicesName          string = '${uniquePrefix}aas${uniqueSuffix}'
param dataLakeAccountName           string = '${uniquePrefix}adls${uniqueSuffix}'
param databricksName                string = '${uniquePrefix}dbx${uniqueSuffix}'
param databricksManagedRGName       string = '${uniquePrefix}dbx${uniqueSuffix}-mrg'
param dataFactoryName               string = '${uniquePrefix}adf${uniqueSuffix}'
param synapseWorkspaceName          string = '${uniquePrefix}syn${uniqueSuffix}'
param synapseManagedRGName          string = '${uniquePrefix}syn${uniqueSuffix}-mrg'
param synapsePrivateLinkHubName     string = '${uniquePrefix}synhub${uniqueSuffix}'
param synapseADXPoolName            string = '${uniquePrefix}adxpool${uniqueSuffix}'
param purviewAccountName            string = '${uniquePrefix}prv${uniqueSuffix}'
param purviewManagedRGName          string = '${uniquePrefix}prv${uniqueSuffix}-mrg'
param dataShareAccountName          string = '${uniquePrefix}datashare${uniqueSuffix}'
param streamAnalyticsJobName        string = '${uniquePrefix}streamjob${uniqueSuffix}'
param eventHubNamespaceName         string = '${uniquePrefix}eventhubns${uniqueSuffix}'
param eventHubName                  string = '${uniquePrefix}eventhub${uniqueSuffix}'
param iotHubName                    string = '${uniquePrefix}iothub${uniqueSuffix}'
param azureMLWorkspaceName          string = '${uniquePrefix}mlwks${uniqueSuffix}'
param azureMLStorageAccountName     string = '${uniquePrefix}mlstorage${uniqueSuffix}'
param azureMLAppInsightsName        string = '${uniquePrefix}mlappinsights${uniqueSuffix}'
param azureMLContainerRegistryName  string = '${uniquePrefix}mlcontainerreg${uniqueSuffix}'
param anomalyDetectorName           string = '${uniquePrefix}anomalydetector${uniqueSuffix}'
param textAnalyticsAccountName      string = '${uniquePrefix}textanalytics${uniqueSuffix}'
param cosmosDBAccountName           string = '${uniquePrefix}cmsdb${uniqueSuffix}'
param cosmosDBDatabaseName          string = 'OperationalDB'
param synapseDedicatedSQLPoolName   string = 'EnterpriseDW'
param synapseSqlAdminUserName       string = 'azsynapseadmin'
param synapseADXDatabaseName        string = 'ADXDB'
param synapseSparkPoolName          string = 'SparkPool'
param deploymentScriptUAMIName      string = toLower('${uniquePrefix}uami${uniqueSuffix}')
//param existingVNetResourceGroupName string = resourceGroup().name
param tags object = {
  tagName1: 'tagValue1'
  tagName2: 'tagValue2'
}


//=== Resource Deployment Controllers =================================================================
param ctrlDeploySynapse             bool    = true
param ctrlDeployDataFactory         bool    = true
param ctrlDeployDatabricks          bool    = false
param ctrlDeployAnalysisServices    bool    = false
param ctrlDeployPurview             bool    = false
param ctrlDeployAI                  bool    = false
param ctrlDeployStreaming           bool    = false
param ctrlDeployDataShare           bool    = false
param ctrlDeployPrivateDNSZones     bool    = false
param ctrlDeployOperationalDB       bool    = false
param ctrlDeployCosmosDB            bool    = false
param ctrlDeploySynapseSQLPool      bool    = false
param ctrlDeploySynapseADXPool      bool    = false
param ctrlDeploySynapseSparkPool    bool    = false

//=== Network Related PARAMETERS =====================================================================================
param vNetIPAddressPrefixes         array  = ['10.1.0.0/16'] 
param vNetSubnetName                string = 'default'
param vNetSubnetIPAddressPrefix     string = '10.1.0.0/24'
@description('Network Isolation Mode')
@allowed(['default', 'vNet'])
param networkIsolationMode string = 'default'

@allowed(['new','existing'])
param ctrlNewOrExistingVNet string = 'new'

@allowed(['eventhub','iothub'])
param ctrlStreamIngestionService    string  = 'eventhub'

//=== VARIABLES  > Conditional ========================================================================================
var v_dataLakeAccountID                         = m_DataLakeDeploy.outputs.dataLakeStorageAccountID
var v_uamiPrincipalID                           = m_UAMI.outputs.deploymentScriptUAMIPrincipalID
var v_dataLakeAccountName                       = m_DataLakeDeploy.outputs.dataLakeStorageAccountName
var v_keyVaultID                                = m_keyVault.outputs.keyVaultID
var v_dataShareResourceID                       = ctrlDeployDataShare ? m_DataShareDeploy.outputs.dataShareAccountID : ''
var v_dataShareAccountPrincipalID               = ctrlDeployDataShare? m_DataShareDeploy.outputs.dataShareAccountPrincipalID : ''
var v_languageServiceAccountResourceID          = ctrlDeployAI? m_AIServicesDeploy.outputs.textAnalyticsAccountID : ''
var v_anomalyDetectorAccountResourceID          = ctrlDeployAI? m_AIServicesDeploy.outputs.anomalyDetectorAccountID : ''
var v_anomalyDetectorAccountID                  = ctrlDeployAI ? m_AIServicesDeploy.outputs.anomalyDetectorAccountID : ''
var v_anomalyDetectorAccountName                = ctrlDeployAI ? m_AIServicesDeploy.outputs.anomalyDetectorAccountName : ''
var v_anomalyDetectorEndpoint                   = ctrlDeployAI ? m_AIServicesDeploy.outputs.anomalyDetectorEndpoint : ''
var v_azureMLContainerRegistryID                = ctrlDeployAI ? m_AIServicesDeploy.outputs.containerRegistryID : ''
var v_azureMLContainerRegistryName              = ctrlDeployAI ? m_AIServicesDeploy.outputs.containerRegistryName : ''
var v_azureMLStorageAccountID                   = ctrlDeployAI ? m_AIServicesDeploy.outputs.storageAccountID : ''
var v_azureMLStorageAccountName                 = ctrlDeployAI ? m_AIServicesDeploy.outputs.storageAccountName : ''
var v_azureMLSynapseLinkedServicePrincipalID    = ctrlDeployAI ? m_Permissions.outputs.azureMLSynapseLinkedServicePrincipalID : ''
var v_azureMLWorkspaceID                        = ctrlDeployAI ? m_AIServicesDeploy.outputs.azureMLWorkspaceID : ''
var v_azureMLWorkspaceName                      = ctrlDeployAI ? m_AIServicesDeploy.outputs.azureMLWorkspaceName : azureMLWorkspaceName
var v_eventHubNamespaceID                       = ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.eventHubNamespaceID : ''
var v_eventHubNamespaceName                     = ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.eventHubNamespaceName : ''
var v_iotHubName                                = ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.iotHubName : ''
var v_iotHubID                                  = ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.iotHubID : ''
var v_iotHubPrincipalID                         = ctrlDeployStreaming? m_StreamingServicesDeploy.outputs.iotHubPrincipalID : ''
var v_purviewAccountID                          = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewAccountID : ''
var v_purviewAccountName                        = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewAccountName : ''
var v_purviewManagedEventHubNamespaceID         = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewManagedEventHubNamespaceID : ''
var v_purviewManagedStorageAccountID            = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewManagedStorageAccountID : ''
var v_purviewAccountResourceID                  = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewAccountID : ''
var v_purviewIdentityPrincipalID                = ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewIdentityPrincipalID :''
var v_purviewCatalogUri                         = ctrlDeployPurview ? '${purviewAccountName}.catalog.purview.azure.com' : ''
var v_textAnalyticsAccountID                    = ctrlDeployAI ? m_AIServicesDeploy.outputs.textAnalyticsAccountID : ''
var v_textAnalyticsAccountName                  = ctrlDeployAI ? m_AIServicesDeploy.outputs.textAnalyticsAccountName : ''
var v_textAnalyticsEndpoint                     = ctrlDeployAI ? m_AIServicesDeploy.outputs.textAnalyticsEndpoint: ''
var v_cosmosDBAccountID                         = ctrlDeployOperationalDB && ctrlDeployCosmosDB ? m_OperationalDatabasesDeploy.outputs.cosmosDBAccountID : ''
var v_cosmosDBAccountName                       = ctrlDeployOperationalDB && ctrlDeployCosmosDB ? m_OperationalDatabasesDeploy.outputs.cosmosDBAccountName : cosmosDBAccountName
var v_synapseWorkspaceID                        = ctrlDeploySynapse? m_SynapseDeploy.outputs.synapseWorkspaceID : ''
var v_synapseWorkspaceName                      = ctrlDeploySynapse? m_SynapseDeploy.outputs.synapseWorkspaceName : ''
var v_synapseWorkspaceIdentityPrincipalID       = ctrlDeploySynapse? m_SynapseDeploy.outputs.synapseWorkspaceIdentityPrincipalID : ''
var v_synapseSparkPoolID                        = ctrlDeploySynapseSparkPool ? m_SynapseDeploy.outputs.synapseWorkspaceSparkID : ''
var v_streamAnalyticsJobResourceID              = ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.streamAnalyticsJobID : ''
var v_streamAnalyticsIdentityPrincipalID        = ctrlDeployStreaming? m_StreamingServicesDeploy.outputs.streamAnalyticsIdentityPrincipalID : ''
var v_subnetID                                  = (networkIsolationMode == 'vNet' && ctrlNewOrExistingVNet == 'new') ? m_vNet.outputs.subnetID : ''
var v_vnetID                                    = (networkIsolationMode == 'vNet' && ctrlNewOrExistingVNet == 'new') ? m_vNet.outputs.vNetID : ''


//=== Platform Services ========================================================================================

@description('Create Platform resource group')
resource r_dataPlatformRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

@description('Create Platform Keyvault')
module m_keyVault 'modules/keyvault.bicep' = {
  name: 'KeyVaultDeploy'
  scope: r_dataPlatformRG
  params: {
    keyVaultName: keyVaultName
    resourceLocation: resourceLocation
    networkIsolationMode: networkIsolationMode
  }
}

@description('User-Assignment Managed Identity used to execute deployment scripts')
module m_UAMI 'modules/managed_identity.bicep' = {
  name: 'UAMIDeploy'
  scope: r_dataPlatformRG
  params: {
    deploymentScriptUAMIName : deploymentScriptUAMIName
    resourceLocation : resourceLocation
  }
}

@description('vNet created for network protected environments if networkIsolationMode is vNet')
module m_vNet 'modules/vnet.bicep' = if(networkIsolationMode == 'vNet' && ctrlNewOrExistingVNet == 'new'){
  name:'vNetDeploy'
  scope: r_dataPlatformRG
  params: {
    vNetName: vNetName
    vNetSubnetName: vNetSubnetName
    resourceLocation: resourceLocation
    vNetIPAddressPrefixes: vNetIPAddressPrefixes
    vNetSubnetIPAddressPrefix: vNetSubnetIPAddressPrefix
    ctrlNewOrExistingVNet: ctrlNewOrExistingVNet
  }
}

@description('Control Server')
module m_ControlServerDeploy 'modules/sql_server.bicep' = {
  name: 'ControlServerDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_keyVault
  ]
  params: {
    tags:tags
    sqlServerName         :controlServerName
    resourceLocation      :resourceLocation
    networkIsolationMode  :networkIsolationMode
    databaseNames         :controlDatabaseNames
    aadAdminObjectIds     :controlEntraAdminObjectIds
  }
}


//=== MODULES ===============================================================================================
//-----------------------------------------------------------------------------------------------------------
// - DataLake
//-----------------------------------------------------------------------------------------------------------
module m_DataLakeDeploy 'modules/datalake.bicep' =  {
  name: 'DataLakeDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
    m_DataShareDeploy
    m_PurviewDeploy
    m_StreamingServicesDeploy
    m_AIServicesDeploy
  ]
  params: {
    keyVaultName                       : keyVaultName
    resourceLocation                   : resourceLocation
    ctrlDeployStreaming                : ctrlDeployStreaming
    ctrlStreamIngestionService         : ctrlStreamIngestionService
    dataLakeAccountName                : dataLakeAccountName
    dataLakeContainerNames             : dataLakeContainerNames
    networkIsolationMode               : networkIsolationMode
    dataShareResourceID                : v_dataShareResourceID
    purviewAccountResourceID           : v_purviewAccountResourceID
    streamAnalyticsJobResourceID       : v_streamAnalyticsJobResourceID
    azureMLWorkspaceResourceID         : v_azureMLWorkspaceID
    anomalyDetectorAccountResourceID   : v_anomalyDetectorAccountResourceID
    languageServiceAccountResourceID   : v_languageServiceAccountResourceID
    iotHubResourceID                   : v_iotHubID
  }
}


//-----------------------------------------------------------------------------------------------------------
// - Data Warehouse
//-----------------------------------------------------------------------------------------------------------
@description('Data Warehouse')
module m_DatabaseDeploy'modules/sql_server.bicep' = {
  name: 'DatabaseDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_keyVault
  ]
  params: {
    tags:tags
    sqlServerName         :warehouseServerName
    resourceLocation      :resourceLocation
    networkIsolationMode  :networkIsolationMode
    databaseNames         :warehouseDatabaseNames
    aadAdminObjectIds     :controlEntraAdminObjectIds
  }
}


//-----------------------------------------------------------------------------------------------------------
// - Databricks Workspace
//-----------------------------------------------------------------------------------------------------------
module m_DatabricksDeploy 'modules/databricks.bicep' = if (ctrlDeployDatabricks == true) {
  name: 'DatabricksDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_DataLakeDeploy
  ]
  params: {
    resourceLocation                  : resourceLocation
    databricksName                    : databricksName
    managedResourceGroupName          : databricksManagedRGName
    pricingTier                       : 'Standard'
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Data Factory
//-----------------------------------------------------------------------------------------------------------
module m_DataFactoryDeploy 'modules/data_factory.bicep' = if (ctrlDeployDataFactory == true) {
  name: 'DataFactoryDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_keyVault
  ]
  params: {
    dataFactoryName: dataFactoryName
    resourceLocation: resourceLocation
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Analysis Services
//-----------------------------------------------------------------------------------------------------------
module m_AnalysisServicesDeploy 'modules/analysis_services.bicep' = if (ctrlDeployAnalysisServices == true) {
  name: 'AnalysisServicesDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_DataLakeDeploy
  ]
  params: {
    resourceLocation                  : resourceLocation
    analysisServicesName              : analysisServicesName
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Synapse Workspace
//-----------------------------------------------------------------------------------------------------------
module m_SynapseDeploy 'modules/synapse.bicep' = if (ctrlDeploySynapse == true) {
  name: 'SynapseDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_PurviewDeploy
    m_DataLakeDeploy
  ]
  params: {
    dataLakeAccountName              : m_DataLakeDeploy.outputs.dataLakeStorageAccountName
    networkIsolationMode             : networkIsolationMode
    resourceLocation                 : resourceLocation
    ctrlDeploySynapseSQLPool         : ctrlDeploySynapseSQLPool
    ctrlDeployPurview                : ctrlDeployPurview
    ctrlDeploySynapseSparkPool       : ctrlDeploySynapseSparkPool
    ctrlDeploySynapseADXPool         : ctrlDeploySynapseADXPool
    synapseDefaultContainerName      : synapseWorkspaceName
    synapseDedicatedSQLPoolName      : synapseDedicatedSQLPoolName
    synapseManagedRGName             : synapseManagedRGName
    synapseSparkPoolMaxNodeCount     : 3
    synapseSparkPoolMinNodeCount     : 3
    synapseSparkPoolName             : synapseSparkPoolName
    synapseSparkPoolNodeSize         : 'Small'   // Spark Node Size
    synapseADXPoolName               : synapseADXPoolName
    synapseADXDatabaseName           : synapseADXDatabaseName
    synapseADXPoolMinSize            : 2
    synapseADXPoolMaxSize            : 2
    synapseADXPoolEnableAutoScale    : false  // ADX Pool Enable Auto-Scale
    synapseSqlAdminPassword          : synapseSqlAdminPassword
    synapseSqlAdminUserName          : synapseSqlAdminUserName
    synapseSQLPoolSKU                : 'DW100c'  // SQL Pool SKU
    synapseWorkspaceName             : synapseWorkspaceName
    purviewAccountID                 : v_purviewAccountResourceID
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Purview
//-----------------------------------------------------------------------------------------------------------
module m_PurviewDeploy 'modules/purview.bicep' = if (ctrlDeployPurview == true) {
  name: 'PurviewDeploy'
  scope: r_dataPlatformRG
  params: {
    purviewAccountName              : purviewAccountName
    purviewManagedRGName            : purviewManagedRGName
    resourceLocation                : resourceLocation
  }
}

//-----------------------------------------------------------------------------------------------------------
// - AI Services
//-----------------------------------------------------------------------------------------------------------
//Deploy AI Services: Azure Machine Learning Workspace (and dependent services) and Cognitive Services
module m_AIServicesDeploy 'modules/ai_services.bicep' = if(ctrlDeployAI == true) {
  name: 'AIServicesDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
    m_keyVault
  ]
  params: {
    keyVaultID                      : m_keyVault.outputs.keyVaultID
    anomalyDetectorAccountName      : anomalyDetectorName
    azureMLAppInsightsName          : azureMLAppInsightsName
    azureMLContainerRegistryName    : azureMLContainerRegistryName
    azureMLStorageAccountName       : azureMLStorageAccountName
    azureMLWorkspaceName            : azureMLWorkspaceName
    textAnalyticsAccountName        : textAnalyticsAccountName
    resourceLocation                : resourceLocation
    networkIsolationMode            : networkIsolationMode
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Data Share
//-----------------------------------------------------------------------------------------------------------
module m_DataShareDeploy 'modules/data_share.bicep' = if(ctrlDeployDataShare == true) {
  name: 'DataShareDeploy'
  scope: r_dataPlatformRG
  params: {
    dataShareAccountName           : dataShareAccountName
    resourceLocation               : resourceLocation
    purviewCatalogUri              : v_purviewCatalogUri
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Streaming Services
//-----------------------------------------------------------------------------------------------------------
module m_StreamingServicesDeploy 'modules/streaming_services.bicep' = if(ctrlDeployStreaming == true) {
  name: 'StreamingServicesDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
    m_vNet
  ]
  params: {
    subNetID                        : v_subnetID
    ctrlStreamIngestionService      : ctrlStreamIngestionService
    eventHubNamespaceName           : eventHubNamespaceName
    eventHubSku                     : 'Standard'   // Azure EventHub SKU
    iotHubName                      : iotHubName
    iotHubSku                       : 'F1' //Free  // Azure IoTHub SKU
    resourceLocation                : resourceLocation
    streamAnalyticsJobName          : streamAnalyticsJobName
    streamAnalyticsJobSku           : 'Standard'
    networkIsolationMode            : networkIsolationMode
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Operational Databases
//-----------------------------------------------------------------------------------------------------------
module m_OperationalDatabasesDeploy 'modules/cosmos_database.bicep' = if(ctrlDeployOperationalDB == true) {
  name: 'OperationalDatabasesDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_SynapseDeploy
  ]
  params: {
    networkIsolationMode           : networkIsolationMode
    cosmosDBAccountName            : cosmosDBAccountName
    cosmosDBDatabaseName           : cosmosDBDatabaseName
    resourceLocation               : resourceLocation
    ctrlDeployCosmosDB             : ctrlDeployCosmosDB
    synapseWorkspaceID             : v_synapseWorkspaceID
  }
}

//-----------------------------------------------------------------------------------------------------------
// - Add Permissions Assignments
//-----------------------------------------------------------------------------------------------------------
module m_Permissions'platform_permissions.bicep' = {
  name: 'PermissionsDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_keyVault
    m_SynapseDeploy
    m_PurviewDeploy
    m_DataLakeDeploy
    m_AIServicesDeploy
    m_StreamingServicesDeploy
    m_OperationalDatabasesDeploy
    m_OperationalDatabasesDeploy
  ]
  params: {
    UAMIPrincipalID                            : v_uamiPrincipalID
    dataLakeAccountID                          : v_dataLakeAccountID
    dataLakeAccountName                        : v_dataLakeAccountName
    keyVaultName                               : keyVaultName
    ctrlDeploySynapse                          : ctrlDeploySynapse 
    ctrlDeployPurview                          : ctrlDeployPurview
    ctrlDeployAI                               : ctrlDeployAI
    ctrlDeployStreaming                        : ctrlDeployStreaming
    ctrlStreamIngestionService                 : ctrlStreamIngestionService
    ctrlSynapseDeploySparkPool                 : ctrlDeploySynapseSparkPool
    purviewIdentityPrincipalID                 : v_purviewIdentityPrincipalID
    synapseWorkspaceIdentityPrincipalID        : v_synapseWorkspaceIdentityPrincipalID
    azureMLWorkspaceName                       : v_azureMLWorkspaceName
    dataLakeContainerNames                     : dataLakeContainerNames
    eventHubName                               : eventHubName
    eventHubNamespaceName                      : eventHubNamespaceName
    eventHubPartitionCount                     : 1 // Azure EventHub Partition Count
    anomalyDetectorAccountName                 : anomalyDetectorName
    resourceLocation                           : resourceLocation
    synapseWorkspaceID                         : v_synapseWorkspaceID
    synapseWorkspaceName                       : v_synapseWorkspaceName
    synapseSparkPoolID                         : v_synapseSparkPoolID
    synapseSparkPoolName                       : synapseSparkPoolName
    textAnalyticsAccountName                   : textAnalyticsAccountName
    cosmosDBAccountName                        : v_cosmosDBAccountName
    ctrlDeployCosmosDB                         : ctrlDeployCosmosDB
    ctrlDeployDataShare                        : ctrlDeployDataShare
    ctrlDeployOperationalDB                    : ctrlDeployOperationalDB
    ctrlStreamingIngestionService              : ctrlStreamIngestionService
    cosmosDBDatabaseName                       : cosmosDBDatabaseName
    purviewAccountName                         : v_purviewAccountName
    iotHubPrincipalID                          : v_iotHubPrincipalID
    dataShareAccountPrincipalID                : v_dataShareAccountPrincipalID
    streamAnalyticsIdentityPrincipalID         : v_streamAnalyticsIdentityPrincipalID
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


//=== OUTPUTS ===============================================================================================

output synapseArguments string = join([
  '$networkIsolationMode            ="${networkIsolationMode}"'
  '$dataLakeAccountName             ="${dataLakeAccountName}"'
  '$cosmosDBDatabaseName            ="${cosmosDBDatabaseName}"'
  '$synapseWorkspaceName            ="${v_synapseWorkspaceName}"'
  '$synapseWorkspaceID              ="${v_synapseWorkspaceID}"'
  '$keyVaultName                    ="${keyVaultName}"'
  '$keyVaultID                      ="${v_keyVaultID}"'
  '$dataLakeAccountID               ="${v_dataLakeAccountID}"'
  '$uamiPrincipalID                 ="${v_uamiPrincipalID}"'
  '$azureMLWorkspaceName            ="${v_azureMLWorkspaceName}"'
  '$textAnalyticsAccountID          ="${v_textAnalyticsAccountID}"'
  '$textAnalyticsAccountName        ="${v_textAnalyticsAccountName}"'
  '$textAnalyticsEndpoint           ="${v_textAnalyticsEndpoint}"'
  '$anomalyDetectorAccountID        ="${v_anomalyDetectorAccountID}"'
  '$anomalyDetectorAccountName      ="${v_anomalyDetectorAccountName}"'
  '$anomalyDetectorEndpoint         ="${v_anomalyDetectorEndpoint}"'
  '$cosmosDBAccountID               ="${v_cosmosDBAccountID}"'
  '$cosmosDBAccountName             ="${v_cosmosDBAccountName}"'
  //v_AzMLSynapseLinkedServiceIdentityID
], ';')

