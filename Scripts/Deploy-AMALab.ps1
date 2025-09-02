# AMA Training Lab Deployment Script
# This script deploys all the virtual machines and Log Analytics workspace for AMA training

Write-Host "Azure Monitor Agent (AMA) Training Lab Deployment" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Check if Terraform is installed
try {
    $terraformVersion = terraform --version
    Write-Host "✅ Terraform found: $($terraformVersion.Split([Environment]::NewLine)[0])" -ForegroundColor Green
} catch {
    Write-Host "❌ Terraform not found. Please install Terraform first." -ForegroundColor Red
    Write-Host "Download from: https://www.terraform.io/downloads.html" -ForegroundColor Yellow
    exit 1
}

# Check if Azure CLI is installed and logged in
try {
    $azAccount = az account show --output json 2>$null
    if ($azAccount) {
        $account = $azAccount | ConvertFrom-Json
        Write-Host "✅ Azure CLI logged in as: $($account.user.name)" -ForegroundColor Green
        Write-Host "   Subscription: $($account.name) ($($account.id))" -ForegroundColor Cyan
    } else {
        throw "Not logged in"
    }
} catch {
    Write-Host "❌ Azure CLI not found or not logged in." -ForegroundColor Red
    Write-Host "Please run 'az login' first." -ForegroundColor Yellow
    exit 1
}

# Navigate to production environment
$prodPath = "C:\Codes\Virtual Machines AzMon\environment\prod"
Set-Location $prodPath

# Collect user inputs
Write-Host "`n📝 Configuration Setup" -ForegroundColor Yellow
Write-Host "=====================" -ForegroundColor Yellow

# Get username (alias)
do {
    $adminUsername = Read-Host "`nEnter your alias (VM username)"
    if ([string]::IsNullOrWhiteSpace($adminUsername)) {
        Write-Host "❌ Username cannot be empty. Please try again." -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($adminUsername))

# Get password
do {
    $adminPassword = Read-Host "Enter VM password (min 12 chars, must include uppercase, lowercase, number)" -AsSecureString
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminPassword))
    
    # Validate password complexity
    $isValid = $true
    $validationErrors = @()
    
    if ($plainPassword.Length -lt 12) {
        $validationErrors += "Password must be at least 12 characters long"
        $isValid = $false
    }
    if (-not ($plainPassword -cmatch "[A-Z]")) {
        $validationErrors += "Password must contain at least one uppercase letter"
        $isValid = $false
    }
    if (-not ($plainPassword -cmatch "[a-z]")) {
        $validationErrors += "Password must contain at least one lowercase letter"
        $isValid = $false
    }
    if (-not ($plainPassword -cmatch "[0-9]")) {
        $validationErrors += "Password must contain at least one number"
        $isValid = $false
    }
    
    if (-not $isValid) {
        Write-Host "❌ Password validation failed:" -ForegroundColor Red
        foreach ($error in $validationErrors) {
            Write-Host "   • $error" -ForegroundColor Red
        }
        Write-Host ""
    }
} while (-not $isValid)

# Create terraform.tfvars file
Write-Host "✅ Creating terraform.tfvars with your configuration..." -ForegroundColor Green

$tfvarsContent = @"
# Terraform Variables for AMA Training Lab
# Generated on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

# Admin credentials for all virtual machines
admin_username = "$adminUsername"
admin_password = "$plainPassword"

# Azure region
location = "West US 3"

# Environment
environment = "Production"
"@

$tfvarsContent | Out-File -FilePath "terraform.tfvars" -Encoding UTF8

# Clear the plain password from memory
$plainPassword = $null

Write-Host "`n🚀 Starting Terraform deployment..." -ForegroundColor Yellow

# Initialize Terraform
Write-Host "`n1. Initializing Terraform..." -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Terraform init failed!" -ForegroundColor Red
    exit 1
}

# Plan deployment
Write-Host "`n2. Planning deployment..." -ForegroundColor Cyan
terraform plan

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Terraform plan failed!" -ForegroundColor Red
    exit 1
}

# Ask for confirmation
Write-Host "`n⚠️  Ready to deploy AMA Training Lab resources?" -ForegroundColor Yellow
Write-Host "This will create the following resources in the 'AMATraining' resource group:" -ForegroundColor White
Write-Host "  • 1 Resource Group (AMATraining) in West US 3" -ForegroundColor White
Write-Host "  • 1 Log Analytics Workspace (AMATrainingWorkspace) in AMATraining RG" -ForegroundColor White
Write-Host "  • 1 Virtual Network with subnet and NSG rules in AMATraining RG" -ForegroundColor White
Write-Host "  • 4 Linux VMs (Ubuntu 22.04 LTS) in AMATraining RG" -ForegroundColor White
Write-Host "  • 4 Windows VMs (Windows Server 2022) in AMATraining RG" -ForegroundColor White
Write-Host "  • Public IPs and network interfaces for all VMs in AMATraining RG" -ForegroundColor White
Write-Host ""
Write-Host "Architecture:" -ForegroundColor Cyan
Write-Host "  Monitor Module    → Log Analytics Workspace" -ForegroundColor White
Write-Host "  Network Module    → VNet, Subnet, NSG Rules" -ForegroundColor White
Write-Host "  Compute Module    → Virtual Machines" -ForegroundColor White
Write-Host ""

$confirmation = Read-Host "Type 'yes' to proceed with deployment"

if ($confirmation -eq "yes") {
    # Apply deployment
    Write-Host "`n3. Applying deployment..." -ForegroundColor Cyan
    terraform apply -auto-approve
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Deployment completed successfully!" -ForegroundColor Green
        Write-Host "`n📊 Getting VM connection information..." -ForegroundColor Cyan
        terraform output vm_connection_info
    } else {
        Write-Host "`n❌ Deployment failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
}

Write-Host "`n🎯 AMA Training Lab Setup Complete!" -ForegroundColor Green
Write-Host "You can now proceed with your Azure Monitor Agent training labs." -ForegroundColor White
