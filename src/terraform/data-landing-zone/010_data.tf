locals {
  resource_regex_private_dns_zone                                  = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/privateDnsZones/(.+)"
  resource_regex_virtual_network                                   = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)"
  connectivity_landing_zone_subscription_id                        = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[0]
  connectivity_landing_zone_resource_group_name                    = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[1]
  connectivity_landing_zone_virtual_network_name                   = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[2]
  connectivity_landing_zone_private_dns_zone_azure_databricks_name = regex(local.resource_regex_private_dns_zone, var.connectivity_landing_zone_private_dns_zone_azuredatabricks_id)[2]
  connectivity_landing_zone_private_dns_zone_blob_name             = regex(local.resource_regex_private_dns_zone, var.connectivity_landing_zone_private_dns_zone_blob_id)[2]
  connectivity_landing_zone_private_dns_zone_dfs_name              = regex(local.resource_regex_private_dns_zone, var.connectivity_landing_zone_private_dns_zone_dfs_id)[2]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "connectivity_landing_zone" {
  provider = azurerm.connectivity_landing_zone

  name = local.connectivity_landing_zone_resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "connectivity_landing_zone" {
  provider = azurerm.connectivity_landing_zone

  name                = local.connectivity_landing_zone_virtual_network_name
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone
data "azurerm_private_dns_zone" "azuredatabricks" {
  provider = azurerm.connectivity_landing_zone

  name                = local.connectivity_landing_zone_private_dns_zone_azure_databricks_name
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}

data "azurerm_private_dns_zone" "blob" {
  provider = azurerm.connectivity_landing_zone

  name                = local.connectivity_landing_zone_private_dns_zone_blob_name
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}

data "azurerm_private_dns_zone" "dfs" {
  provider = azurerm.connectivity_landing_zone

  name                = local.connectivity_landing_zone_private_dns_zone_dfs_name
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}
