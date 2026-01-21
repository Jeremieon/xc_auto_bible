output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "outside_subnet_id" {
  value = azurerm_subnet.outside.id
}

output "inside_subnet_id" {
  value = azurerm_subnet.inside.id
}

output "azure_region" {
  value = var.location
}

output "outside_nsg_id" {
  value = azurerm_network_security_group.outside_nsg.id
}

output "inside_nsg_id" {
  value = azurerm_network_security_group.inside_nsg.id
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "random_suffix" {
  value = random_id.suffix.hex
}

output "f5xc_ce_site_name" {
  value = var.f5xc-ce-site-name
}
