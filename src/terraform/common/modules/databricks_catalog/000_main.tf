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

  databricks_access_connector_id    = var.databricks_access_connector_id
  databricks_catalog_id             = databricks_catalog.this.id
  databricks_schema                 = each.value
  filesystem_name                   = var.databricks_catalog.filesystem_name
  grants                            = var.grants
  owner                             = each.value.owner != null ? each.value.owner : var.owner
  storage_account_id                = var.databricks_catalog.storage_account_id
  storage_data_lake_gen2_filesystem = azurerm_storage_data_lake_gen2_filesystem.this

  depends_on = [databricks_catalog.this]
}
