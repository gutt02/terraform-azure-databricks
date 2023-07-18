# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.this.name

  dynamic "grant" {
    for_each = var.databricks_catalog.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

resource "databricks_grants" "storage_credential" {
  storage_credential = databricks_storage_credential.this.id

  dynamic "grant" {
    for_each = var.databricks_catalog.grants
    content {
      principal  = grant.value.principal
      privileges = ["ALL_PRIVILEGES"]
    }
  }

  depends_on = [databricks_storage_credential.this]
}

resource "databricks_grants" "external_location" {
  external_location = databricks_external_location.this.id

  dynamic "grant" {
    for_each = var.databricks_catalog.grants
    content {
      principal  = grant.value.principal
      privileges = ["ALL_PRIVILEGES"]
    }
  }

  depends_on = [databricks_external_location.this]
}
