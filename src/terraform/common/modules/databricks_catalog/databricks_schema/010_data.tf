locals {
  resource_regex_storage_account = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Storage/storageAccounts/(.+)"
  subscription_id                = regex(local.resource_regex_storage_account, var.storage_account_id)[0]
  resource_group_name            = regex(local.resource_regex_storage_account, var.storage_account_id)[1]
  storage_account_name           = regex(local.resource_regex_storage_account, var.storage_account_id)[2]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account
data "azurerm_storage_account" "this" {
  name                = local.storage_account_name
  resource_group_name = local.resource_group_name
}
