# Variables for Production Environment

variable "admin_username" {
  description = "The admin username for the virtual machines"
  type        = string
  
  validation {
    condition = length(var.admin_username) >= 3 && length(var.admin_username) <= 20
    error_message = "The admin username must be between 3 and 20 characters long."
  }
}

variable "admin_password" {
  description = "The admin password for the virtual machines"
  type        = string
  sensitive   = true
  
  validation {
    condition = length(var.admin_password) >= 12
    error_message = "The admin password must be at least 12 characters long."
  }
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US 3"
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "Production"
}
