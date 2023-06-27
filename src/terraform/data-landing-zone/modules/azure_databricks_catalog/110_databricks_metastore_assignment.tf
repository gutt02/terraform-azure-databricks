# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment
resource "databricks_metastore_assignment" "this" {
  workspace_id = var.databricks_workspace.workspace_id
  metastore_id = var.databricks_metastore_id
}
