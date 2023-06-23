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

variable "connectivity_landing_zone_private_dns_zone_azuredatabricks" {
  type        = any
  description = "The private dns zone for Azure Databricks in the connectivity subscription."
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
  description = "The databricks public network security association"
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

variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  description = "Default tags for resources, only applied to resource groups"
}

variable "virtual_network" {
  type        = any
  description = "The virtual network"
}
