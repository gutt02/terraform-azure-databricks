# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "this" {
  count = var.enable_catalog ? 1 : 0

  metastore = var.unity_catalog.metastore.id

  dynamic "grant" {
    for_each = var.unity_catalog.metastore.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_metastore_assignment.this]
}
