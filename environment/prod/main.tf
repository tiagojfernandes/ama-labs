# Production Environment Configuration for Azure Virtual Machine Monitoring

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Resource Group for AMA Training
resource "azurerm_resource_group" "ama_training" {
  name     = "AMATraining"
  location = "West US 3"

  tags = {
    Environment = "Production"
    Project     = "AMA Training"
    CreatedBy   = "Terraform"
  }
}

# Call the monitor module to create Log Analytics Workspace
module "monitor" {
  source = "../../Modules/monitor"

  workspace_name      = "AMATrainingWorkspace"
  resource_group_name = azurerm_resource_group.ama_training.name
  location            = azurerm_resource_group.ama_training.location

  tags = {
    Environment = "Production"
    Project     = "AMA Training"
    CreatedBy   = "Terraform"
  }

  depends_on = [azurerm_resource_group.ama_training]
}

# Call the network module to create networking infrastructure
module "network" {
  source = "../../Modules/Network"

  resource_group_name = azurerm_resource_group.ama_training.name
  location            = azurerm_resource_group.ama_training.location

  tags = {
    Environment = "Production"
    Project     = "AMA Training"
    CreatedBy   = "Terraform"
  }

  depends_on = [azurerm_resource_group.ama_training]
}

# Call the compute module to create Virtual Machines
module "compute" {
  source = "../../Modules/Compute"

  resource_group_name = azurerm_resource_group.ama_training.name
  location            = azurerm_resource_group.ama_training.location
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  # Network inputs from Network module
  subnet_id = module.network.subnet_id
  nsg_id    = module.network.nsg_id

  tags = {
    Environment = "Production"
    Project     = "AMA Training"
    CreatedBy   = "Terraform"
  }

  depends_on = [azurerm_resource_group.ama_training, module.network]
}
