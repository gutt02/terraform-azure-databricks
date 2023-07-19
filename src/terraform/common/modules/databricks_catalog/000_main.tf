terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    azurecaf = {
      source = "aztfmod/azurecaf"
    }

    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "time_sleep" "delay_schema_deployment" {
  depends_on = [
    # databricks_grants.catalog,
    # databricks_grants.storage_credential,
    # databricks_grants.external_location
  ]

  create_duration = "60s"
}

module "databricks_schema" {
  source = "./databricks_schema"

  for_each = {
    for o in var.databricks_catalog.schemas : o.name => o
  }

  databricks_access_connector_id = var.databricks_access_connector_id
  databricks_catalog_id          = databricks_catalog.this.id
  databricks_schema              = each.value
  owner                          = each.value.owner != null ? each.value.owner : var.owner
  storage_account_id             = each.value.storage_account_id != null ? each.value.storage_account_id : var.storage_account_id

  depends_on = [time_sleep.delay_schema_deployment]
}
