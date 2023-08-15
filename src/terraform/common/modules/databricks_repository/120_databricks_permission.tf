# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions#repos-usage
resource "databricks_permissions" "repo_usage" {
  count = length(var.databricks_repository.permissions) == 0 ? 0 : 1

  repo_id = databricks_repo.this.id

  dynamic "access_control" {
    for_each = var.databricks_repository.permissions

    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }

  depends_on = [databricks_repo.this]
}
