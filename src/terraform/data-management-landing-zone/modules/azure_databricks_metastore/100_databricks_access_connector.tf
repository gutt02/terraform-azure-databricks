# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = "${var.storage_account.name}-dbac"
  resource_group_name = var.resource_group.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "databricks_access_connector" {
  scope                = var.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}
