output "dns_private_resolver_inbound_subnet_id" {
  value = azurerm_subnet.dns_private_resolver_inbound.id
}

output "dns_private_resolver_outbound_subnet_id" {
  value = azurerm_subnet.dns_private_resolver_outbound.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "private_dns_zone_ids" {
  value = tomap({
    for private_dns_zone_key, private_dns_zone_name in var.private_dns_zones : private_dns_zone_key => {
      id = azurerm_private_dns_zone.this[private_dns_zone_key].id
    }
  })
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}
