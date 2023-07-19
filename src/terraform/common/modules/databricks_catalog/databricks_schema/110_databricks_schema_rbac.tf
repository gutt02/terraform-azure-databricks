# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "schema" {
  schema = databricks_schema.this.id

  dynamic "grant" {
    for_each = var.databricks_schema.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges.schema
    }
  }
}

resource "databricks_grants" "storage_credential" {
  count = local.storage_account_id != null ? 1 : 0

  storage_credential = databricks_storage_credential.this[0].id

  dynamic "grant" {
    for_each = var.databricks_schema.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges.storage_credential
    }
  }

  depends_on = [databricks_storage_credential.this]
}

resource "databricks_grants" "external_location" {
  count = local.storage_account_id != null ? 1 : 0

  external_location = databricks_external_location.this[0].id

  dynamic "grant" {
    for_each = var.databricks_schema.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges.external_location
    }
  }

  depends_on = [databricks_external_location.this]
}
