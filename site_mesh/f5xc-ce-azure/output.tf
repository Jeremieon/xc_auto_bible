# CE Instance

output "ce_public_ip" {
  value = azurerm_public_ip.ce_public_ip.ip_address
}

#backend IP
output "backend_private_ip" {
  value = azurerm_network_interface.private_vm.private_ip_address
}

# site Name


output "azure_site_name" {
  value = volterra_securemesh_site_v2.site.name
}
