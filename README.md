# Azure Virtual Machine Azmon

A comprehensive Terraform project for Azure Virtual Machine monitoring and management using Azure Monitor Agent (AMA).

## Project Structure

```
Azure Virtual Machine Azmon/
├── environment/
│   └── prod/           # Production environment configurations
│       ├── main.tf     # Main Terraform configuration
│       ├── variables.tf # Input variables
│       ├── outputs.tf  # Output values
│       └── terraform.tfvars.example # Configuration template
├── Modules/            # Reusable Terraform modules
│   ├── monitor/        # Log Analytics Workspace module
│   ├── Network/        # Networking infrastructure module
│   └── Compute/        # Virtual Machines module
├── Scripts/            # Automation and deployment scripts
│   ├── Quick-Start.ps1           # Complete deployment workflow
│   ├── Deploy-AMALab.ps1         # Interactive deployment script
│   └── Validate-TerraformConfig.ps1 # Configuration validation
├── .github/            # GitHub configuration and Copilot instructions
├── DEPLOYMENT.md       # Detailed deployment guide
└── README.md          # This file
```

## Overview

This project provides Terraform infrastructure-as-code for:
- **8 Virtual Machines** (4 Linux + 4 Windows) for AMA training
- **Log Analytics Workspace** for centralized monitoring
- **Virtual Network** with proper security groups
- **Complete networking setup** with public IPs and NSG rules

### Virtual Machines Created

| VM Name | OS | Size | Purpose |
|---------|----|----- |---------|
| LinAMAPortalDep | Ubuntu 22.04 LTS | Standard_D2s_v3 | DCR Portal Deployment Lab |
| LinAMAPSDeploy | Ubuntu 22.04 LTS | Standard_D2s_v3 | DCR PowerShell Deployment Lab |
| LinAMACLIDeploy | Ubuntu 22.04 LTS | Standard_D2s_v3 | DCR CLI Deployment Lab |
| LinAMAPolicyDep | Ubuntu 22.04 LTS | Standard_D2s_v3 | Agent Policy Based Deployment Lab |
| WinAMAPortalDep | Windows Server 2022 | Standard_D2s_v3 | DCR Portal Deployment Lab |
| WinAMAPSDeploy | Windows Server 2022 | Standard_D2s_v3 | DCR PowerShell Deployment Lab |
| WinAMACLIDeploy | Windows Server 2022 | Standard_D2s_v3 | DCR CLI Deployment Lab |
| WinAMAPolicyDep | Windows Server 2022 | Standard_D2s_v3 | Policy Based Agent Deployment Lab |

## 🚀 Quick Start

### Option 1: One-Click Deployment
```powershell
# Run the complete workflow (validation + deployment)
.\Scripts\Quick-Start.ps1
```

### Option 2: Step-by-Step
```powershell
# 1. Validate configuration
.\Scripts\Validate-TerraformConfig.ps1

# 2. Deploy infrastructure
.\Scripts\Deploy-AMALab.ps1
```

### Option 3: Manual Terraform
```powershell
# 1. Configure credentials
cd environment\prod
copy terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your username and password

# 2. Deploy
terraform init
terraform plan
terraform apply
```

## Prerequisites

- **Terraform** (>= 1.0)
- **Azure CLI** (logged in to your subscription)
- **PowerShell** (for deployment scripts)
- **Azure Subscription** with sufficient quota for 8 VMs

## Getting Started

1. **Clone or download** this project to your local machine
2. **Install prerequisites** (Terraform, Azure CLI)
3. **Login to Azure**: `az login`
4. **Run Quick Start**: `.\Scripts\Quick-Start.ps1`
5. **Follow the prompts** to configure and deploy

## 📖 Detailed Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide with troubleshooting
- **Terraform Modules** - Each module has its own documentation
- **Scripts** - PowerShell automation scripts with built-in help

## 🛡️ Security Configuration

### Current Security Setup
- **SSH access** (port 22) for Linux VMs
- **RDP access** (port 3389) for Windows VMs  
- **Public IPs** assigned to all VMs
- **Network Security Groups** with basic rules

### Security Recommendations
1. **Restrict NSG rules** to your specific IP address
2. **Use Azure Bastion** for secure access
3. **Enable Just-In-Time VM access**
4. **Stop VMs** when not in use to reduce costs

## 💰 Cost Estimation

**Approximate monthly costs:**
- 8 VMs (Standard_D2s_v3): $480-640/month
- Log Analytics Workspace: $2-10/month  
- Networking components: $5-15/month
- **Total: ~$487-665/month**

💡 **Cost Saving Tip**: Stop VMs when not actively training to significantly reduce costs!

## 🧹 Cleanup

To remove all resources:
```powershell
cd environment\prod
terraform destroy
```

⚠️ **Warning**: This permanently deletes all VMs and data!

## Contributing

When adding new components:
1. Follow the established module structure
2. Update documentation
3. Test with validation scripts
4. Follow Terraform best practices

## Technologies Used

- **Terraform** - Infrastructure as Code
- **Azure Resource Manager** - Cloud provider
- **PowerShell** - Automation scripts
- **Azure Monitor** - Monitoring and analytics

## Support

- Check **DEPLOYMENT.md** for troubleshooting
- Run validation scripts before deployment
- Review Terraform documentation for advanced configurations
