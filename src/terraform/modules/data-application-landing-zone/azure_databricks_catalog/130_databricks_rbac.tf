# https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group
resource "databricks_group" "da_ca" {
  provider     = databricks.azure_account
  display_name = "Catalog Admins (${data.azurerm_databricks_workspace.this.name})"
}

resource "databricks_group" "da_de" {
  provider     = databricks.azure_account
  display_name = "Data Engineers (${data.azurerm_databricks_workspace.this.name})"
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group
resource "databricks_group" "ca" {
  display_name = databricks_group.da_ca.display_name

  depends_on = [
    databricks_group.da_ca
  ]
}

resource "databricks_group" "de" {
  display_name = databricks_group.da_de.display_name

  depends_on = [
    databricks_group.da_de
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "metastore" {
  metastore = var.databricks_metastore_id
  grant {
    principal  = databricks_group.da_ca.display_name
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION", "CREATE_SHARE", "CREATE_RECIPIENT", "CREATE_PROVIDER"]
  }
}

resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.this.name
  grant {
    principal  = databricks_group.ca.display_name
    privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA", "CREATE_TABLE", "MODIFY"]
  }
  grant {
    principal  = databricks_group.de.display_name
    privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA", "CREATE_TABLE", "MODIFY"]
  }
}

resource "databricks_grants" "storage_credential" {
  storage_credential = databricks_storage_credential.this.id
  grant {
    principal  = databricks_group.ca.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.de.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_grants" "external_location" {
  external_location = databricks_external_location.this.id

  grant {
    principal  = databricks_group.ca.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
  grant {
    principal  = databricks_group.de.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
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