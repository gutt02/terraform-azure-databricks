# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
# Note: Only needed if the Storage Accounts have been created beforehand.
# resource "azurerm_role_assignment" "catalog" {
#   for_each = {
#     for o in distinct(
#       concat(
#         flatten(var.unity_catalog.catalogs[*].storage_account_id),
#         flatten(var.unity_catalog.catalogs[*].schemas[*].storage_account_id)
#       )
#     ) : o => o if var.enable_catalog && o != null && o != module.storage_account_uc.storage_account.name
#   }

#   scope                = each.value
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = module.databricks_access_connector.databricks_access_connector.identity[0].principal_id
# }

resource "azurerm_role_assignment" "this" {
  scope                = module.storage_account_uc.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.databricks_access_connector.databricks_access_connector.identity[0].principal_id
}
