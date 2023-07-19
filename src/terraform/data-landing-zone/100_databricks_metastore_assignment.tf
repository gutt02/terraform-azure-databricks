# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment
resource "databricks_metastore_assignment" "this" {
  count = var.enable_catalog ? 1 : 0

  workspace_id = module.databricks_workspace.databricks_workspace.workspace_id
  metastore_id = var.unity_catalog.metastore.id
}
