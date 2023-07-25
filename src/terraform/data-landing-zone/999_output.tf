output "databricks_workspace_workspace_url" {
  value = module.databricks_workspace.databricks_workspace.workspace_url
}

output "storage_account_id" {
  value = module.storage_account_uc.storage_account.id
}