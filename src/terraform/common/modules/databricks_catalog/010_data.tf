locals {
  default_databricks_api_delay = "5s"

  resource_regex_storage_account = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Storage/storageAccounts/(.+)"
  storage_account_id             = var.databricks_catalog.storage_account_id != null ? var.databricks_catalog.storage_account_id : null
  storage_account_name           = var.databricks_catalog.storage_account_id != null ? regex(local.resource_regex_storage_account, var.databricks_catalog.storage_account_id)[2] : null
}
