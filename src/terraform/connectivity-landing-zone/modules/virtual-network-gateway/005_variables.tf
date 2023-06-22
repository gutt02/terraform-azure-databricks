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

variable "gateway_subnet_id" {
  type        = string
  description = "Id of the Gateway Subnet."
}

variable "virtual_network_gateway" {
  type = object({
    type          = string
    vpn_type      = string
    active_active = optional(bool)
    enable_bgp    = optional(bool)
    sku           = string

    vpn_client_configuration = object({
      address_space        = list(string)
      vpn_client_protocols = list(string)

      root_certificate = object({
        name = string
      })
    })
  })

  default = {
    type     = "Vpn"
    vpn_type = "RouteBased"
    sku      = "VpnGw1"

    vpn_client_configuration = {
      address_space        = ["192.168.255.0/27"]
      vpn_client_protocols = ["IkeV2", "OpenVPN"]

      root_certificate = {
        name = "VnetGatewayConfig"
      }
    }
  }

  description = "Virtual network gateway details."
}
