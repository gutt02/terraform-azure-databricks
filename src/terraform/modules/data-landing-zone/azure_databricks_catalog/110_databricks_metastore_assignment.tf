# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment
resource "databricks_metastore_assignment" "this" {
  workspace_id = data.azurerm_databricks_workspace.this.workspace_id
  metastore_id = var.databricks_metastore_id
}
