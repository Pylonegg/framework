//=== Resource Deployment Controllers =================================================================
targetScope = 'subscription'

param ctrlDeploySynapse             bool    = true
param ctrlDeployDataFactory         bool    = true
param ctrlDeployDatabricks          bool    = false
param ctrlDeployAnalysisServices    bool    = false
param ctrlDeployPurview             bool    = false
param ctrlDeployAI                  bool    = false
param ctrlDeployStreaming           bool    = false
param ctrlDeployDataShare           bool    = false
param ctrlDeployOperationalDB       bool    = false
param ctrlDeployCosmosDB            bool    = false
param ctrlDeploySynapseSQLPool      bool    = false
param ctrlDeploySynapseADXPool      bool    = false
param ctrlDeploySynapseSparkPool    bool    = false

param resourceLocation              string
param resourceGroupName             string
param environment                   string
param uniqueName                    string
param uniquePrefix                  string = toLower('${environment}${uniqueName}')
param uniqueSuffix                  string = ''
param warehouseDatabaseNames        array
param controlDatabaseNames          array
param controlEntraAdminObjectId     string
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
param synapseADXPoolName            string = '${uniquePrefix}adxpool${uniqueSuffix}'
param purviewAccountName            string = '${uniquePrefix}prv${uniqueSuffix}'
param purviewManagedRGName          string = '${uniquePrefix}prv${uniqueSuffix}-mrg'
param dataShareAccountName          string = '${uniquePrefix}datashare${uniqueSuffix}'
param streamAnalyticsJobName        string = '${uniquePrefix}streamjob${uniqueSuffix}'
param eventHubNamespaceName         string = '${uniquePrefix}eventhubns${uniqueSuffix}'
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
//param existingVNetResourceGroupName string = resourceGroup().name
param tags object = {
  tagName1: 'tagValue1'
  tagName2: 'tagValue2'
}


//=== RBAC ROLES ========================================================================================
param  rbacStorageBlobDataReaderRoleID      string = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
param  rbacStorageBlobDataContributorRoleID string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
//param  rbacContributorRoleID                string = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
param  rbacOwnerRoleID                      string = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
param  rbacReaderRoleID                     string = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
//param  cosmosDBDataContributorRoleID        string = '00000000-0000-0000-0000-000000000002'

//=== Platform Services ========================================================================================
//-----------------------------------------------------------------------------------------------------------
// - RESOURCE GROUP
//-----------------------------------------------------------------------------------------------------------
@description('Create Platform resource group')
resource r_dataPlatformRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}
@description('Assign Roles to Resource Group')
module m_rbacRescourceGroup 'modules/rbac.bicep' = {
  name: 'resourceGroupRBAC'
  scope: r_dataPlatformRG
  params:{
    referencedResource: synapseWorkspaceName
    roleAssignments:[
      {
        target: resourceGroupName
        condition: true
        roleDefinitionId: rbacOwnerRoleID
        principalId: m_UAMI.outputs.principalId
      } 
    ]
  }
}

//-----------------------------------------------------------------------------------------------------------
// - KEYVAULT
//-----------------------------------------------------------------------------------------------------------
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
@description('Set Keyvault Access Policies')
module m_KeyVaultServiceConnectionAccessPolicy 'modules/keyvault_policy.bicep' = {
  name: 'KeyVaultAccessPolicies'
  scope: r_dataPlatformRG
  params: {
    keyVaultName: keyVaultName
    policies: [{
      condition: true
      principalId: '3809d824-2e13-4883-a19c-dfd86ec9e012'
      secrets: ['all']
    }
    {
      condition: true
      principalId: '57153cd2-4cbe-40d0-9556-a7339b92ac35'
      secrets: ['all']
    }
    {
      condition: ctrlDeploySynapse
      principalId: m_SynapseDeploy.outputs.synapseWorkspaceIdentityPrincipalID
      secrets: ['get', 'list']

    }
    //{
    //  condition: ctrlDeployPurview
    //  principalId: v_purviewIdentityPrincipalID
    //  secrets: ['get', 'list']
    //}
  ]
  }
}
//-----------------------------------------------------------------------------------------------------------
// - UAMI
//-----------------------------------------------------------------------------------------------------------
@description('User-Assignment Managed Identity used to execute deployment scripts')
module m_UAMI 'modules/uami.bicep' = {
  name: 'UAMIDeploy'
  scope: r_dataPlatformRG
  params: {
    deploymentScriptUAMIName : deploymentScriptUAMIName
    resourceLocation : resourceLocation
  }
}

//-----------------------------------------------------------------------------------------------------------
// - CONTROL SERVER
//-----------------------------------------------------------------------------------------------------------
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
    aadAdminObjectId      :controlEntraAdminObjectId
  }
}
//-----------------------------------------------------------------------------------------------------------
// - VNET
//-----------------------------------------------------------------------------------------------------------
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


//=== MODULES ===============================================================================================
//-----------------------------------------------------------------------------------------------------------
// - DataLake
//-----------------------------------------------------------------------------------------------------------
module m_DataLakeDeploy 'modules/datalake.bicep' =  {
  name: 'DataLakeDeploy'
  scope: r_dataPlatformRG
  dependsOn: [
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
  }
}
@description('Assign Storage Blob Data Roles')
module m_rbacStorageAccount 'modules/rbac.bicep' = {
  name: 'storageAccountRBAC'
  scope: r_dataPlatformRG
  params:{
    referencedResource: dataLakeAccountName
    roleAssignments:[
      {
        target: dataLakeAccountName
        condition: ctrlDeploySynapse
        roleDefinitionId: rbacStorageBlobDataContributorRoleID
        principalId: m_SynapseDeploy.outputs.synapseWorkspaceIdentityPrincipalID
      }
      {
        target: dataLakeAccountName
        condition: (ctrlDeployAI == true && ctrlDeploySynapse == true)
        roleDefinitionId: rbacStorageBlobDataReaderRoleID
        principalId: ''//r_azureMLSynapseLinkedService.identity.principalId
      }      
      {
        target: dataLakeAccountName
        condition: ctrlDeployDataShare
        roleDefinitionId: rbacStorageBlobDataReaderRoleID
        principalId: m_DataShareDeploy.outputs.dataShareAccountPrincipalID
      }   
      {
        target: dataLakeAccountName
        condition: ctrlDeployStreaming
        roleDefinitionId: rbacStorageBlobDataContributorRoleID
        principalId: m_StreamingServicesDeploy.outputs.streamAnalyticsIdentityPrincipalID
      }   
      {
        target: (ctrlDeployStreaming == true && ctrlStreamIngestionService == 'iothub')
        condition: ctrlDeployDataShare
        roleDefinitionId: rbacStorageBlobDataContributorRoleID
        principalId: m_StreamingServicesDeploy.outputs.iotHubPrincipalID
      }   
    ]
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
    aadAdminObjectId      :controlEntraAdminObjectId
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
@description('Assign Storage Blob Data Roles')
module m_rbacSynapseWorkspace 'modules/rbac.bicep' = {
  name: 'synapseRBAC'
  scope: r_dataPlatformRG
  params:{
    referencedResource: synapseWorkspaceName
    roleAssignments:[
      {
        target: synapseWorkspaceName
        condition: ctrlDeploySynapse
        roleDefinitionId: rbacOwnerRoleID
        principalId: m_UAMI.outputs.principalId
      }
      {
        target: synapseWorkspaceName
        condition: ctrlDeployPurview
        roleDefinitionId: rbacReaderRoleID
        principalId: m_PurviewDeploy.outputs.purviewIdentityPrincipalID
      }      
    ]
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
    purviewCatalogUri              : '${purviewAccountName}.catalog.purview.azure.com'
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
    synapseWorkspaceID             : m_SynapseDeploy.outputs.synapseWorkspaceID
  }
}
