# AMA Training Labs Infrastructure

A comprehensive Terraform project for deploying Azure Virtual Machine monitoring and management infrastructure using Azure Monitor Agent (AMA) for training purposes.

## 🚀 Quick Start

The simplest way to deploy this lab environment is using the interactive initialization script:

### Prerequisites
- Azure CLI installed and configured
- Terraform installed (version >= 1.0)
- Valid Azure subscription with appropriate permissions
- Linux environment (WSL, Git Bash, or native Linux/macOS)

### Automated Deployment

1. **Clone and run the initialization script:**
   ```bash
   git clone https://github.com/tiagojfernandes/ama-labs.git
   cd ama-labs
   chmod +x init-lab.sh
   ./init-lab.sh
   ```

2. **Follow the interactive prompts:**
   - The script will auto-detect your Azure user
   - Enter the password you want for all VM admin accounts
   - Confirm the deployment configuration
   - The script will automatically run terraform init, plan, and apply

### What Gets Deployed

This lab creates a complete AMA training environment with:

- **Resource Group:** `AMATraining` in West US 3
- **Log Analytics Workspace:** `AMATrainingWorkspace`
- **8 Virtual Machines** (all in Availability Zone 2):

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

- **Networking:** Virtual network, subnet, and shared Network Security Group
- **Public IPs:** Each VM gets a public IP for remote access
- **Security Rules:** SSH (port 22) for Linux and RDP (port 3389) for Windows


## Alternative Deployment Methods

### Manual Terraform Deployment

If you prefer manual control or need to customize the deployment:

1. **Navigate to the production environment:**
   ```bash
   cd environment/prod
   ```

2. **Create terraform.tfvars from template:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars with your credentials:**
   ```hcl
   admin_username = "youralias"
   admin_password = "YourSecurePassword123!"
   ```

4. **Deploy with Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Using PowerShell Scripts (Windows)

For Windows users, you can also use the provided PowerShell scripts:

```powershell
# Complete workflow (validation + deployment)
.\Scripts\Quick-Start.ps1

# Or step-by-step:
.\Scripts\Validate-TerraformConfig.ps1
.\Scripts\Deploy-AMALab.ps1
```

## Project Structure

```
ama-labs/
├── init-lab.sh                 # Interactive deployment script (Linux/macOS/WSL)
├── environment/
│   └── prod/                   # Production environment configurations
│       ├── main.tf             # Main Terraform configuration
│       ├── variables.tf        # Input variables
│       ├── outputs.tf          # Output values
│       └── terraform.tfvars.example # Configuration template
├── Modules/                    # Reusable Terraform modules
│   ├── monitor/                # Log Analytics Workspace module
│   ├── Network/                # Networking infrastructure (VNet, NSG)
│   └── Compute/                # Virtual Machines module
├── Scripts/                    # PowerShell automation scripts
│   ├── Quick-Start.ps1         # Complete deployment workflow
│   ├── Deploy-AMALab.ps1       # Interactive deployment script
│   └── Validate-TerraformConfig.ps1 # Configuration validation
├── DEPLOYMENT.md               # Detailed deployment guide
└── README.md                   # This file
```

## Prerequisites

- **Azure CLI** (logged in to your subscription)
- **Terraform** (>= 1.0)
- **Azure Subscription** with sufficient quota for 8 Standard_D2s_v3 VMs
- **Appropriate Azure permissions** to create resources in West US 3

## Access Information

After deployment, you can access your VMs using:
- **Username:** The username you provided during setup
- **Password:** The password you provided during setup
- **Linux VMs:** SSH on port 22
- **Windows VMs:** RDP on port 3389
- **Public IPs:** Check Azure Portal or Terraform outputs for IP addresses
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
