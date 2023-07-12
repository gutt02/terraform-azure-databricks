output "databricks_workspace" {
  value = azurerm_databricks_workspace.this
}

output "resource_group" {
  value = local.resource_group
}
