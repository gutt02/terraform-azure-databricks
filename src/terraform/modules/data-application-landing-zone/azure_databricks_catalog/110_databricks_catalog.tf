# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment
resource "databricks_metastore_assignment" "this" {
  workspace_id         = data.azurerm_databricks_workspace.this.workspace_id
  metastore_id         = var.databricks_metastore_id
  default_catalog_name = "unity-catalog"
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

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "this" {
  for_each = toset(["Contributor", "Storage Blob Data Contributor"])

  scope                = azurerm_storage_account.this.id
  role_definition_name = each.key
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential
resource "databricks_storage_credential" "this" {
  name = "${azurerm_storage_account.this.name}-sc"

  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }

  depends_on = [
    databricks_metastore_assignment.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location
resource "databricks_external_location" "this" {
  name = "${azurerm_storage_account.this.name}-el"
  url = format("abfss://%s@%s.dfs.core.windows.net",
    azurerm_storage_data_lake_gen2_filesystem.this.name,
  azurerm_storage_account.this.name)
  credential_name = databricks_storage_credential.this.id

  depends_on = [
    databricks_metastore_assignment.this,
    azurerm_role_assignment.this
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
