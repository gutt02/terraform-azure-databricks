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

variable "owner" {
  type        = string
  description = "Owner of the Databricks schema."
}

variable "storage_account_id" {
  type = string
  description = "Id of the Storage Account for the meta data."
}
