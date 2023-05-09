# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "private_endpoint_databricks_ui_api" {
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["databricks", "ui", "api"]
}

resource "azurecaf_name" "private_endpoint_browser_authentication" {
  resource_type = "azurerm_private_endpoint"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["browser", "authentication"]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/azure-private-link-workspace-standard
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "databricks_ui_api" {
  name                = azurecaf_name.private_endpoint_databricks_ui_api.result
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.databricks.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.databricks.id]
  }

  private_service_connection {
    name                           = "${azurecaf_name.private_endpoint_databricks_ui_api.result}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    subresource_names              = ["databricks_ui_api"]
  }
}

resource "azurerm_private_endpoint" "browser_authentication" {
  name                = azurecaf_name.private_endpoint_browser_authentication.result
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.databricks.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.databricks.id]
  }

  private_service_connection {
    name                           = "${azurecaf_name.private_endpoint_browser_authentication.result}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    subresource_names              = ["browser_authentication"]
  }
}
