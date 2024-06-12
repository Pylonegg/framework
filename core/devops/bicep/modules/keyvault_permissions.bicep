param keyVaultName string
param secrets array
param policies array

resource r_keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

@description('Add Secrets key to keyvault')
resource r_textAnalyticsAccountKey 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = [for secret in secrets:  if(secret.condition) {
  name:'${secret.name}-Key'
  parent: r_keyVault
  properties:{
    value:  secret.value
  }
}]

var filteredPolicies = union(policies, policies)

resource r_keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: r_keyVault
  properties:{
    accessPolicies: [for policy in filteredPolicies: {
        objectId: policy.principalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: policy.secrets
        } 
      }
    ]
  }
}
