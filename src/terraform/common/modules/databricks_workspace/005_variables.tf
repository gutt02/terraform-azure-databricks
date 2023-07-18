variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

variable "databricks_private_network_security_group_association" {
  type        = any
  description = "The databricks private network security association."
}

variable "databricks_private_subnet" {
  type        = any
  description = "The databricks private subnet."
}

variable "databricks_public_network_security_group_association" {
  type        = any
  description = "The databricks public network security association."
}

variable "databricks_public_subnet" {
  type        = any
  description = "The databricks public subnet."
}

variable "enable_private_endpoints" {
  type        = bool
  description = "Enable private endpoints."
}

variable "global_settings" {
  type        = any
  description = "Global settings."
}

variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}

variable "private_dns_zone_azuredatabricks_backend" {
  type        = any
  description = "The private dns zone for Azure Databricks for the backend."
}

variable "private_dns_zone_azuredatabricks_frontend" {
  type        = any
  description = "The private dns zone for Azure Databricks for the frontend."
}

variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
}

variable "resource_group" {
  type        = any
  description = "Resource group."
}

variable "virtual_network" {
  type        = any
  description = "The virtual network."
}
