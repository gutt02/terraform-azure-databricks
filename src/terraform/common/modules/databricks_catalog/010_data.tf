locals {
  resource_regex_storage_account = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Storage/storageAccounts/(.+)"
  storage_account_id             = var.storage_account_id == null ? null : var.storage_account_id
  storage_account_name           = var.storage_account_id == null ? null : regex(local.resource_regex_storage_account, var.storage_account_id)[2]
}