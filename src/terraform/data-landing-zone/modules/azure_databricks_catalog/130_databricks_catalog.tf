# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  name = azurerm_storage_account.this.name

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  name = azurerm_storage_account.this.name
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.this.name,
  azurerm_storage_account.this.name)
  credential_name = databricks_storage_credential.this.id
  force_destroy   = true

  depends_on = [
    databricks_metastore_assignment.this,
    azurerm_role_assignment.service_principal,
    azurerm_role_assignment.databricks_access_connector
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog
resource "databricks_catalog" "this" {
  name         = "my_catalog"
  metastore_id = var.databricks_metastore_id
  owner        = var.client_config.client_id
  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.this.name,
  azurerm_storage_account.this.name)
  force_destroy = true

  depends_on = [
    databricks_external_location.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema
resource "databricks_schema" "this" {
  name          = "my_schema"
  catalog_name  = databricks_catalog.this.id
  force_destroy = true

  storage_root = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_container.this.name,
  azurerm_storage_account.this.name)
}
