# AMA Training Labs Infrastructure

Automated deployment of Azure Virtual Machine infrastructure for Azure Monitor Agent (AMA) training labs.

## 🚀 Quick Deployment

Run this command in **Azure Cloud Shell** or any bash environment:

```bash
curl -s https://raw.githubusercontent.com/tiagojfernandes/ama-labs/main/init-lab.sh | bash
```

## What Gets Deployed

This creates a complete AMA training environment in **West US 3**:

- **Resource Group:** `AMATraining`
- **Log Analytics Workspace:** `AMATrainingWorkspace`
- **8 Virtual Machines** in Availability Zone 2:

| VM Name | OS | Purpose |
|---------|----|----|
| LinAMAPortalDep | Ubuntu 22.04 LTS | DCR Portal Deployment Lab |
| LinAMAPSDeploy | Ubuntu 22.04 LTS | DCR PowerShell Deployment Lab |
| LinAMACLIDeploy | Ubuntu 22.04 LTS | DCR CLI Deployment Lab |
| LinAMAPolicyDep | Ubuntu 22.04 LTS | Agent Policy Based Deployment Lab |
| WinAMAPortalDep | Windows Server 2022 | DCR Portal Deployment Lab |
| WinAMAPSDeploy | Windows Server 2022 | DCR PowerShell Deployment Lab |
| WinAMACLIDeploy | Windows Server 2022 | DCR CLI Deployment Lab |
| WinAMAPolicyDep | Windows Server 2022 | Policy Based Agent Deployment Lab |

All VMs use **Standard_D2s_v3** size and have public IPs for remote access.

## How It Works

The `init-lab.sh` script:
1. **Clones this repository** (if running from curl)
2. **Registers required Azure providers** automatically
3. **Detects your Azure username** from your logged-in session
4. **Prompts for a secure password** (with validation)
5. **Deploys everything** using Terraform

## Access Your VMs

After deployment:
- **Linux VMs:** SSH on port 22
- **Windows VMs:** RDP on port 3389
- **Username:** Your Azure username (auto-detected)
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
