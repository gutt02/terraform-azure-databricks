variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "clz"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
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
