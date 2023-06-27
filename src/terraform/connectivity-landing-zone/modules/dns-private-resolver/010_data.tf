locals {
  resource_regex_subnet                     = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)/subnets/(.+)"
  subscription_id                           = regex(local.resource_regex_subnet, var.dns_private_resolver_inbound_subnet_id)[0]
  resource_group_name                       = regex(local.resource_regex_subnet, var.dns_private_resolver_inbound_subnet_id)[1]
  virtual_network_name                      = regex(local.resource_regex_subnet, var.dns_private_resolver_inbound_subnet_id)[2]
  dns_private_resolver_inbound_subnet_name  = regex(local.resource_regex_subnet, var.dns_private_resolver_inbound_subnet_id)[3]
  dns_private_resolver_outbound_subnet_name = regex(local.resource_regex_subnet, var.dns_private_resolver_outbound_subnet_id)[3]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  resource_group_name = local.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "dns_private_resolver_inbound" {
  name                 = local.dns_private_resolver_inbound_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_subnet" "dns_private_resolver_outbound" {
  name                 = local.dns_private_resolver_outbound_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group_name
}
