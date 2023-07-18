# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "this" {
  resource_type = "azurerm_storage_account"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = var.global_settings.azurecaf_name.suffixes
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                     = azurecaf_name.this.result
  location                 = var.location
  resource_group_name      = var.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.enable_private_endpoints ? [] : distinct([var.agent_ip, replace(replace(var.client_ip.cidr, "/31", ""), "/32", "")])
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  identity {
    type = "SystemAssigned"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "service_principal" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.client_config.object_id
}
