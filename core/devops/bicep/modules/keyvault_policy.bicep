param keyVaultName string
param policies array

resource r_keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}
resource r_keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: r_keyVault
  properties:{
    accessPolicies: [for policy in policies: (policy.condition) ? {
        objectId: policy.principalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: policy.secrets
        }
      }:[]
    ]
  }
}
