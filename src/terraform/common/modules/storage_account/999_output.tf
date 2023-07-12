output "resource_group" {
  value = local.resource_group
}

output "storage_account" {
  value = azurerm_storage_account.this
}
