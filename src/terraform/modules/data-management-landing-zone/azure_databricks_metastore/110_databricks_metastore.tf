# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = "${data.azurerm_databricks_workspace.this.name}-ac"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "databricks_access_connector" {
  for_each = toset(["Contributor", "Storage Blob Data Contributor"])

  scope                = azurerm_storage_account.this.id
  role_definition_name = each.key
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
}
