terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.62.0"
    }

    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurecaf" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "this" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "this" {
}

module "shared" {
  source = "./modules/shared"

  client_config        = data.azurerm_client_config.this
  subscription         = data.azurerm_subscription.this
  agent_ip             = var.agent_ip
  client_ip            = var.client_ip
  client_secret        = var.client_secret
  global_settings      = var.global_settings
  location             = var.location
  on_premises_networks = var.on_premises_networks
  private_dns_zones    = var.private_dns_zones
  tags                 = var.tags
  virtual_network      = var.virtual_network
}

module "dns_private_resolver" {
  source = "./modules/dns-private-resolver"

  count = var.enable_module_dns_private_resolver ? 1 : 0

  client_config                           = data.azurerm_client_config.this
  subscription                            = data.azurerm_subscription.this
  global_settings                         = var.global_settings
  location                                = var.location
  dns_private_resolver_inbound_subnet_id  = module.shared.dns_private_resolver_inbound_subnet_id
  dns_private_resolver_outbound_subnet_id = module.shared.dns_private_resolver_outbound_subnet_id

  depends_on = [
    module.shared
  ]
}

module "virtual_network_gateway" {
  source = "./modules/virtual-network-gateway"

  count = var.enable_module_virtual_network_gateway ? 1 : 0

  client_config           = data.azurerm_client_config.this
  subscription            = data.azurerm_subscription.this
  global_settings         = var.global_settings
  location                = var.location
  gateway_subnet_id       = module.shared.gateway_subnet_id
  virtual_network_gateway = var.virtual_network_gateway

  depends_on = [
    module.dns_private_resolver
  ]
}
