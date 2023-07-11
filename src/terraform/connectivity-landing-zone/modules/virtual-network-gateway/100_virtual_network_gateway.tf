# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "this" {
  resource_type  = "azurerm_virtual_network_gateway"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  resource_types = ["azurerm_public_ip"]
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file
# https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/sensitive_file
data "local_sensitive_file" "this" {
  filename = "${path.module}/certificates/P2SRootCert.cer"
}

# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "this" {
  name                = "${azurecaf_name.this.result}-pip"
  location            = var.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
resource "azurerm_virtual_network_gateway" "this" {
  name                = azurecaf_name.this.result
  location            = var.location
  resource_group_name = var.resource_group.name
  type                = var.virtual_network_gateway.type
  vpn_type            = var.virtual_network_gateway.vpn_type
  active_active       = var.virtual_network_gateway.active_active
  enable_bgp          = var.virtual_network_gateway.enable_bgp
  sku                 = var.virtual_network_gateway.sku

  ip_configuration {
    name                          = "IpConfig"
    public_ip_address_id          = azurerm_public_ip.this.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.this.id
  }

  vpn_client_configuration {
    address_space        = var.virtual_network_gateway.vpn_client_configuration.address_space
    vpn_client_protocols = var.virtual_network_gateway.vpn_client_configuration.vpn_client_protocols

    root_certificate {
      name             = var.virtual_network_gateway.vpn_client_configuration.root_certificate.name
      public_cert_data = data.local_sensitive_file.this.content
    }
  }

  lifecycle {
    ignore_changes = [
      vpn_client_configuration # required, certificates uploaed manually
    ]
  }
}
