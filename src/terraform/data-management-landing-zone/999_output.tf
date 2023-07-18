output "databricks_metastore" {
  value = try(module.databricks_metastore[0].databricks_metastore, "unavailable")
}

output "databricks_workspace_workspace_url" {
  value = module.databricks_workspace.databricks_workspace.workspace_url
}
