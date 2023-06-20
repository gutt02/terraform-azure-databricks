output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "databricks_public_subnet_id" {
  value = azurerm_subnet.databricks_public.id
}

output "databricks_private_subnet_id" {
  value = azurerm_subnet.databricks_private.id
}

output "databricks_public_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.databricks_public.id
}

output "databricks_private_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.databricks_private.id
}

output "private_dns_zone_ids" {
  value = tomap({
    for private_dns_zone_key, private_dns_zone_name in var.private_dns_zones : private_dns_zone_key => {
      id = azurerm_private_dns_zone.this[private_dns_zone_key].id
    }
  })
}
