locals {
  resource_regex_databricks_workspace                  = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Databricks/workspaces/(.+)"
  subscription_id                                      = regex(local.resource_regex_databricks_workspace, var.databricks_resource_id)[0]
  resource_group_databricks_workspace                  = regex(local.resource_regex_databricks_workspace, var.databricks_resource_id)[1]
  databricks_workspace_name                            = regex(local.resource_regex_databricks_workspace, var.databricks_resource_id)[2]
  databricks_workspace_host                            = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id                              = data.azurerm_databricks_workspace.this.workspace_id
  resource_regex_virtual_network_subnet                = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/virtualNetworks/(.+)/subnets/(.+)"
  resource_group_virtual_network_subnet                = regex(local.resource_regex_virtual_network_subnet, var.private_endpoints_subnet_id)[1]
  virtual_network_name                                 = regex(local.resource_regex_virtual_network_subnet, var.private_endpoints_subnet_id)[2]
  private_endpoints_subnet_name                        = regex(local.resource_regex_virtual_network_subnet, var.private_endpoints_subnet_id)[3]
  connectivity_landing_zone_resource_regex             = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Network/privateDnsZones/(.+)"
  connectivity_landing_zone_subscription_id            = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_blob_id)[0]
  connectivity_landing_zone_resource_group             = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_blob_id)[1]
  connectivity_landing_zone_private_dns_zone_blob_name = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_blob_id)[2]
  connectivity_landing_zone_private_dns_zone_dfs_name = regex(local.connectivity_landing_zone_resource_regex, var.connectivity_landing_zone_private_dns_zone_dfs_id)[2]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "this" {
  name = local.resource_group_databricks_workspace
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/databricks_workspace
data "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = local.resource_group_databricks_workspace
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "this" {
  name                 = local.private_endpoints_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.resource_group_virtual_network_subnet
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone
data "azurerm_private_dns_zone" "blob" {
  provider = azurerm.connectivity_landing_zone_subscription

  name                = local.connectivity_landing_zone_private_dns_zone_blob_name
  resource_group_name = local.connectivity_landing_zone_resource_group
}

data "azurerm_private_dns_zone" "dfs" {
  provider = azurerm.connectivity_landing_zone_subscription

  name                = local.connectivity_landing_zone_private_dns_zone_dfs_name
  resource_group_name = local.connectivity_landing_zone_resource_group
}
