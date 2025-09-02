# Outputs for Network Module

output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.ama_training_vnet.id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.ama_training_vnet.name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.ama_training_subnet.id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.ama_training_subnet.name
}

output "linux_nsg_id" {
  description = "The ID of the Linux network security group"
  value       = azurerm_network_security_group.linux_nsg.id
}

output "linux_nsg_name" {
  description = "The name of the Linux network security group"
  value       = azurerm_network_security_group.linux_nsg.name
}

output "windows_nsg_id" {
  description = "The ID of the Windows network security group"
  value       = azurerm_network_security_group.windows_nsg.id
}

output "windows_nsg_name" {
  description = "The name of the Windows network security group"
  value       = azurerm_network_security_group.windows_nsg.name
}

# Combined output for easy reference
output "network_info" {
  description = "Network configuration information"
  value = {
    vnet = {
      id   = azurerm_virtual_network.ama_training_vnet.id
      name = azurerm_virtual_network.ama_training_vnet.name
    }
    subnet = {
      id   = azurerm_subnet.ama_training_subnet.id
      name = azurerm_subnet.ama_training_subnet.name
    }
    security_groups = {
      linux = {
        id   = azurerm_network_security_group.linux_nsg.id
        name = azurerm_network_security_group.linux_nsg.name
      }
      windows = {
        id   = azurerm_network_security_group.windows_nsg.id
        name = azurerm_network_security_group.windows_nsg.name
      }
    }
  }
}
