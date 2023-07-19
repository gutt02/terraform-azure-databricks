# Note: This is a workaround. Databricks Account Groups should be created in the Azure AD and
# synced with the Azure Databricks SCIM Provisioning Connector.
# Note: The service principal needs the rights to create a catalog, schema, etc.
# https://learn.microsoft.com/en-us/azure/databricks/administration-guide/users-groups/scim/aad

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group
resource "databricks_group" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in var.unity_catalog.groups : o.name => o if var.enable_catalog
  }

  display_name = each.value.name

  depends_on = [databricks_metastore_assignment.this]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group
data "databricks_group" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in var.unity_catalog.groups : o.name => o if var.enable_catalog
  }

  display_name = each.value.name

  depends_on = [
    databricks_metastore_assignment.this,
    databricks_group.this
  ]
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment
resource "databricks_mws_permission_assignment" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in var.unity_catalog.groups : o.name => o if var.enable_catalog
  }

  workspace_id = module.databricks_workspace.databricks_workspace.workspace_id
  principal_id = data.databricks_group.this[each.key].id
  permissions  = each.value.permissions
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/service_principal
data "databricks_service_principal" "this" {
  provider = databricks.azure_account

  application_id = data.azurerm_client_config.this.client_id
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member
resource "databricks_group_member" "this" {
  provider = databricks.azure_account

  for_each = {
    for o in var.unity_catalog.groups : o.name => o if var.enable_catalog
  }

  group_id  = data.databricks_group.this[each.key].id
  member_id = data.databricks_service_principal.this.id
}
