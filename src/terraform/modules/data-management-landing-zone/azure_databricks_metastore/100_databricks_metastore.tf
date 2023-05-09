# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "storage_account" {
  resource_type = "azurerm_storage_account"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["uc"]
}

resource "azurecaf_name" "private_endpoint_blob" {
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["blob"]
}

resource "azurecaf_name" "private_endpoint_dfs" {
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dfs"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = "${data.azurerm_databricks_workspace.this.name}-ac"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                     = azurecaf_name.storage_account.result
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.this.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "blob" {
  name                = azurecaf_name.private_endpoint_blob.result
  location            = var.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.this.id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.blob.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.blob.id]
  }

  private_service_connection {
    name                           = "${azurecaf_name.private_endpoint_blob.result}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "dfs" {
  name                = azurecaf_name.private_endpoint_dfs.result
  location            = var.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.this.id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.dfs.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dfs.id]
  }

  private_service_connection {
    name                           = "${azurecaf_name.private_endpoint_dfs.result}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["dfs"]
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "service_principal" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.client_config.object_id
}

# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
# resource "azurerm_storage_container" "this" {
#   name                  = "unity-catalog"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"

#   depends_on = [
#     azurerm_private_endpoint.blob,
#     azurerm_private_endpoint.dfs,
#     azurerm_role_assignment.service_principal
#   ]
# }

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = "unity-catalog"
  storage_account_id = azurerm_storage_account.this.id

  depends_on = [
    azurerm_private_endpoint.blob,
    azurerm_private_endpoint.dfs,
    azurerm_role_assignment.service_principal
  ]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "databricks_access_connector" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}

# https://registry.terraform.io/providers/databricks/databricks/0.5.3/docs/resources/metastore
resource "databricks_metastore" "this" {
  name  = "metastore-euw"
  owner = data.azurerm_client_config.client_config.client_id
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  azurerm_storage_account.this.name)
  force_destroy = true

  depends_on = [
    azurerm_databricks_access_connector.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/0.5.3/docs/resources/metastore_data_access
resource "databricks_metastore_data_access" "this" {
  metastore_id = databricks_metastore.this.id
  name         = "${azurerm_databricks_access_connector.this.name}-da"
  is_default   = true

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }

  depends_on = [
    databricks_metastore.this
  ]
}
