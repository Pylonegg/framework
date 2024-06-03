param deploymentScriptUAMIName string
param resourceLocation string

resource r_deploymentScriptUAMI 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: deploymentScriptUAMIName
  location: resourceLocation
}


output deploymentScriptUAMIID string = r_deploymentScriptUAMI.id
output deploymentScriptUAMIPrincipalID string = r_deploymentScriptUAMI.properties.principalId

