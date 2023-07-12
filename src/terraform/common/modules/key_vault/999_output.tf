output "resource_group" {
  value = local.resource_group
}

output "key_vault" {
  value = azurerm_key_vault.this
}
