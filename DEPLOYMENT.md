# AMA Training Lab - Terraform Deployment Guide

This guide explains how to deploy the Azure Monitor Agent (AMA) Training Lab infrastructure using Terraform.

## 📋 Prerequisites

### 1. Install Required Tools
- **Terraform** (>= 1.0): [Download here](https://www.terraform.io/downloads.html)
- **Azure CLI**: [Download here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **PowerShell** (for deployment script)

### 2. Azure Setup
```powershell
# Login to Azure
az login

# Verify your subscription
az account show

# Set specific subscription if needed
az account set --subscription "your-subscription-id"
```

## 🏗️ Infrastructure Overview

This deployment creates:
- **Resource Group**: AMATraining (West US 3)
- **Log Analytics Workspace**: AMATrainingWorkspace
- **Virtual Network**: ama-training-vnet (10.0.0.0/16)
- **Subnet**: ama-training-subnet (10.0.1.0/24)
- **Network Security Groups**: Linux (SSH) and Windows (RDP)
- **8 Virtual Machines**: 4 Linux + 4 Windows (Standard_D2s_v3)

### VM Details
| VM Name | OS | Purpose |
|---------|----|---------| 
| LinAMAPortalDep | Ubuntu 22.04 LTS | DCR Portal Deployment Lab |
| LinAMAPSDeploy | Ubuntu 22.04 LTS | DCR PowerShell Deployment Lab |
| LinAMACLIDeploy | Ubuntu 22.04 LTS | DCR CLI Deployment Lab |
| LinAMAPolicyDep | Ubuntu 22.04 LTS | Agent Policy Based Deployment Lab |
| WinAMAPortalDep | Windows Server 2022 | DCR Portal Deployment Lab |
| WinAMAPSDeploy | Windows Server 2022 | DCR PowerShell Deployment Lab |
| WinAMACLIDeploy | Windows Server 2022 | DCR CLI Deployment Lab |
| WinAMAPolicyDep | Windows Server 2022 | Policy Based Agent Deployment Lab |

## 🚀 Deployment Methods

### Method 1: Automated Script (Recommended)
```powershell
# Run the automated deployment script
C:\Codes\Virtual Machines AzMon\Scripts\Deploy-AMALab.ps1
```

The script will:
1. Check prerequisites (Terraform, Azure CLI)
2. Prompt for your username (alias)
3. Prompt for secure password
4. Create terraform.tfvars automatically
5. Run terraform init, plan, and apply

### Method 2: Manual Deployment

#### Step 1: Configure Variables
```powershell
cd "C:\Codes\Virtual Machines AzMon\environment\prod"

# Copy the example file
copy terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
notepad terraform.tfvars
```

#### Step 2: Set Your Credentials
Edit `terraform.tfvars`:
```hcl
# Your credentials
admin_username = "youralias"
admin_password = "YourSecurePassword123!"

# Optional overrides
location = "West US 3"
environment = "Production"
```

#### Step 3: Deploy Infrastructure
```powershell
# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Deploy infrastructure
terraform apply

# Type 'yes' when prompted
```

## 📊 After Deployment

### View VM Information
```powershell
# Get all VM connection details
terraform output vm_connection_info

# Get network information
terraform output network_info

# Get Log Analytics workspace details
terraform output log_analytics_workspace_name
```

### Connect to VMs

#### Linux VMs (SSH)
```bash
ssh youralias@<public-ip>
# Port: 22
```

#### Windows VMs (RDP)
```
Remote Desktop Connection
Computer: <public-ip>
Port: 3389
Username: youralias
Password: <your-password>
```

## 🔧 Terraform Module Structure

```
environment/prod/
├── main.tf           # Main configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── terraform.tfvars.example
└── terraform.tfvars  # Your credentials (created during deployment)

Modules/
├── monitor/          # Log Analytics Workspace
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Network/          # Networking infrastructure
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── Compute/          # Virtual Machines
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## 🛡️ Security Considerations

### Current NSG Rules
- **Linux VMs**: SSH (port 22) open to 0.0.0.0/0
- **Windows VMs**: RDP (port 3389) open to 0.0.0.0/0

### Recommended Security Enhancements
1. **Restrict access to your IP only**:
   - Edit `Modules/Network/main.tf`
   - Uncomment and modify the restricted rules
   - Replace `YOUR_PUBLIC_IP/32` with your actual IP

2. **Use Azure Bastion** for secure access
3. **Enable Just-In-Time VM access** in Azure Security Center

## 🧹 Cleanup

### Destroy All Resources
```powershell
cd "C:\Codes\Virtual Machines AzMon\environment\prod"
terraform destroy

# Type 'yes' when prompted
```

⚠️ **Warning**: This will permanently delete all VMs and associated resources!

## 📞 Troubleshooting

### Common Issues

1. **Terraform not found**
   - Install Terraform and add to PATH
   - Restart PowerShell

2. **Azure CLI login issues**
   - Run `az login` again
   - Check subscription with `az account show`

3. **Password complexity errors**
   - Must be 12+ characters
   - Include uppercase, lowercase, number
   - Avoid common passwords

4. **Resource quota issues**
   - Check Azure subscription limits
   - Try different region if needed

5. **Module not found errors**
   - Ensure you're in the correct directory
   - Check file paths in main.tf

### Getting Help
- Check Terraform documentation
- Review Azure provider documentation
- Validate configuration: `terraform validate`
- Format code: `terraform fmt`

## 🎯 Next Steps After Deployment

1. **Configure Azure Monitor Agent** on VMs
2. **Set up Data Collection Rules (DCRs)**
3. **Configure Log Analytics queries**
4. **Test monitoring and alerting**
5. **Practice different deployment methods** (Portal, PowerShell, CLI, Policy)

---

**Happy Learning with Azure Monitor Agent! 🚀**
