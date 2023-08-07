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

variable "grants" {
  type        = any
  description = "Default grants."
}

variable "owner" {
  type        = string
  description = "Owner of the Databricks catalog."
}
