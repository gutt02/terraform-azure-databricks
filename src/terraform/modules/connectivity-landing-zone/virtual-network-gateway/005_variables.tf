variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["azc", "clz", "payg"]
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

# variable "subnets" {
#   type = map(object({
#     address_space       = string
#     client_address_pool = optional(string)
#     description         = optional(string)
#   }))

#   default = {
#     gateway = {
#       address_space       = "192.168.100.0/27"
#       client_address_pool = "192.168.255.0/27"
#       description         = "GatewaySubnet"
#     }
#   }

#   description = "VNET destails."
# }

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
