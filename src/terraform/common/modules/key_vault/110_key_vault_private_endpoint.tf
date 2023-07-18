# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
# https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
resource "azurerm_private_endpoint" "this" {
  count = var.enable_private_endpoints && can(var.private_dns_zones["vaultcore"]) ? 1 : 0

  name                = "${azurerm_key_vault.this.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.private_endpoints_subnet.id

  private_dns_zone_group {
    name                 = var.private_dns_zones["vaultcore"].name
    private_dns_zone_ids = [var.private_dns_zones["vaultcore"].id]
  }

  private_service_connection {
    name                           = "${azurerm_key_vault.this.name}-pe-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
  }
}
