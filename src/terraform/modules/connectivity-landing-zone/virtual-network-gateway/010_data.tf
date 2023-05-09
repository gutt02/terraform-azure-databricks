locals {
  resource_regex       = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)/subnets/(.+)"
  subscription_id      = regex(local.resource_regex, var.gateway_subnet_id)[0]
  resource_group       = regex(local.resource_regex, var.gateway_subnet_id)[1]
  virtual_network_name = regex(local.resource_regex, var.gateway_subnet_id)[2]
  gateway_subnet_name  = regex(local.resource_regex, var.gateway_subnet_id)[3]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "this" {
  name = local.resource_group
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  resource_group_name = local.resource_group
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "this" {
  name                 = local.gateway_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group
}
