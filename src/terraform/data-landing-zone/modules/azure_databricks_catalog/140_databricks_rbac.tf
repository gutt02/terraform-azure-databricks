# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group
resource "databricks_group" "da_ca" {
  provider = databricks.azure_account

  display_name = "Catalog Admins (${var.databricks_workspace.name})"
}

resource "databricks_group" "da_de" {
  provider     = databricks.azure_account
  display_name = "Data Engineers (${var.databricks_workspace.name})"
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
resource "databricks_mws_permission_assignment" "ca" {
  provider = databricks.azure_account

  workspace_id = var.databricks_workspace.workspace_id
  principal_id = databricks_group.da_ca.id
  permissions  = ["ADMIN"]

  depends_on = [
    databricks_metastore_assignment.this
  ]
}

resource "databricks_mws_permission_assignment" "de" {
  provider = databricks.azure_account

  workspace_id = var.databricks_workspace.workspace_id
  principal_id = databricks_group.da_de.id
  permissions  = ["USER"]

  depends_on = [
    databricks_metastore_assignment.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "metastore" {
  metastore = var.databricks_metastore_id
  grant {
    principal  = databricks_group.da_ca.display_name
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION", "CREATE_SHARE", "CREATE_RECIPIENT", "CREATE_PROVIDER"]
  }
  grant {
    principal  = databricks_group.da_de.display_name
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION", "CREATE_SHARE", "CREATE_RECIPIENT", "CREATE_PROVIDER"]
  }

  depends_on = [
    databricks_mws_permission_assignment.ca,
    databricks_mws_permission_assignment.de
  ]
}

resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.this.name
  grant {
    principal  = databricks_group.da_ca.display_name
    # privileges = ["CREATE_SCHEMA", "USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "USE_SCHEMA"]
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.da_de.display_name
    # privileges = ["CREATE_SCHEMA", "USE_CATALOG", "CREATE_FUNCTION", "CREATE_TABLE", "EXECUTE", "MODIFY", "REFRESH", "SELECT", "USE_SCHEMA"]
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_mws_permission_assignment.ca,
    databricks_mws_permission_assignment.de
  ]
}

resource "databricks_grants" "schema" {
  schema = databricks_schema.this.id
  grant {
    principal  = databricks_group.da_ca.display_name
    # privileges = ["CREATE_FUNCTION", "CREATE_TABLE", "EXECUTE", "MODIFY", "REFRESH", "SELECT"]
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.da_de.display_name
    # privileges = ["CREATE_FUNCTION", "CREATE_TABLE", "EXECUTE", "MODIFY", "REFRESH", "SELECT"]
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_mws_permission_assignment.ca,
    databricks_mws_permission_assignment.de
  ]
}

resource "databricks_grants" "storage_credential" {
  storage_credential = databricks_storage_credential.this.id
  grant {
    principal  = databricks_group.da_ca.display_name
    # privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.da_de.display_name
    # privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_mws_permission_assignment.ca,
    databricks_mws_permission_assignment.de
  ]
}

resource "databricks_grants" "external_location" {
  external_location = databricks_external_location.this.id

  grant {
    principal  = databricks_group.da_ca.display_name
    # privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_MANAGED_STORAGE", "READ_FILES", "WRITE_FILES"]
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.da_de.display_name
    # privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_MANAGED_STORAGE", "READ_FILES", "WRITE_FILES"]
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_mws_permission_assignment.ca,
    databricks_mws_permission_assignment.de
  ]
}

# # https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/user
# data "databricks_user" "this" {
#   user_name = "contact@me"
# }

# # https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member
# resource "databricks_group_member" "this" {
#   provider = databricks.azure_account

#   group_id  = databricks_group.da_ca.id
#   member_id = data.databricks_user.this.id
# }
