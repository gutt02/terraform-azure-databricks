# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "this" {
  resource_type = "azurerm_databricks_workspace"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dbac"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector
resource "azurerm_databricks_access_connector" "this" {
  name                = azurecaf_name.this.result
  resource_group_name = var.resource_group.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }
}
