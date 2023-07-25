# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
resource "time_sleep" "delay_databricks_grants_this" {
  count = var.enable_catalog ? 1 : 0

  depends_on = [databricks_metastore_assignment.this]

  create_duration = local.default_databricks_api_delay
}

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

  depends_on = [time_sleep.delay_databricks_grants_this]
}
