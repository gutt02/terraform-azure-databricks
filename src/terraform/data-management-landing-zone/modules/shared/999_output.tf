output "private_endpoints_subnet" {
  value = azurerm_subnet.private_endpoints
}

output "databricks_public_subnet" {
  value = azurerm_subnet.databricks_public
}

output "databricks_private_subnet" {
  value = azurerm_subnet.databricks_private
}

output "databricks_public_network_security_group_association" {
  value = azurerm_subnet_network_security_group_association.databricks_public
}

output "databricks_private_network_security_group_association" {
  value = azurerm_subnet_network_security_group_association.databricks_private
}

output "virtual_network" {
  value = azurerm_virtual_network.this
}
