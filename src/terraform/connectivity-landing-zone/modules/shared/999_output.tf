output "dns_private_resolver_inbound_subnet_id" {
  value = azurerm_subnet.dns_private_resolver_inbound.id
}

output "dns_private_resolver_outbound_subnet_id" {
  value = azurerm_subnet.dns_private_resolver_outbound.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}

output "private_dns_zones" {
  value = azurerm_private_dns_zone.this
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "resource_group" {
  value = local.resource_group
}

output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}
