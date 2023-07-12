output "gateway_subnet_id" {
  value = module.shared.gateway_subnet_id
}

output "private_dns_resolver_inbound_endpoint_private_ip_address" {
  value = try(module.dns_private_resolver[0].private_dns_resolver_inbound_endpoint.ip_configurations[0].private_ip_address, "unavailable")
}

output "private_dns_zone_ids" {
  value = {
    for private_dns_zone_key, private_dns_zone_name in var.private_dns_zones : private_dns_zone_key => {
      id = module.shared.private_dns_zones[private_dns_zone_key].id
    }
  }
}

output "virtual_network_id" {
  value = module.shared.virtual_network_id
}
