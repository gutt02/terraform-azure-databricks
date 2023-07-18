# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.databricks_schema.container_name
  storage_account_id = data.azurerm_storage_account.this.id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  name = format("%s@%s", azurerm_storage_data_lake_gen2_filesystem.this.name, data.azurerm_storage_account.this.name)

  azure_managed_identity {
    access_connector_id = var.databricks_access_connector.id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  name            = format("%s@%s", azurerm_storage_data_lake_gen2_filesystem.this.name, data.azurerm_storage_account.this.name)
  url             = format("abfss://%s@%s.dfs.core.windows.net", azurerm_storage_data_lake_gen2_filesystem.this.name, data.azurerm_storage_account.this.name)
  credential_name = databricks_storage_credential.this.id
  force_destroy   = true
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
resource "databricks_schema" "this" {
  name          = var.databricks_schema.name
  catalog_name  = var.databricks_catalog.id
  force_destroy = true

  storage_root = format("abfss://%s@%s.dfs.core.windows.net", azurerm_storage_data_lake_gen2_filesystem.this.name, data.azurerm_storage_account.this.name)

  depends_on = [databricks_external_location.this]
}
