# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "this" {
  for_each = {
    for o in distinct(concat(
      flatten(var.databricks_catalogs[*].storage_account_id),
      flatten(var.databricks_catalogs[*].schemas[*].storage_account_id),
      try([module.storage_account_uc[0].storage_account.id], [])
    )) : o => o if var.enable_catalog && o != null
  }

  scope                = each.value
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.databricks_access_connector[0].databricks_access_connector.identity[0].principal_id
}
