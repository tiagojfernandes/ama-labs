# Variables for Compute Module

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US 3"
}

variable "admin_username" {
  description = "The admin username for the virtual machines"
  type        = string
  default     = "youralias"
}

variable "admin_password" {
  description = "The admin password for the virtual machines"
  type        = string
  sensitive   = true
}

# Network inputs from Network module
variable "subnet_id" {
  description = "The ID of the subnet for VM placement"
  type        = string
}

variable "linux_nsg_id" {
  description = "The ID of the Linux network security group"
  type        = string
}

variable "windows_nsg_id" {
  description = "The ID of the Windows network security group"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "Training"
    Project     = "AMA"
    CreatedBy   = "Terraform"
  }
}
