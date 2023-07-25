locals {
  default_databricks_api_delay = "5s"

  resource_regex_private_dns_zone                = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/privateDnsZones/(.+)"
  resource_regex_virtual_network                 = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)"
  connectivity_landing_zone_subscription_id      = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[0]
  connectivity_landing_zone_resource_group_name  = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[1]
  connectivity_landing_zone_virtual_network_name = regex(local.resource_regex_virtual_network, var.connectivity_landing_zone_virtual_network_id)[2]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "this" {
  provider = azurerm.connectivity_landing_zone

  name = local.connectivity_landing_zone_resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "this" {
  provider = azurerm.connectivity_landing_zone

  name                = local.connectivity_landing_zone_virtual_network_name
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone
data "azurerm_private_dns_zone" "this" {
  provider = azurerm.connectivity_landing_zone

  for_each = {
    for k, v in var.connectivity_landing_zone_private_dns_zone_ids : k => v
  }

  name                = regex(local.resource_regex_private_dns_zone, each.value.id)[2]
  resource_group_name = local.connectivity_landing_zone_resource_group_name
}
