# Resource Group
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

# VNet & Networking
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_cidr" {
  value = azurerm_virtual_network.main.address_space[0]
}

output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "outside_subnet_id" {
  value = azurerm_subnet.outside.id
}

output "inside_subnet_id" {
  value = azurerm_subnet.inside.id
}

# CE Instance

output "ce_public_ip" {
  value = azurerm_public_ip.ce_public_ip.ip_address
}

output "ce_outside_private_ip" {
  value = azurerm_network_interface.outside_nic.private_ip_address
}

output "ce_inside_private_ip" {
  value = azurerm_network_interface.inside_nic.private_ip_address
}

# Frontend App Instance

output "backend_private_ip" {
  value = azurerm_network_interface.private_vm.private_ip_address
}


# SSH Commands
output "ssh_to_ce" {
  value = "ssh -i ~/.ssh/id_rsa cloud-user@${azurerm_public_ip.ce_public_ip.ip_address}"
}

output "ssh_to_backend" {
  value = "ssh -i ~/.ssh/id_rsa -J cloud-user@${azurerm_public_ip.ce_public_ip.ip_address} ${var.ssh_username}@${azurerm_network_interface.private_vm.private_ip_address}"
}
