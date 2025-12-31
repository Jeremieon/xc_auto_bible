output "public_vm_ip" {
  value       = azurerm_public_ip.public_vm.ip_address
  description = "Public IP of the public VM"
}

output "private_vm_private_ip" {
  value       = azurerm_network_interface.private_vm.private_ip_address
  description = "Private IP of the private VM"
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
