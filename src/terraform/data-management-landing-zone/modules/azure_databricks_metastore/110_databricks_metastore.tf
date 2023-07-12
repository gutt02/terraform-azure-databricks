# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.container_name
  storage_account_id = var.storage_account.id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore
resource "databricks_metastore" "this" {
  name  = var.metastore_name
  owner = var.metastore_owner
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  var.storage_account.name)
  force_destroy = true

  lifecycle {
    ignore_changes = [
      updated_by,
      updated_at
    ]
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_data_access
resource "databricks_metastore_data_access" "this" {
  metastore_id = databricks_metastore.this.id
  name         = databricks_metastore.this.name
  is_default   = true

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }
}
