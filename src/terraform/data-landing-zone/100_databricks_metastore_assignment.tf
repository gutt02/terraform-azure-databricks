# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment
resource "databricks_metastore_assignment" "this" {
  for_each = {
    for o in distinct(var.databricks_catalogs[*].metastore.id) : o => o if var.enable_catalog
  }

  workspace_id = module.databricks_workspace.databricks_workspace.workspace_id
  metastore_id = each.value
}
