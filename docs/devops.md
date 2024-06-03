## Documentation for Bicep Deployment Script
[Go Back](../readme.md)

### Overview

This Bicep script is designed for deploying various Azure resources as part of a data platform. It allows conditional deployment of multiple services such as Synapse, Data Factory, Databricks, Analysis Services, Purview, AI Services, Streaming Services, Data Share, and more. The script is highly configurable with numerous parameters that control the deployment specifics, including resource names, locations, and deployment controls.

### Global Parameters

- **targetScope**: Specifies that the deployment scope is at the subscription level.
- **resourceLocation**: The location/region where the resources will be deployed.
- **resourceGroupName**: Name of the resource group to be created.
- **environment**: Specifies the environment (e.g., dev, prod) for naming consistency.
- **uniqueName**: A unique identifier to distinguish resources.
- **uniquePrefix**: A combination of environment and uniqueName to create a prefix for resource names.
- **uniqueSuffix**: Optional suffix for resource names.
- **ctrlDeployXXX**: Boolean flags (e.g., ctrlDeploySynapse, ctrlDeployDataFactory) to control the deployment of specific resources.
- **tags**: A dictionary object for tagging resources.
- **networkIsolationMode**: Specifies network isolation mode, either 'default' or 'vNet'.
- **ctrlNewOrExistingVNet**: Indicates whether a new or existing Virtual Network (VNet) will be used.
- **ctrlStreamIngestionService**: Specifies the streaming ingestion service to be used, either 'eventhub' or 'iothub'.

### Naming Parameters

Parameters for naming various resources, following the pattern `${uniquePrefix}{resourceName}${uniqueSuffix}`. Examples include:

- **synapseSqlAdminPassword**: Password for the Synapse SQL admin.
- **dataLakeContainerNames**: Array of names for Data Lake containers.
- **vNetName**: Name of the Virtual Network.
- **controlServerName**: Name of the control server.
- **controlDatabaseName**: Name of the control database.
- **keyVaultName**: Name of the Key Vault.
- **analysisServicesName**: Name of the Analysis Services.
- **dataLakeAccountName**: Name of the Data Lake account.
- **databricksName**: Name of the Databricks workspace.
- **dataFactoryName**: Name of the Data Factory.
- **synapseWorkspaceName**: Name of the Synapse workspace.
- **purviewAccountName**: Name of the Purview account.
- **streamAnalyticsJobName**: Name of the Stream Analytics job.
- **eventHubNamespaceName**: Name of the Event Hub namespace.
- **iotHubName**: Name of the IoT Hub.
- **azureMLWorkspaceName**: Name of the Azure Machine Learning workspace.
- **cosmosDBAccountName**: Name of the Cosmos DB account.
- **cosmosDBDatabaseName**: Name of the Cosmos DB database.
- **vNetIPAddressPrefixes**: Array of IP address prefixes for the VNet.
- **vNetSubnetName**: Name of the VNet subnet.
- **vNetSubnetIPAddressPrefix**: IP address prefix for the VNet subnet.

### Conditional Variables

Variables that store outputs from deployed modules or conditionally set values based on deployment controls. These variables are used to link dependencies between different resources and to retrieve IDs or names required for configuration.

### Resource Deployment Modules

The script includes various modules, each responsible for deploying specific resources. Modules are conditionally deployed based on the control parameters.

- **Resource Group**: Creates the resource group where all resources will reside.
- **Key Vault**: Deploys an Azure Key Vault for managing secrets.
- **Managed Identity**: Deploys a user-assigned managed identity for script execution.
- **Virtual Network (VNet)**: Conditionally creates a VNet based on the network isolation mode.
- **Control Server**: Deploys an SQL server for control purposes.
- **Control Database**: Deploys an SQL database on the control server.
- **Data Lake**: Deploys a Data Lake Storage account and related configurations.
- **Databricks**: Conditionally deploys an Azure Databricks workspace.
- **Data Factory**: Conditionally deploys an Azure Data Factory.
- **Analysis Services**: Conditionally deploys Azure Analysis Services.
- **Synapse Workspace**: Conditionally deploys an Azure Synapse workspace and related pools.
- **Purview**: Conditionally deploys Azure Purview.
- **AI Services**: Conditionally deploys AI services, including Azure Machine Learning and Cognitive Services.
- **Data Share**: Conditionally deploys Azure Data Share.
- **Streaming Services**: Conditionally deploys streaming services, including Event Hub and IoT Hub.
- **Operational Databases**: Conditionally deploys operational databases, including Cosmos DB.
- **Permissions**: Adds necessary permission assignments for the deployed resources.

### Platform Services

- **Resource Group**: The base resource group for all deployments.
- **Key Vault**: Centralized secret management.
- **Managed Identity**: Identity for executing deployment scripts.

### Modules

Modules are defined for each major component, ensuring modularity and reusability. Each module's deployment can be controlled via the corresponding boolean parameter.

- **Control Server and Database**: For managing the control plane of the data platform.
- **Data Lake**: Includes configurations for Data Lake Storage, containers, and integration with other services.
- **Databricks**: Deploys a Databricks workspace if enabled.
- **Data Factory**: Deploys Data Factory for orchestrating data workflows.
- **Analysis Services**: Provides deployment for Analysis Services if enabled.
- **Synapse Workspace**: Comprehensive deployment of Synapse workspace, SQL Pool, Spark Pool, and ADX Pool based on configurations.
- **Purview**: Metadata management and governance through Purview.
- **AI Services**: Deployment of AI-related services including Machine Learning and Cognitive Services.
- **Data Share**: For sharing data securely.
- **Streaming Services**: Includes deployment of Event Hub, IoT Hub, and Stream Analytics.
- **Operational Databases**: Deployment of databases like Cosmos DB for operational data storage.
- **Permissions**: Ensures proper permissions are assigned to various identities for resource access and management.

### Network Integration

An additional (commented-out) section for Virtual Network integration is provided, which can be enabled if network isolation is required for deployed resources.

### Summary

This Bicep script provides a comprehensive and configurable approach to deploying a complex data platform on Azure, leveraging modular deployment and conditional logic to manage a wide array of Azure services and resources. The use of parameters and modular design ensures flexibility and reusability across different environments and configurations.