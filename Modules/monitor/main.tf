# Monitor Module - Log Analytics Workspace

# Log Analytics Workspace for AMA Training
resource "azurerm_log_analytics_workspace" "ama_training_workspace" {
  name                       = var.workspace_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  retention_in_days          = var.retention_in_days
  internet_ingestion_enabled = true
  internet_query_enabled     = true

  tags = var.tags
}
