param vNetName string
param vNetSubnetName string
param resourceLocation string
param vNetIPAddressPrefixes array
param vNetSubnetIPAddressPrefix string
param ctrlNewOrExistingVNet string


resource r_vNet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name:vNetName
  location: resourceLocation
  properties:{
    addressSpace:{
      addressPrefixes: vNetIPAddressPrefixes
    }
  }
}

resource r_subNet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: vNetSubnetName
  parent: r_vNet
  properties: {
    addressPrefix: vNetSubnetIPAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies:'Enabled'
  }
}

var subnetID = ctrlNewOrExistingVNet == 'new' ? r_subNet.id : '${vNetID}/subnets/${vNetSubnetName}'
var vNetID = ctrlNewOrExistingVNet == 'new' ? r_vNet.id : resourceId(subscription().subscriptionId, resourceGroup().name, 'Microsoft.Network/virtualNetworks',vNetName)
output vNetID string = vNetID
output subnetID string = subnetID
