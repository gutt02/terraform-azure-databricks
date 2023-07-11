# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = "${azurerm_storage_account.this.name}-dbac"
  resource_group_name = var.resource_group.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}
