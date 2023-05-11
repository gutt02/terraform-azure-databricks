variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "connectivity_landing_zone_private_dns_zone_azuredatabricks_id" {
  type        = string
  description = "Id of the private dns zone for Azure Databricks in the connectivity subscription."
}

variable "databricks_metastore_id" {
  type        = string
  description = "The Databricks Metastore Id."
}

variable "databricks_private_network_security_group_association_id" {
  type        = string
  description = "Id of the databricks private network security association"
}

variable "databricks_private_subnet_id" {
  type        = string
  description = "Id of the databricks private subnet."
}

variable "databricks_public_network_security_group_association_id" {
  type        = string
  description = "Id of the databricks public network security association"
}

variable "databricks_public_subnet_id" {
  type        = string
  description = "Id of the databricks public subnet."
}

variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["azc", "dalz", "payg"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "private_dns_zone_azuredatabricks_id" {
  type        = string
  description = "Id of the private dns zone for Azure Databricks."
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Id of the private endpoints subnet."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  default = {
    created_by  = "azc-iac-payg-sp-tf"
    contact     = "contact@me"
    customer    = "Azure Cloud"
    environment = "Pay As You Go"
    project     = "Playground"
  }

  description = "Default tags for resources, only applied to resource groups"
}
