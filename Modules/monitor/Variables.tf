# Variables for Monitor Module

variable "workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
  default     = "AMATrainingWorkspace"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "AMATraining"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US 3"
}

variable "sku" {
  description = "The SKU of the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
  validation {
    condition = contains([
      "Free",
      "PerNode",
      "Premium",
      "Standard",
      "Standalone",
      "Unlimited",
      "CapacityReservation",
      "PerGB2018"
    ], var.sku)
    error_message = "The sku must be one of the following: Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, PerGB2018."
  }
}

variable "retention_in_days" {
  description = "The workspace data retention in days"
  type        = number
  default     = 30
  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Retention period must be between 30 and 730 days."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "Training"
    Project     = "AMA"
    CreatedBy   = "Terraform"
  }
}
