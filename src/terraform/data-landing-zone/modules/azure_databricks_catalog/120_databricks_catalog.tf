# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.container_name
  storage_account_id = var.storage_account.id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  name = var.storage_account.name

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  name = var.storage_account.name
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  var.storage_account.name)
  credential_name = databricks_storage_credential.this.id
  force_destroy   = true

  depends_on = [
    databricks_metastore_assignment.this,
    azurerm_role_assignment.databricks_access_connector
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog
resource "databricks_catalog" "this" {
  name         = var.catalog_name
  metastore_id = var.databricks_metastore_id
  owner        = var.client_config.client_id
  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  var.storage_account.name)
  force_destroy = true

  depends_on = [
    databricks_external_location.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
resource "databricks_schema" "this" {
  name          = var.schema_name
  catalog_name  = databricks_catalog.this.id
  force_destroy = true

  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  var.storage_account.name)
}
