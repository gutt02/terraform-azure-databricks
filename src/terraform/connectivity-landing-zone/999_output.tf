output "gateway_subnet_id" {
  value = module.shared.gateway_subnet_id
}

output "private_dns_zone_ids" {
  value = tomap({
    for private_dns_zone_key, private_dns_zone_name in var.private_dns_zones : private_dns_zone_key => {
      id = module.shared.private_dns_zones[private_dns_zone_key].id
    }
  })
}

output "virtual_network_id" {
  value = module.shared.virtual_network_id
}
