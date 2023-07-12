terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.connectivity_landing_zone]
    }

    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}
