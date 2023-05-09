locals {
  resource_regex                                                   = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)/subnets/(.+)"
  subscription_id                                                  = regex(local.resource_regex, var.private_endpoints_subnet_id)[0]
  resource_group                                                   = regex(local.resource_regex, var.private_endpoints_subnet_id)[1]
  virtual_network_name                                             = regex(local.resource_regex, var.private_endpoints_subnet_id)[2]
  private_endpoints_subnet_name                                    = regex(local.resource_regex, var.private_endpoints_subnet_id)[3]
  databricks_public_subnet_name                                    = regex(local.resource_regex, var.databricks_public_subnet_id)[3]
  databricks_private_subnet_name                                   = regex(local.resource_regex, var.databricks_private_subnet_id)[3]
  connectivity_landing_zone_resource_regex                         = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/privateDnsZones/(.+)"
  connectivity_landing_zone_subscription_id                        = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_azuredatabricks_id)[0]
  connectivity_landing_zone_resource_group                         = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_azuredatabricks_id)[1]
  connectivity_landing_zone_private_dns_zone_azure_databricks_name = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_azuredatabricks_id)[2]
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
data "azurerm_subnet" "private_endpoints" {
  name                 = local.private_endpoints_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group
}

data "azurerm_subnet" "databricks_public" {
  name                 = local.databricks_public_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group
}

data "azurerm_subnet" "databricks_private" {
  name                 = local.databricks_private_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone
data "azurerm_private_dns_zone" "this" {
  provider = azurerm.connectivity_landing_zone_subscription

  name                = local.connectivity_landing_zone_private_dns_zone_azure_databricks_name
  resource_group_name = local.connectivity_landing_zone_resource_group
}
