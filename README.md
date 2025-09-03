# AMA Training Labs Infrastructure

Automated deployment of Azure Virtual Machine infrastructure for Azure Monitor Agent (AMA) training labs.

## 🚀 Quick Start (Recommended)

**The easiest way to deploy this lab is using Azure Portal Bash:**

1. Open [Azure Portal](https://portal.azure.com)
2. Click on the **Cloud Shell** icon (terminal icon in the top menu)
3. Select **Bash** when prompted
4. Run this single command:

```bash
bash <(curl -s https://raw.githubusercontent.com/tiagojfernandes/ama-labs/refs/heads/main/init-lab.sh)
```

💡 **Note:** Interactive password prompts require the script to be run directly, not via curl pipe.

## What Gets Deployed

This creates a complete AMA training environment in **West US 3**:

- **Resource Group:** `AMATraining`
- **Log Analytics Workspace:** `AMATrainingWorkspace`
- **11 Virtual Machines** in Availability Zone 2:

| VM Name | OS | Purpose |
|---------|----|----|
| LinAMAPortalDep | Ubuntu 22.04 LTS | DCR Portal Deployment Lab |
| LinAMAPSDeploy | Ubuntu 22.04 LTS | DCR PowerShell Deployment Lab |
| LinAMACLIDeploy | Ubuntu 22.04 LTS | DCR CLI Deployment Lab |
| LinAMAPolicyDep | Ubuntu 22.04 LTS | Agent Policy Based Deployment Lab |
| AutoUpgradePortal | Ubuntu 22.04 LTS | Auto Upgrade Portal Lab |
| AutoUpgradePS | Ubuntu 22.04 LTS | Auto Upgrade PowerShell Lab |
| AutoUpgradeCLI | Ubuntu 22.04 LTS | Auto Upgrade CLI Lab |
| WinAMAPortalDep | Windows Server 2022 | DCR Portal Deployment Lab |
| WinAMAPSDeploy | Windows Server 2022 | DCR PowerShell Deployment Lab |
| WinAMACLIDeploy | Windows Server 2022 | DCR CLI Deployment Lab |
| WinAMAPolicyDep | Windows Server 2022 | Policy Based Agent Deployment Lab |

All VMs use **Standard_D2s_v3** size and have public IPs for remote access.

## How It Works

The `init-lab.sh` script:
1. **Clones this repository** (if running from curl)
2. **Registers required Azure providers** automatically
3. **Prompts for a username** (with validation)
4. **Prompts for a secure password** (with validation)
5. **Deploys everything** using Terraform

## Access Your VMs

After deployment:
- **Linux VMs:** SSH on port 22
- **Windows VMs:** RDP on port 3389
- **Username:** The username you provided
- **Password:** The password you provided
- **IPs:** Check Azure Portal for public IP addresses

## Manual Deployment (Optional)

If you prefer manual control:

```bash
cd environment/prod
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your credentials
terraform init
terraform plan
terraform apply
```

## Cleanup

⚠️ **Warning:** This permanently deletes all VMs and data!

To remove all resources:

```bash
cd environment/prod
terraform destroy
```


## Project Structure

```
ama-labs/
├── init-lab.sh              # One-click deployment script
├── environment/prod/         # Terraform configuration
├── Modules/                  # Terraform modules
│   ├── monitor/             # Log Analytics Workspace
│   ├── Network/             # VNet, NSG, networking
│   └── Compute/             # Virtual Machines
└── Scripts/                 # PowerShell automation scripts
```
