variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

variable "global_settings" {
  type        = any
  description = "Global settings."
}

variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}

variable "dns_private_resolver_inbound_subnet_id" {
  type        = string
  description = "Id of the inbound subnet for the DNS Private Resolver."
}

variable "dns_private_resolver_outbound_subnet_id" {
  type        = string
  description = "Id of the outbound subnet for the DNS Private Resolver."
}
