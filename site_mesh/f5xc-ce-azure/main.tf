# Random generator
resource "random_id" "suffix" {
  byte_length = 2
}

#resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    name_prefix = "${var.name_prefix}"
  }
}

#VNET
resource "azurerm_virtual_network" "main" {
  name                = "vnet-main"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    name_prefix = "${var.name_prefix}-vnet"
  }
}

#Public Subnet
resource "azurerm_subnet" "public" {
  name                 = "${var.name_prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

#Outside Subnet
resource "azurerm_subnet" "outside" {
  name                 = "${var.name_prefix}-outside-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.outside_subnet_cidr]
}

# Inside Subnet
resource "azurerm_subnet" "inside" {
  name                 = "${var.name_prefix}-inside-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.inside_subnet_cidr]
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat" {
  name                = "${var.name_prefix}-nat-gateway-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Name = "${var.name_prefix}-nat-gateway-pip"
  }
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  name                    = "${var.name_prefix}-nat-gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4

  tags = {
    Name = "${var.name_prefix}-nat-gateway"
  }
}

# Associate Public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

# Associate NAT Gateway with Outside Subnet
resource "azurerm_subnet_nat_gateway_association" "outside" {
  subnet_id      = azurerm_subnet.outside.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Route Table for Inside Subnet (local only)
resource "azurerm_route_table" "inside" {
  name                = "${var.name_prefix}-inside-rt"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name


  tags = {
    Name = "${var.name_prefix}-inside-rt"
  }
}

# Associate Route Table with Inside Subnet
resource "azurerm_subnet_route_table_association" "inside" {
  subnet_id      = azurerm_subnet.inside.id
  route_table_id = azurerm_route_table.inside.id
}

# Azure Network Security Group for outside interface (SLO)
resource "azurerm_network_security_group" "ce_nsg_slo" {
  name                = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nsg-slo")
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "HTTP-HTTPS-SSH"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80", "443", "8080", "3000", "8000"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "IPSEC-from-all"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "4500"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "IPSEC-from-all"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "4500"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Name  = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nsg-slo")
    owner = var.owner
  }
}
# Create a public network interface
resource "azurerm_public_ip" "ce_public_ip" {
  name                = format("%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# CE Network Interfaces creation - Outside interface (private - using NAT Gateway for outbound)
resource "azurerm_network_interface" "outside" {
  name                  = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nic-outside")
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.outside.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.slo-private-ip
    public_ip_address_id          = azurerm_public_ip.ce_public_ip.id
  }

  tags = {
    Name  = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nic-outside")
    owner = var.owner
  }
}

# Network Security Group Association - Outside
resource "azurerm_network_interface_security_group_association" "outside" {
  network_interface_id      = azurerm_network_interface.outside.id
  network_security_group_id = azurerm_network_security_group.ce_nsg_slo.id
}

# CE Network Interfaces creation - Inside interface (private)
resource "azurerm_network_interface" "inside" {
  name                  = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nic-inside")
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name      = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "inside-ip")
    subnet_id = azurerm_subnet.inside.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.sli-private-ip
  }

  tags = {
    Name  = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "nic-inside")
    owner = var.owner
  }
}

# Create the F5XC CE Azure Virtual Machine resources
resource "azurerm_linux_virtual_machine" "f5xc_ce" {
  name                = format("%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.f5xc_sms_instance_type
  admin_username      = "cloud-user"

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.outside.id,
    azurerm_network_interface.inside.id,
  ]

  admin_ssh_key {
    username   = var.ssh_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.f5xc_sms_storage_account_type
    disk_size_gb         = 80
  }

  plan {
    name      = "f5xccebyol"
    publisher = "f5-networks"
    product   = "f5xc_customer_edge"
  }

  source_image_reference {
    publisher = "f5-networks"
    offer     = "f5xc_customer_edge"
    sku       = "f5xccebyol"
    version   = "2024.44.1"
  }

  custom_data = base64encode(data.cloudinit_config.f5xc_ce_config.rendered)
  depends_on  = [azurerm_resource_group.main]


  tags = {
    Name                                                                     = format("%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex)
    ves-io-site-name                                                         = format("%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex)
    "kubernetes.io-cluster-${var.f5xc-ce-site-name}-${random_id.suffix.hex}" = "owned"
    owner                                                                    = var.owner
  }
}


# Network Interface for Inside VM
resource "azurerm_network_interface" "private_vm" {
  name                = "${var.name_prefix}-nic-private-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.inside.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Private VM
resource "azurerm_linux_virtual_machine" "inside_vm" {
  name                = "${var.name_prefix}-vm-private"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = var.ssh_username

  network_interface_ids = [
    azurerm_network_interface.private_vm.id
  ]

  admin_ssh_key {
    username   = var.ssh_username
    public_key = var.ssh_public_key
  }

  custom_data = base64encode(<<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo docker run -d -p 8080:80 --restart always jeremy9k/foodwmagic:v0.1
  sudo docker run -d -p 3000:3000 --restart always bkimminich/juice-shop
  sudo docker run -d --name backend-app --restart always -p 8000:8000 jeremy9k/azure-bk:v1.0.0
EOF
  )



  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


