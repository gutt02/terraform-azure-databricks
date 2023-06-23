output "databricks_metastore" {
  value = try(module.azure_databricks_metastore[0].databricks_metastore, "unavailable")
}
