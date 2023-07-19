variable "databricks_access_connector_id" {
  type        = string
  description = "Id of the Azure Databricks access connector."
}

variable "databricks_catalog" {
  type        = any
  description = "Azure Databricks catalog."
}

variable "databricks_metastore_id" {
  type        = string
  description = "Id of the Databricks metastore."
}

variable "owner" {
  type        = string
  description = "Owner of the Databricks catalog."
}

variable "storage_account_id" {
  type        = string
  description = "Id of the Storage Account for the meta data."
}
