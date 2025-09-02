# Quick Start Script for AMA Training Lab
# This script provides a complete deployment workflow

param(
    [switch]$ValidateOnly,
    [switch]$DeployOnly,
    [switch]$SkipValidation
)

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                    AMA Training Lab                          ║
║                   Quick Start Deployment                     ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "Azure Monitor Agent Training Lab - Infrastructure Deployment" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Set paths
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
$prodPath = Join-Path $projectRoot "environment\prod"
$validationScript = Join-Path $scriptPath "Validate-TerraformConfig.ps1"
$deploymentScript = Join-Path $scriptPath "Deploy-AMALab.ps1"

Write-Host "`n📁 Project Location: $projectRoot" -ForegroundColor Gray

# Validation Phase
if (-not $DeployOnly) {
    Write-Host "`n🔍 PHASE 1: VALIDATION" -ForegroundColor Yellow
    Write-Host "========================" -ForegroundColor Yellow
    
    if (Test-Path $validationScript) {
        & $validationScript
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "`n❌ Validation failed. Please fix errors before proceeding." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "⚠️  Validation script not found, proceeding without validation..." -ForegroundColor Yellow
    }
    
    if ($ValidateOnly) {
        Write-Host "`n✅ Validation complete. Use -DeployOnly to proceed with deployment." -ForegroundColor Green
        exit 0
    }
}

# Deployment Phase
if (-not $ValidateOnly) {
    Write-Host "`n🚀 PHASE 2: DEPLOYMENT" -ForegroundColor Yellow
    Write-Host "=======================" -ForegroundColor Yellow
    
    # Check if terraform.tfvars exists
    $tfvarsPath = Join-Path $prodPath "terraform.tfvars"
    if (-not (Test-Path $tfvarsPath)) {
        Write-Host "`n📝 Configuration needed..." -ForegroundColor Cyan
        
        # Option to use the automated deployment script
        $useAutomated = Read-Host "`nWould you like to use the automated deployment script? (Y/n)"
        if ($useAutomated -ne 'n' -and $useAutomated -ne 'N') {
            if (Test-Path $deploymentScript) {
                Write-Host "`n🎯 Starting automated deployment..." -ForegroundColor Green
                & $deploymentScript
                exit $LASTEXITCODE
            } else {
                Write-Host "❌ Automated deployment script not found." -ForegroundColor Red
            }
        }
        
        # Manual configuration
        Write-Host "`n📋 Manual configuration required..." -ForegroundColor Cyan
        Write-Host "Please configure your credentials:" -ForegroundColor White
        
        # Get username
        do {
            $adminUsername = Read-Host "`nEnter your alias (VM username)"
        } while ([string]::IsNullOrWhiteSpace($adminUsername))
        
        # Get password
        do {
            $adminPassword = Read-Host "Enter VM password (min 12 chars)" -AsSecureString
            $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminPassword))
            
            if ($plainPassword.Length -lt 12) {
                Write-Host "❌ Password must be at least 12 characters long" -ForegroundColor Red
                $plainPassword = $null
            }
        } while ([string]::IsNullOrWhiteSpace($plainPassword))
        
        # Create terraform.tfvars
        $tfvarsContent = @"
# AMA Training Lab Configuration
# Generated on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

admin_username = "$adminUsername"
admin_password = "$plainPassword"
location = "West US 3"
environment = "Production"
"@
        
        $tfvarsContent | Out-File -FilePath $tfvarsPath -Encoding UTF8
        Write-Host "`n✅ Configuration saved to terraform.tfvars" -ForegroundColor Green
        
        # Clear password from memory
        $plainPassword = $null
    }
    
    # Deploy using Terraform
    Write-Host "`n🏗️  Starting Terraform deployment..." -ForegroundColor Cyan
    
    try {
        Set-Location $prodPath
        
        # Initialize
        Write-Host "`n1. Initializing Terraform..." -ForegroundColor Gray
        terraform init
        if ($LASTEXITCODE -ne 0) { throw "Terraform init failed" }
        
        # Plan
        Write-Host "`n2. Creating deployment plan..." -ForegroundColor Gray
        terraform plan -out=tfplan
        if ($LASTEXITCODE -ne 0) { throw "Terraform plan failed" }
        
        # Confirm deployment
        Write-Host "`n⚠️  Ready to deploy infrastructure?" -ForegroundColor Yellow
        Write-Host "This will create 8 VMs and associated Azure resources." -ForegroundColor White
        $confirm = Read-Host "Type 'yes' to proceed"
        
        if ($confirm -eq 'yes') {
            # Apply
            Write-Host "`n3. Applying deployment..." -ForegroundColor Gray
            terraform apply tfplan
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "`n🎉 DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
                Write-Host "============================" -ForegroundColor Green
                
                Write-Host "`n📊 Getting deployment information..." -ForegroundColor Cyan
                terraform output -json | ConvertFrom-Json | ConvertTo-Json -Depth 10
                
                Write-Host "`n🔗 Connection Information:" -ForegroundColor Cyan
                terraform output vm_connection_info
                
                Write-Host "`n📚 Next Steps:" -ForegroundColor Yellow
                Write-Host "1. Connect to VMs using the connection information above" -ForegroundColor White
                Write-Host "2. Configure Azure Monitor Agent on the VMs" -ForegroundColor White
                Write-Host "3. Set up Data Collection Rules (DCRs)" -ForegroundColor White
                Write-Host "4. Start your AMA training labs!" -ForegroundColor White
                
                Write-Host "`n💡 Tip: Save the VM connection information for easy access" -ForegroundColor Cyan
                
            } else {
                Write-Host "`n❌ Deployment failed!" -ForegroundColor Red
                Write-Host "Check the error messages above and try again." -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "`nDeployment cancelled." -ForegroundColor Yellow
            exit 0
        }
        
    } catch {
        Write-Host "`n❌ Error during deployment: $_" -ForegroundColor Red
        exit 1
    } finally {
        # Clean up plan file
        if (Test-Path "tfplan") {
            Remove-Item "tfplan" -Force
        }
    }
}

Write-Host "`n🎯 AMA Training Lab deployment complete!" -ForegroundColor Green
Write-Host "Happy learning! 🚀" -ForegroundColor Cyan
