# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "kv" {
  resource_type = "azurerm_key_vault"
  prefixes      = var.global_settings.azurecaf_name.prefixes
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
resource "azurerm_key_vault" "this" {
  name                          = azurecaf_name.kv.result
  location                      = var.location
  resource_group_name           = local.resource_group.name
  enable_rbac_authorization     = true
  public_network_access_enabled = var.enable_private_endpoints ? false : true
  sku_name                      = "standard"
  tenant_id                     = var.client_config.tenant_id

  network_acls {
    bypass                     = "None"
    default_action             = var.enable_private_endpoints ? "Deny" : "Allow"
    ip_rules                   = var.enable_private_endpoints ? [] : distinct([var.agent_ip, replace(replace(var.client_ip.cidr, "/31", ""), "/32", "")])
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "this" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.client_config.object_id
}
