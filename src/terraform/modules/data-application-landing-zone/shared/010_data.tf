locals {
  resource_regex                                 = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)"
  connectivity_landing_zone_subscription_id      = regex(local.resource_regex, var.connectivity_landing_zone_virtual_network_id)[0]
  connectivity_landing_zone_resource_group       = regex(local.resource_regex, var.connectivity_landing_zone_virtual_network_id)[1]
  connectivity_landing_zone_virtual_network_name = regex(local.resource_regex, var.connectivity_landing_zone_virtual_network_id)[2]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "connectivity_landing_zone" {
  provider = azurerm.connectivity_landing_zone_subscription

  name = local.connectivity_landing_zone_resource_group
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "connectivity_landing_zone" {
  provider = azurerm.connectivity_landing_zone_subscription

  name                = local.connectivity_landing_zone_virtual_network_name
  resource_group_name = local.connectivity_landing_zone_resource_group
}
