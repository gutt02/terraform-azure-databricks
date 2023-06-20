# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  name = "${azurerm_storage_account.this.name}-sc"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  name = "${azurerm_storage_account.this.name}-el"
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  azurerm_storage_account.this.name)
  credential_name = databricks_storage_credential.this.id

  depends_on = [
    azurerm_role_assignment.databricks_access_connector
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog
resource "databricks_catalog" "this" {
  name         = "custom_catalog"
  metastore_id = var.databricks_metastore_id
  owner        = data.azurerm_client_config.client_config.client_id
  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  azurerm_storage_account.this.name)
  force_destroy = true

  depends_on = [
    databricks_external_location.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
resource "databricks_schema" "this" {
  name         = "custom_schema"
  catalog_name = databricks_catalog.this.id

  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  azurerm_storage_account.this.name)

  depends_on = [
    databricks_catalog.this
  ]
}
