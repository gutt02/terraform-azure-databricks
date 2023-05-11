# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = "${azurerm_storage_account.this.name}-dac"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}
