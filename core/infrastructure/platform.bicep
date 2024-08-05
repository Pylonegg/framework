//=== PARAMETERS =====================================================================================
targetScope = 'subscription'
param ctrlDeploySynapse             bool
param ctrlDeployDataFactory         bool
param ctrlDeployDatabase            bool
param ctrlDeployDatabricks          bool
param ctrlDeployAnalysisServices    bool
param ctrlDeployPurview             bool
param ctrlDeployStreaming           bool
param ctrlDeployDataShare           bool
param ctrlDeployPrivateDNSZones     bool
param ctrlDeployControlDatabase     bool
param ctrlDeploySynapseSQLPool      bool
param ctrlDeploySynapseADXPool      bool
param ctrlDeploySynapseSparkPool    bool
param ctrlNewOrExistingVNet         string

@description('Resource location')
param resourceLocation string

@description('Resource group name')
param resourceGroupName string

@description('Environment')
param environment string

@description('Unique name identifier')
param uniqueName string

@description('Unique prefix for resources')
param uniquePrefix string = toLower('${environment}${uniqueName}')

@description('Unique suffix for resources')
param uniqueSuffix string = ''

@description('Warehouse database names')
param warehouseDatabaseNames array

@description('Control database names')
param controlDatabaseNames array

@description('Control Entra admin object ID')
param controlEntraAdminObjectId string

@description('SQL admin password')
@secure()
param sqlAdminPassword string

@description('Synapse SQL admin password')
@secure()
param synapseSqlAdminPassword string = newGuid()

@description('Data lake container names')
param dataLakeContainerNames array = ['raw', 'trusted', 'curated', 'transient', 'sandpit']

@description('Virtual network name')
param vNetName string = '${uniquePrefix}vnet${uniqueSuffix}'

@description('Control server name')
param controlServerName string = '${uniquePrefix}ctrlserver${uniqueSuffix}'

@description('Warehouse server name')
param warehouseServerName string = '${uniquePrefix}warehouse${uniqueSuffix}'

@description('Key Vault name')
param keyVaultName string = '${uniquePrefix}akv${uniqueSuffix}'

@description('Analysis Services name')
param analysisServicesName string = '${uniquePrefix}aas${uniqueSuffix}'

@description('Data Lake account name')
param dataLakeAccountName string = '${uniquePrefix}adls${uniqueSuffix}'

@description('Databricks name')
param databricksName string = '${uniquePrefix}dbx${uniqueSuffix}'

@description('Databricks managed resource group name')
param databricksManagedRGName string = '${uniquePrefix}dbx${uniqueSuffix}-mrg'

@description('Data Factory name')
param dataFactoryName string = '${uniquePrefix}adf${uniqueSuffix}'

@description('Synapse workspace name')
param synapseWorkspaceName string = '${uniquePrefix}syn${uniqueSuffix}'

@description('Synapse managed resource group name')
param synapseManagedRGName string = '${uniquePrefix}syn${uniqueSuffix}-mrg'

param synapsePrivateLinkHubName     string = '${uniquePrefix}synhub${uniqueSuffix}'

@description('Synapse ADX pool name')
param synapseADXPoolName string = '${uniquePrefix}adxpool${uniqueSuffix}'

@description('Purview account name')
param purviewAccountName string = '${uniquePrefix}prv${uniqueSuffix}'

@description('Purview managed resource group name')
param purviewManagedRGName string = '${uniquePrefix}prv${uniqueSuffix}-mrg'

@description('Data Share account name')
param dataShareAccountName string = '${uniquePrefix}datashare${uniqueSuffix}'

@description('Stream Analytics job name')
param streamAnalyticsJobName string = '${uniquePrefix}streamjob${uniqueSuffix}'

@description('Event Hub namespace name')
param eventHubNamespaceName string = '${uniquePrefix}eventhubns${uniqueSuffix}'

//param eventHubName                  string = '${uniquePrefix}eventhub${uniqueSuffix}'

@description('IoT Hub name')
param iotHubName string = '${uniquePrefix}iothub${uniqueSuffix}'

@description('Synapse dedicated SQL pool name')
param synapseDedicatedSQLPoolName string = 'EnterpriseDW'

@description('Synapse SQL admin user name')
param synapseSqlAdminUserName string = 'azsynapseadmin'

@description('Synapse ADX database name')
param synapseADXDatabaseName string = 'ADXDB'

@description('Synapse Spark pool name')
param synapseSparkPoolName string = 'SparkPool'

@description('Deployment script User-Assigned Managed Identity name')
param deploymentScriptUAMIName string = toLower('${uniquePrefix}uami${uniqueSuffix}')

@description('Virtual network IP address prefixes')
param vNetIPAddressPrefixes array = ['10.1.0.0/16']

@description('Virtual network subnet name')
param vNetSubnetName string = 'default'

@description('Virtual network subnet IP address prefix')
param vNetSubnetIPAddressPrefix string = '10.1.0.0/24'

@description('Network isolation mode')
@allowed(['default', 'vNet'])
param networkIsolationMode string = 'vNet'

@description('Control stream ingestion service')
@allowed(['eventhub', 'iothub'])
param ctrlStreamIngestionService string = 'eventhub'

//param existingVNetResourceGroupName string = resourceGroup().name

@description('Resource tags')
param tags object = {
  tagName1: 'tagValue1'
  tagName2: 'tagValue2'
}
//=== Platform Services ========================================================================================
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
module m_UAMI 'modules/uami.bicep' = {
  name: 'UAMIDeploy'
  scope: r_dataPlatformRG
  params: {
    deploymentScriptUAMIName : deploymentScriptUAMIName
    resourceLocation : resourceLocation
  }
}

@description('Control Database') 
module m_ControlDatabaseDeploy 'modules/sql_server.bicep' = if (ctrlDeployControlDatabase) {
  name: 'ControlDatabaseDeploy'
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
    aadAdminObjectId      :controlEntraAdminObjectId
    admin_login           :'corleone'
    admin_password        :sqlAdminPassword
  }
}


//=== MODULES ===============================================================================================
// DataLake ----------------------------------------------------------------------------------------------
module m_DataLakeDeploy 'modules/datalake.bicep' =  {
  name: 'DataLakeDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
    m_DataShareDeploy
    m_PurviewDeploy
    m_StreamingServicesDeploy
  ]
  params: {
    keyVaultName                       : keyVaultName
    resourceLocation                   : resourceLocation
    ctrlDeployStreaming                : ctrlDeployStreaming
    ctrlStreamIngestionService         : ctrlStreamIngestionService
    dataLakeAccountName                : dataLakeAccountName
    dataLakeContainerNames             : dataLakeContainerNames
    networkIsolationMode               : networkIsolationMode
  }
}

// Data Warehouse ----------------------------------------------------------------------------------------
@description('Data Warehouse')
module m_DatabaseDeploy'modules/sql_server.bicep' = if (ctrlDeployDatabase) {
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
    aadAdminObjectId      :controlEntraAdminObjectId
    admin_login           :'corleone'
    admin_password        :sqlAdminPassword
  }
}

// Databricks Workspace ----------------------------------------------------------------------------------
module m_DatabricksDeploy 'modules/databricks.bicep' = if (ctrlDeployDatabricks) {
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

// Data Factory -------------------------------------------------------------------------------------------
module m_DataFactoryDeploy 'modules/data_factory.bicep' = if (ctrlDeployDataFactory) {
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

// Analysis Services --------------------------------------------------------------------------------------
module m_AnalysisServicesDeploy 'modules/analysis_services.bicep' = if (ctrlDeployAnalysisServices) {
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

// Synapse Workspace -------------------------------------------------------------------------------------
module m_SynapseDeploy 'modules/synapse.bicep' = if (ctrlDeploySynapse) {
  name: 'SynapseDeploy'
  scope: r_dataPlatformRG
  dependsOn:[
    m_PurviewDeploy
    m_DataLakeDeploy
  ]
  params: {
    UAMIPrincipalID                  : m_UAMI.outputs.principalId
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
    purviewAccountID                 : ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewAccountID : ''
  }
}

// Purview ------------------------------------------------------------------------------------------------
module m_PurviewDeploy 'modules/purview.bicep' = if (ctrlDeployPurview) {
  name: 'PurviewDeploy'
  scope: r_dataPlatformRG
  params: {
    purviewAccountName              : purviewAccountName
    purviewManagedRGName            : purviewManagedRGName
    resourceLocation                : resourceLocation
  }
}

// Data Share ---------------------------------------------------------------------------------------------
module m_DataShareDeploy 'modules/data_share.bicep' = if (ctrlDeployDataShare) {
  name: 'DataShareDeploy'
  scope: r_dataPlatformRG
  params: {
    dataShareAccountName           : dataShareAccountName
    resourceLocation               : resourceLocation
    purviewCatalogUri              : ctrlDeployPurview ? '${purviewAccountName}.catalog.purview.azure.com' : ''
  }
}


// Streaming Services -------------------------------------------------------------------------------------
module m_StreamingServicesDeploy 'modules/streaming_services.bicep' = if(ctrlDeployStreaming == true) {
  name: 'StreamingServicesDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
    m_vNet
  ]
  params: {
    subNetID                        : (networkIsolationMode == 'vNet' && ctrlNewOrExistingVNet == 'new') ? m_vNet.outputs.subnetID : ''
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


// Add Private Endpoints ----------------------------------------------------------------------------------
module m_PrivateEndpoints 'platform_network.bicep' = if (networkIsolationMode == 'vNet' && ctrlNewOrExistingVNet == 'new') {
  name: 'privateEndpointDeploy'
  scope: r_dataPlatformRG

  params: {
    vNetName: vNetName
    vNetID: m_vNet.outputs.vNetID
    subnetID: m_vNet.outputs.subnetID
    resourceLocation: resourceLocation
    ctrlDeploySynapse: ctrlDeploySynapse
    ctrlDeployPrivateDNSZones: ctrlDeployPrivateDNSZones
    ctrlDeployPurview: ctrlDeployPurview
    ctrlDeployStreaming: ctrlDeployStreaming
    ctrlStreamIngestionService: ctrlStreamIngestionService
    keyVaultID: m_keyVault.outputs.keyVaultID
    keyVaultName: keyVaultName
    synapseWorkspaceID: ctrlDeploySynapse ? m_SynapseDeploy.outputs.synapseWorkspaceID : ''
    synapseWorkspaceName: synapseWorkspaceName
    synapsePrivateLinkHubName: synapsePrivateLinkHubName
    dataLakeAccountID: m_DataLakeDeploy.outputs.dataLakeStorageAccountID
    dataLakeAccountName: dataLakeAccountName
    purviewAccountID: ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewAccountID : ''
    purviewAccountName: purviewAccountName
    purviewManagedStorageAccountID: ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewManagedStorageAccountID : ''
    purviewManagedEventHubNamespaceID:  ctrlDeployPurview ? m_PurviewDeploy.outputs.purviewManagedEventHubNamespaceID : ''
    eventHubNamespaceID: ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.eventHubNamespaceID : ''
    eventHubNamespaceName: eventHubNamespaceName
    iotHubID: ctrlDeployStreaming ? m_StreamingServicesDeploy.outputs.iotHubID : ''
    iotHubName: iotHubName
  }
}


// Add Permissions Assignments ----------------------------------------------------------------------------
module m_Permissions 'platform_permissions.bicep' = {
  name: 'permissionsDeploy'
  scope: r_dataPlatformRG
  params: {
    ctrlDeploySynapse                          : ctrlDeploySynapse 
    ctrlDeployPurview                          : ctrlDeployPurview
    ctrlDeployDataFactory                      : ctrlDeployDataFactory
    sqlAdminPassword                           : sqlAdminPassword
    dataFactoryName                            : dataFactoryName   
    purviewAccountName                         : purviewAccountName
    synapseWorkspaceName                       : synapseWorkspaceName
    keyVaultName                               : keyVaultName
  }
}

// Add Permissions Assignments ----------------------------------------------------------------------------
module m_RBAC 'platform_rbac.bicep' = {
  name: 'rbacDeploy'
  scope: r_dataPlatformRG
  params: {
    ctrlDeploySynapse                          : ctrlDeploySynapse 
    ctrlDeployPurview                          : ctrlDeployPurview
    ctrlDeployStreaming                        : ctrlDeployStreaming
    ctrlDeployDataShare                        : ctrlDeployDataShare
    ctrlStreamingIngestionService              : ctrlStreamIngestionService
    dataLakeAccountName                        : dataLakeAccountName
    purviewAccountName                         : purviewAccountName
    synapseWorkspaceName                       : synapseWorkspaceName
    streamAnalyticsJobName                     : streamAnalyticsJobName
    dataShareAccountName                       : dataShareAccountName
    UAMIPrincipalID                            : m_UAMI.outputs.principalId
    iotHubPrincipalID                          : ctrlDeployStreaming? m_StreamingServicesDeploy.outputs.iotHubPrincipalID : ''
  }
}
