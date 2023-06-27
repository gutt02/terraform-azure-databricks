# https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/azure-private-link-workspace-standard
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "databricks_ui_api_be" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "${azurerm_databricks_workspace.this.name}-pe-databricks_ui_api-be"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.connectivity_landing_zone_private_dns_zone_azuredatabricks.name
    private_dns_zone_ids = [var.connectivity_landing_zone_private_dns_zone_azuredatabricks.id]
  }

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.this.name}-pe-databricks_ui_api-be-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    subresource_names              = ["databricks_ui_api"]
  }
}

resource "azurerm_private_endpoint" "databricks_ui_api_fe" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "${azurerm_databricks_workspace.this.name}-pe-databricks_ui_api-fe"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.connectivity_landing_zone_private_dns_zone_azuredatabricks.name
    private_dns_zone_ids = [var.connectivity_landing_zone_private_dns_zone_azuredatabricks.id]
  }

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.this.name}-pe-databricks_ui_api-fe-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    subresource_names              = ["databricks_ui_api"]
  }
}

resource "azurerm_private_endpoint" "browser_authentication" {
  count = var.enable_private_endpoints ? 1 : 0

  name                = "${azurerm_databricks_workspace.this.name}-pe-browser_authentication"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.connectivity_landing_zone_private_dns_zone_azuredatabricks.name
    private_dns_zone_ids = [var.connectivity_landing_zone_private_dns_zone_azuredatabricks.id]
  }

  private_service_connection {
    name                           = "${azurerm_databricks_workspace.this.name}-pe-browser_authentication-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    subresource_names              = ["browser_authentication"]
  }
}
