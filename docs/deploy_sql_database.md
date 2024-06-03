To deploy an SQL project to an Azure SQL Database using a managed identity, you can use a YAML pipeline in Azure DevOps. Below is a sample YAML pipeline that demonstrates how to achieve this. This pipeline includes steps to build your SQL project, deploy it to Azure SQL Database, and use a managed identity for authentication.

### Azure DevOps Pipeline YAML

```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  sqlProjectPath: 'path/to/your/sql/project' # Adjust this path
  databaseName: 'your-database-name'
  serverName: 'your-server-name.database.windows.net'
  resourceGroupName: 'your-resource-group-name'
  sqlPackagePath: '$(Build.ArtifactStagingDirectory)/YourDatabase.dacpac'

stages:
- stage: Build
  jobs:
  - job: Build
    displayName: 'Build SQL Project'
    steps:
    - task: UseDotNet@2
      inputs:
        packageType: 'sdk'
        version: '5.x'
        installationPath: $(Agent.ToolsDirectory)/dotnet

    - task: NuGetToolInstaller@1

    - task: NuGetCommand@2
      inputs:
        restoreSolution: '$(sqlProjectPath)/*.sln'

    - task: VSBuild@1
      inputs:
        solution: '$(sqlProjectPath)/*.sln'
        msbuildArgs: '/p:Configuration=Release'
        platform: 'Any CPU'
        configuration: 'Release'

    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)'
        ArtifactName: 'drop'
        
- stage: Deploy
  dependsOn: Build
  jobs:
  - deployment: Deploy
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - download: current
            artifact: drop

          - task: AzureCLI@2
            inputs:
              azureSubscription: '<your-service-connection-name>'
              scriptType: 'ps'
              scriptLocation: 'inlineScript'
              inlineScript: |
                $dacpacFilePath = "$(sqlPackagePath)"
                $managedIdentityClientId = $(system.assignedidentity)
                $resourceGroupName = "$(resourceGroupName)"
                $sqlServerName = "$(serverName)"
                $databaseName = "$(databaseName)"
                
                # Generate access token for Managed Identity
                $accessToken = az account get-access-token --resource https://database.windows.net/ --query accessToken --output tsv
                
                # Deploy DACPAC to Azure SQL Database
                & sqlpackage /Action:Publish /SourceFile:$dacpacFilePath /TargetServerName:$sqlServerName /TargetDatabaseName:$databaseName /AccessToken:$accessToken /p:AllowIncompatiblePlatform=true

```

### Explanation

1. **Trigger**: The pipeline triggers on changes to the `main` branch.
   
2. **Pool**: Specifies the VM image to be used for the build agent.

3. **Variables**: Define paths, names, and other reusable values.

4. **Stages**:
    - **Build Stage**: 
      - **UseDotNet**: Ensures the .NET SDK is available.
      - **NuGetToolInstaller** and **NuGetCommand**: Restore NuGet packages.
      - **VSBuild**: Build the SQL project to produce a DACPAC file.
      - **PublishBuildArtifacts**: Publish the DACPAC as an artifact for deployment.
    - **Deploy Stage**: 
      - **Download**: Download the build artifacts.
      - **AzureCLI**: Use Azure CLI to deploy the DACPAC file to Azure SQL Database using the managed identity for authentication.
        - Retrieve an access token for the managed identity.
        - Use `sqlpackage` to deploy the DACPAC to the specified database.

### Notes

- Ensure you have set up a service connection in Azure DevOps with the appropriate permissions.
- Replace placeholder values like `your-database-name`, `your-server-name`, `your-resource-group-name`, and `<your-service-connection-name>` with actual values relevant to your setup.
- The managed identity must have the necessary permissions on the Azure SQL Database.

This pipeline provides a clear and structured approach to building and deploying SQL projects to Azure SQL Database using managed identities for secure authentication.