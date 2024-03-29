variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

# curl ipinfo.io/ip
variable "global_settings" {
  type        = any
  description = "Global settings."
}

variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}

variable "on_premises_networks" {
  type = list(object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  }))

  description = "List of on premises networks."
}

variable "private_dns_zones" {
  type        = map(string)
  description = "Map of private DNS zones."
}

variable "resource_group" {
  type        = any
  description = "Resource group."
}

variable "virtual_network" {
  type = object({
    address_space = string

    subnets = map(object({
      address_space       = string
      client_address_pool = optional(string)
      description         = optional(string)
    }))
  })

  description = "VNET details."
}
