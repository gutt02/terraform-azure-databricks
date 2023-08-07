# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  count = local.storage_account_id != null && var.storage_data_lake_gen2_filesystem == null ? 1 : 0

  name               = var.filesystem_name
  storage_account_id = local.storage_account_id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_path
resource "azurerm_storage_data_lake_gen2_path" "this" {
  count = local.storage_account_id != null && var.databricks_schema.directory_name != null ? 1 : 0

  path               = var.databricks_schema.directory_name
  filesystem_name    = var.filesystem_name
  storage_account_id = local.storage_account_id
  resource           = "directory"
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  count = length(azurerm_storage_data_lake_gen2_filesystem.this)

  name = format("%s@%s:%s", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name, azurerm_storage_data_lake_gen2_path.this[0].path)

  azure_managed_identity {
    access_connector_id = var.databricks_access_connector_id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  count = length(azurerm_storage_data_lake_gen2_filesystem.this)

  name            = format("%s@%s:%s", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name, azurerm_storage_data_lake_gen2_path.this[0].path)
  url             = format("abfss://%s@%s.dfs.core.windows.net/%s", var.filesystem_name, local.storage_account_name, var.databricks_schema.directory_name)
  credential_name = databricks_storage_credential.this[0].id
  force_destroy   = true
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
resource "databricks_schema" "this" {
  name          = var.databricks_schema.name
  catalog_name  = var.databricks_catalog_id
  owner         = var.owner
  storage_root  = try(format("abfss://%s@%s.dfs.core.windows.net/%s", azurerm_storage_data_lake_gen2_filesystem.this[0].name, local.storage_account_name, azurerm_storage_data_lake_gen2_path.this[0].path), null)
  force_destroy = true

  depends_on = [databricks_external_location.this]
}
