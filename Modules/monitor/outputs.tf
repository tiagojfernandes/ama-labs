# Outputs for Log Analytics Workspace

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.ama_training_workspace.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.ama_training_workspace.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "The primary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.ama_training_workspace.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_shared_key" {
  description = "The secondary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.ama_training_workspace.secondary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace ID (GUID) of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.ama_training_workspace.workspace_id
}
