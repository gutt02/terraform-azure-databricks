# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "this" {
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dbw"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "this" {
  name     = azurecaf_name.this.result
  location = var.location
  tags     = var.tags
}
