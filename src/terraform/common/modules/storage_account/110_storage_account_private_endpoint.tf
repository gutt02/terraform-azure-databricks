# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "blob" {
  count = var.enable_private_endpoints && can(var.private_dns_zones["blob"]) ? 1 : 0

  name                = "${azurerm_storage_account.this.name}-pe-blob"
  location            = var.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.private_dns_zones["blob"].name
    private_dns_zone_ids = [var.private_dns_zones["blob"].id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-pe-blob-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "dfs" {
  count = var.enable_private_endpoints && can(var.private_dns_zones["dfs"]) ? 1 : 0

  name                = "${azurerm_storage_account.this.name}-pe-dfs"
  location            = var.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.private_dns_zones["dfs"].name
    private_dns_zone_ids = [var.private_dns_zones["dfs"].id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.this.name}-pe-dfs-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["dfs"]
  }
}
