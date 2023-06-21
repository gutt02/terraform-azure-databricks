variable "agent_ip" {
  type        = string
  description = "IP of the deployment agent."
}

variable "client_ip" {
  type = object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  })

  description = "Client IP."
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "connectivity_landing_zone_private_dns_zone_azuredatabricks_id" {
  type        = string
  description = "Id of the private dns zone for Azure Databricks in the connectivity subscription."
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

variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Enable private endpoints."
}

variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "dmz"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
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
    created_by  = "azc-iac-acf-sp-tf"
    contact     = "contact@me"
    customer    = "Azure"
    environment = "Cloud Foundation"
    project     = "Data Management Zone"
  }

  description = "Default tags for resources, only applied to resource groups"
}
