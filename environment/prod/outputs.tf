# Production Environment Outputs

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.ama_training.id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.ama_training.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = module.monitor.log_analytics_workspace_id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = module.monitor.log_analytics_workspace_name
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace ID (GUID) of the Log Analytics Workspace"
  value       = module.monitor.log_analytics_workspace_workspace_id
}

# Network Information
output "network_info" {
  description = "Network configuration information"
  value       = module.network.network_info
}

# Virtual Machine Information
output "linux_vms" {
  description = "Information about Linux virtual machines"
  value       = module.compute.linux_vms
}

output "windows_vms" {
  description = "Information about Windows virtual machines"
  value       = module.compute.windows_vms
}

output "vm_connection_info" {
  description = "Connection information for all virtual machines"
  value       = module.compute.all_vm_connection_info
}
