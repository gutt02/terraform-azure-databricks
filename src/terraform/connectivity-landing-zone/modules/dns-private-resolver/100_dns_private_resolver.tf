# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "dns_private_resolver" {
  resource_type = "general"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dnspr"]
}

resource "azurecaf_name" "dns_private_resolver_inbound_endpoint" {
  resource_type = "general"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dnspr", "ibe"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver
resource "azurerm_private_dns_resolver" "this" {
  name                = azurecaf_name.dns_private_resolver.result
  location            = var.location
  resource_group_name = data.azurerm_resource_group.this.name
  virtual_network_id  = data.azurerm_virtual_network.this.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = azurecaf_name.dns_private_resolver_inbound_endpoint.result
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = data.azurerm_subnet.dns_private_resolver_inbound.id
  }
}
