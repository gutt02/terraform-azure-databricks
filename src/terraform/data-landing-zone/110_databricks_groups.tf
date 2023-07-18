# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group
resource "databricks_group" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in distinct(concat(
      flatten(var.databricks_catalogs[*].metastore.grants[*].principal),
      flatten(var.databricks_catalogs[*].grants[*].principal),
      flatten(var.databricks_catalogs[*].schemas[*].grants[*].principal)
    )) : o => o if var.enable_catalog
  }

  display_name = each.key

  depends_on = [databricks_metastore_assignment.this]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
resource "databricks_mws_permission_assignment" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in distinct(concat(
      flatten(var.databricks_catalogs[*].metastore.grants[*].principal),
      flatten(var.databricks_catalogs[*].grants[*].principal),
      flatten(var.databricks_catalogs[*].schemas[*].grants[*].principal)
    )) : o => o if var.enable_catalog
  }

  workspace_id = module.databricks_workspace.databricks_workspace.workspace_id
  principal_id = databricks_group.this[each.key].id
  permissions  = ["USER"]
}
