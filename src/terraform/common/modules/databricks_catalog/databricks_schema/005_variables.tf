variable "databricks_access_connector_id" {
  type        = string
  description = "Id of the Azure Databricks access connector."
}

variable "databricks_catalog_id" {
  type        = string
  description = "Id of the Azure Databricks catalog."
}

variable "databricks_schema" {
  type        = any
  description = "Azure Databricks catalog / schema."
}

variable "filesystem_name" {
  type        = string
  description = "Name of the catalog filesystem."
}

variable "grants" {
  type        = any
  description = "Default grants."
}

variable "owner" {
  type        = string
  description = "Owner of the Databricks schema."
}

variable "storage_account_id" {
  type        = string
  description = "Id of the Storage Account for the meta data."
}

variable "storage_data_lake_gen2_filesystem" {
  type = any
  description = "Storage Data Lake Gen2 filesystem of the catalog, if schema and catalog share the same storage."
}
