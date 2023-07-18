# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "this" {
  for_each = {
    for o in var.databricks_catalogs : o.name => o if var.enable_catalog
  }

  metastore = each.value.metastore.id

  dynamic "grant" {
    for_each = each.value.metastore.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_metastore_assignment.this]
}
