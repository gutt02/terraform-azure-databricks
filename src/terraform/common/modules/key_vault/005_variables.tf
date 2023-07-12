variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

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

variable "private_dns_zones" {
  type        = any
  description = "The private dns zones for BLOBs, Data Lake File systems, etc."
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

variable "resource_group" {
  type        = any
  description = "Resource group."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  description = "Default tags for resources, only applied to resource groups."
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "Id of virtual network subnets."
}
