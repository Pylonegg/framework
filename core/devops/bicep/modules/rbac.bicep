

param referencedResource   string
param roleAssignments       array

// == RG Account ============================================================
resource r_rbacResourceGroup 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for assignment in roleAssignments: if (assignment.condition &&  resourceGroup().name == assignment.target) {
  name: guid(assignment.principalId, assignment.roleDefinitionId, subscription().subscriptionId, resourceGroup().id)
  scope: resourceGroup()
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType:'ServicePrincipal'
  }
}
]


// == Storage Account ============================================================
resource r_dataLakeStorageAccount       'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: referencedResource
}
resource r_rbacStorageAccount 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for assignment in roleAssignments: if (assignment.condition &&  r_dataLakeStorageAccount.name == assignment.target) {
  name: guid(assignment.principalId, assignment.roleDefinitionId, subscription().subscriptionId, resourceGroup().id)
  scope: r_dataLakeStorageAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType:'ServicePrincipal'
  }
}
]


// == Synapse Workspace ============================================================
resource r_synapseWorkspace       'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: referencedResource
}
resource r_rbacSynapseWorkspace 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for assignment in roleAssignments: if (assignment.condition &&  r_dataLakeStorageAccount.name == assignment.target) {
  name: guid(assignment.principalId, assignment.roleDefinitionId, subscription().subscriptionId, resourceGroup().id)
  scope: r_synapseWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType:'ServicePrincipal'
  }
}
]


// == Synapse Workspace ============================================================
resource r_azureMLSynapseLinkedService  'Microsoft.MachineLearningServices/workspaces/linkedServices@2020-09-01-preview' existing = {
  parent: r_azureMLWorkspace 
  name: referencedResource
}
resource r_rbacMLSynapseLinkedService'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for assignment in roleAssignments: if (assignment.condition &&  r_dataLakeStorageAccount.name == assignment.target) {
  name: guid(assignment.principalId, assignment.roleDefinitionId, subscription().subscriptionId, resourceGroup().id)
  scope: r_azureMLSynapseLinkedService
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType:'ServicePrincipal'
  }
}
]

resource r_azureMLWorkspace             'Microsoft.MachineLearningServices/workspaces@2021-07-01' existing = {
  name: referencedResource
}
resource r_rbacMLWorkspace 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = [for assignment in roleAssignments: if (assignment.condition &&  r_dataLakeStorageAccount.name == assignment.target) {
  name: guid(assignment.principalId, assignment.roleDefinitionId, subscription().subscriptionId, resourceGroup().id)
  scope: r_azureMLWorkspace
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType:'ServicePrincipal'
  }
}
]
