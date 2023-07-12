# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "this" {
  count = var.resource_group == null ? 1 : 0

  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dbw"]
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "this" {
  count = var.resource_group == null ? 1 : 0

  name     = azurecaf_name.this[0].result
  location = var.location
  tags     = var.tags
}

locals {
  resource_group = var.resource_group == null ? azurerm_resource_group.this[0] : var.resource_group
}
