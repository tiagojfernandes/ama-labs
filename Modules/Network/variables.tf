# Variables for Network Module

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US 3"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "ama-training-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "ama-training-subnet"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "linux_nsg_name" {
  description = "The name of the Linux network security group"
  type        = string
  default     = "linux-nsg"
}

variable "windows_nsg_name" {
  description = "The name of the Windows network security group"
  type        = string
  default     = "windows-nsg"
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
