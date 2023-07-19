# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  count = local.storage_account_id != null ? 1 : 0

  name               = var.databricks_catalog.container_name
  storage_account_id = local.storage_account_id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  count = local.storage_account_id != null ? 1 : 0

  name = format("%s@%s", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name)

  azure_managed_identity {
    access_connector_id = var.databricks_access_connector_id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  count = local.storage_account_id != null ? 1 : 0

  name            = format("%s@%s", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name)
  url             = format("abfss://%s@%s.dfs.core.windows.net", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name)
  credential_name = databricks_storage_credential.this[0].id
  force_destroy   = true
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog
resource "databricks_catalog" "this" {
  name          = var.databricks_catalog.name
  metastore_id  = var.databricks_metastore_id
  owner         = var.owner
  storage_root  = try(format("abfss://%s@%s.dfs.core.windows.net", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name), null)
  force_destroy = true

  depends_on = [databricks_external_location.this]
}
