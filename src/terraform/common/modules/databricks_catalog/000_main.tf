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

module "databricks_schema" {
  source = "./databricks_schema"

  for_each = {
    for o in var.databricks_catalog.schemas : o.name => o
  }

  client_config               = var.client_config
  subscription                = var.subscription
  databricks_access_connector = var.databricks_access_connector
  databricks_catalog          = databricks_catalog.this
  databricks_schema           = each.value
  databricks_workspace        = var.databricks_workspace
  storage_account_id          = coalesce(each.value.storage_account_id, var.databricks_catalog.storage_account_id, var.storage_account_id)
}
