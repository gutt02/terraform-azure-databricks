locals {
  empty_privileges = [
    {
      type       = "catalog"
      privileges = []
    },
    {
      type       = "external_location"
      privileges = []
    },
    {
      type       = "storage_credential"
      privileges = []
    }
  ]

  default_privileges = {
    for g in var.grants : g.principal => {
      for t in g.object_privileges : t.type => t.privileges
    }
  }

  catalog_privileges = flatten([
    for grant_key, grant in var.databricks_catalog.grants : [
      for object_privileges_key, object_privilege in coalesce(grant.object_privileges, local.empty_privileges) : {
        principal  = grant.principal
        privileges = grant.use_default ? try(local.default_privileges[grant.principal][object_privilege.type], []) : try(object_privilege.privileges, [])
      } if object_privilege.type == "catalog"
    ]
  ])

  storage_credential_privileges = flatten([
    for grant_key, grant in var.databricks_catalog.grants : [
      for object_privileges_key, object_privilege in coalesce(grant.object_privileges, local.empty_privileges) : {
        principal  = grant.principal
        privileges = grant.use_default ? try(local.default_privileges[grant.principal][object_privilege.type], []) : try(object_privilege.privileges, [])
      } if object_privilege.type == "storage_credential"
    ]
  ])

  external_location_privileges = flatten([
    for grant_key, grant in var.databricks_catalog.grants : [
      for object_privileges_key, object_privilege in coalesce(grant.object_privileges, local.empty_privileges) : {
        principal  = grant.principal
        privileges = grant.use_default ? try(local.default_privileges[grant.principal][object_privilege.type], []) : try(object_privilege.privileges, [])
      } if object_privilege.type == "external_location"
    ]
  ])
}

# Note: Call the Databricks API in a sequence with a delay between the requests!
# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
resource "time_sleep" "delay_databricks_grants_catalog" {
  count = length(local.catalog_privileges) == 0 ? 0 : 1

  depends_on = [databricks_catalog.this]

  create_duration = local.default_databricks_api_delay
}

resource "time_sleep" "delay_databricks_grants_storage_credential" {
  count = local.storage_account_id == null || length(local.storage_credential_privileges) == 0 ? 0 : 1

  depends_on = [databricks_grants.catalog]

  create_duration = local.default_databricks_api_delay
}

resource "time_sleep" "delay_databricks_grants_external_location" {
  count = local.storage_account_id == null || length(local.external_location_privileges) == 0 ? 0 : 1

  depends_on = [databricks_grants.storage_credential]

  create_duration = local.default_databricks_api_delay
}

# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants
resource "databricks_grants" "catalog" {
  count = length(local.catalog_privileges) == 0 ? 0 : 1

  catalog = databricks_catalog.this.name

  dynamic "grant" {
    for_each = local.catalog_privileges
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [time_sleep.delay_databricks_grants_catalog]
}

resource "databricks_grants" "storage_credential" {
  count = local.storage_account_id == null || length(local.storage_credential_privileges) == 0 ? 0 : 1

  storage_credential = databricks_storage_credential.this[0].id

  dynamic "grant" {
    for_each = local.storage_credential_privileges
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [time_sleep.delay_databricks_grants_storage_credential]
}

resource "databricks_grants" "external_location" {
  count = local.storage_account_id == null || length(local.external_location_privileges) == 0 ? 0 : 1

  external_location = databricks_external_location.this[0].id

  dynamic "grant" {
    for_each = local.external_location_privileges
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [time_sleep.delay_databricks_grants_external_location]
}
