# Network Module - Networking Infrastructure for AMA Training

# Virtual Network for all VMs
resource "azurerm_virtual_network" "ama_training_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Subnet for VMs
resource "azurerm_subnet" "ama_training_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ama_training_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# Network Security Group for Linux VMs
resource "azurerm_network_security_group" "linux_nsg" {
  name                = var.linux_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # SSH access rule
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Optional: Add more restrictive SSH rule (uncomment and modify as needed)
  # security_rule {
  #   name                       = "SSH_Restricted"
  #   priority                   = 1000
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "22"
  #   source_address_prefix      = "YOUR_PUBLIC_IP/32"  # Replace with your IP
  #   destination_address_prefix = "*"
  # }

  tags = var.tags
}

# Network Security Group for Windows VMs
resource "azurerm_network_security_group" "windows_nsg" {
  name                = var.windows_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # RDP access rule
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Optional: Add more restrictive RDP rule (uncomment and modify as needed)
  # security_rule {
  #   name                       = "RDP_Restricted"
  #   priority                   = 1000
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "3389"
  #   source_address_prefix      = "YOUR_PUBLIC_IP/32"  # Replace with your IP
  #   destination_address_prefix = "*"
  # }

  # Optional: Allow HTTP for web access if needed
  # security_rule {
  #   name                       = "HTTP"
  #   priority                   = 1002
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "80"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  # Optional: Allow HTTPS for secure web access if needed
  # security_rule {
  #   name                       = "HTTPS"
  #   priority                   = 1003
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "443"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  tags = var.tags
}
