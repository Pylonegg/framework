param keyVaultName string
param PrincipalID string
param secrets array

resource r_keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}
resource r_keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: r_keyVault
  properties:{
    accessPolicies: [
      {
        objectId: PrincipalID
        tenantId: subscription().tenantId
        permissions: {
          secrets: secrets
        }
      }
    ]
  }
}
