terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }

    azurecaf = {
      source  = "aztfmod/azurecaf"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "client_config" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "subscription" {
}
