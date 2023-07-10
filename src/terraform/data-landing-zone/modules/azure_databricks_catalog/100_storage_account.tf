# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "storage_account" {
  resource_type = "azurerm_storage_account"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["uc"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                     = azurecaf_name.storage_account.result
  location                 = var.location
  resource_group_name      = var.databricks_workspace.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action = "Deny"
    ip_rules       = var.enable_private_endpoints ? [] : distinct([var.agent_ip, replace(replace(var.client_ip.cidr, "/31", ""), "/32", "")])

    virtual_network_subnet_ids = concat([var.databricks_private_subnet.id, var.databricks_public_subnet.id], coalesce(var.databricks_serverless_sql_subnets, []))
  }

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "service_principal" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.client_config.object_id
}

# TODO: Validate if Storage Blob Data Contributor sufficient.
resource "azurerm_role_assignment" "databricks_access_connector" {
  for_each = toset(["Storage Blob Data Contributor"])

  scope                = azurerm_storage_account.this.id
  role_definition_name = each.key
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "blob" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "${azurerm_storage_account.this.name}-pe-blob"
  location            = var.location
  resource_group_name = var.databricks_workspace.resource_group_name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.connectivity_landing_zone_private_dns_zone_blob.name
    private_dns_zone_ids = [var.connectivity_landing_zone_private_dns_zone_blob.id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-pe-blob-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "dfs" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "${azurerm_storage_account.this.name}-pe-dfs"
  location            = var.location
  resource_group_name = var.databricks_workspace.resource_group_name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.connectivity_landing_zone_private_dns_zone_dfs.name
    private_dns_zone_ids = [var.connectivity_landing_zone_private_dns_zone_blob.id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-pe-dfs-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["dfs"]
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "this" {
  name                  = "my-metastore"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"

  depends_on = [
    azurerm_private_endpoint.blob,
    azurerm_private_endpoint.dfs,
    azurerm_role_assignment.service_principal
  ]
}

# # Note: This does not work with Private Endpoints, sic!
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
# resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
#   name               = "my-metastore"
#   storage_account_id = azurerm_storage_account.this.id

#   depends_on = [
#     azurerm_private_endpoint.blob,
#     azurerm_private_endpoint.dfs,
#     azurerm_role_assignment.service_principal
#   ]
# }
