# Terraform Validation Script for AMA Training Lab
# This script validates the Terraform configuration before deployment

Write-Host "🔍 AMA Training Lab - Terraform Validation" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$ErrorCount = 0
$WarningCount = 0

# Function to log errors
function Write-Error-Log($message) {
    Write-Host "❌ ERROR: $message" -ForegroundColor Red
    $script:ErrorCount++
}

# Function to log warnings
function Write-Warning-Log($message) {
    Write-Host "⚠️  WARNING: $message" -ForegroundColor Yellow
    $script:WarningCount++
}

# Function to log success
function Write-Success-Log($message) {
    Write-Host "✅ $message" -ForegroundColor Green
}

# Check if Terraform is installed
Write-Host "`n1. Checking Terraform installation..." -ForegroundColor Cyan
try {
    $terraformVersion = terraform version
    if ($terraformVersion -match "Terraform v(\d+\.\d+\.\d+)") {
        Write-Success-Log "Terraform found: $($matches[1])"
    } else {
        Write-Error-Log "Could not determine Terraform version"
    }
} catch {
    Write-Error-Log "Terraform not found. Please install Terraform first."
}

# Check if Azure CLI is installed and logged in
Write-Host "`n2. Checking Azure CLI..." -ForegroundColor Cyan
try {
    $azAccount = az account show --output json 2>$null
    if ($azAccount) {
        $account = $azAccount | ConvertFrom-Json
        Write-Success-Log "Azure CLI logged in as: $($account.user.name)"
        Write-Host "   Subscription: $($account.name)" -ForegroundColor Gray
    } else {
        Write-Error-Log "Azure CLI not logged in. Run 'az login' first."
    }
} catch {
    Write-Error-Log "Azure CLI not found or not configured properly."
}

# Check project structure
Write-Host "`n3. Checking project structure..." -ForegroundColor Cyan
$requiredPaths = @(
    "C:\Codes\Virtual Machines AzMon\environment\prod\main.tf",
    "C:\Codes\Virtual Machines AzMon\environment\prod\variables.tf",
    "C:\Codes\Virtual Machines AzMon\environment\prod\outputs.tf",
    "C:\Codes\Virtual Machines AzMon\Modules\monitor\main.tf",
    "C:\Codes\Virtual Machines AzMon\Modules\Network\main.tf",
    "C:\Codes\Virtual Machines AzMon\Modules\Compute\main.tf"
)

foreach ($path in $requiredPaths) {
    if (Test-Path $path) {
        Write-Success-Log "Found: $(Split-Path -Leaf $path)"
    } else {
        Write-Error-Log "Missing: $path"
    }
}

# Check for terraform.tfvars
Write-Host "`n4. Checking configuration files..." -ForegroundColor Cyan
$tfvarsPath = "C:\Codes\Virtual Machines AzMon\environment\prod\terraform.tfvars"
$tfvarsExamplePath = "C:\Codes\Virtual Machines AzMon\environment\prod\terraform.tfvars.example"

if (Test-Path $tfvarsPath) {
    Write-Success-Log "terraform.tfvars file found"
    
    # Check if it contains required variables
    $tfvarsContent = Get-Content $tfvarsPath -Raw
    if ($tfvarsContent -match 'admin_username\s*=') {
        Write-Success-Log "admin_username configured"
    } else {
        Write-Warning-Log "admin_username not found in terraform.tfvars"
    }
    
    if ($tfvarsContent -match 'admin_password\s*=') {
        Write-Success-Log "admin_password configured"
    } else {
        Write-Warning-Log "admin_password not found in terraform.tfvars"
    }
} else {
    if (Test-Path $tfvarsExamplePath) {
        Write-Warning-Log "terraform.tfvars not found, but example file exists"
        Write-Host "   Copy terraform.tfvars.example to terraform.tfvars and configure it" -ForegroundColor Gray
    } else {
        Write-Error-Log "Neither terraform.tfvars nor terraform.tfvars.example found"
    }
}

# Navigate to production directory and validate Terraform
Write-Host "`n5. Validating Terraform configuration..." -ForegroundColor Cyan
$originalLocation = Get-Location
try {
    Set-Location "C:\Codes\Virtual Machines AzMon\environment\prod"
    
    # Initialize if .terraform doesn't exist
    if (-not (Test-Path ".terraform")) {
        Write-Host "   Initializing Terraform..." -ForegroundColor Gray
        $initResult = terraform init 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success-Log "Terraform initialized successfully"
        } else {
            Write-Error-Log "Terraform initialization failed"
            Write-Host $initResult -ForegroundColor Red
        }
    } else {
        Write-Success-Log "Terraform already initialized"
    }
    
    # Validate configuration
    Write-Host "   Validating configuration..." -ForegroundColor Gray
    $validateResult = terraform validate 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success-Log "Terraform configuration is valid"
    } else {
        Write-Error-Log "Terraform validation failed"
        Write-Host $validateResult -ForegroundColor Red
    }
    
    # Format check
    Write-Host "   Checking formatting..." -ForegroundColor Gray
    $fmtResult = terraform fmt -check -recursive 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success-Log "Terraform files are properly formatted"
    } else {
        Write-Warning-Log "Some Terraform files need formatting"
        Write-Host "   Run 'terraform fmt -recursive' to fix formatting" -ForegroundColor Gray
    }
    
} catch {
    Write-Error-Log "Could not validate Terraform configuration: $_"
} finally {
    Set-Location $originalLocation
}

# Check estimated costs (if terraform is properly configured)
Write-Host "`n6. Checking estimated costs..." -ForegroundColor Cyan
Write-Host "   Estimated monthly cost for this lab:" -ForegroundColor Gray
Write-Host "   • 8 VMs (Standard_D2s_v3): ~$480-640/month" -ForegroundColor Gray
Write-Host "   • Log Analytics: ~$2-10/month (depending on data ingestion)" -ForegroundColor Gray
Write-Host "   • Networking: ~$5-15/month" -ForegroundColor Gray
Write-Host "   • Total: ~$487-665/month" -ForegroundColor Yellow
Write-Host "   💡 Tip: Stop VMs when not in use to reduce costs!" -ForegroundColor Cyan

# Summary
Write-Host "`n📊 Validation Summary" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green
if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "🎉 All checks passed! Ready for deployment." -ForegroundColor Green
} elseif ($ErrorCount -eq 0) {
    Write-Host "✅ No errors found, but $WarningCount warning(s) detected." -ForegroundColor Yellow
    Write-Host "   You can proceed with deployment." -ForegroundColor Yellow
} else {
    Write-Host "❌ $ErrorCount error(s) and $WarningCount warning(s) found." -ForegroundColor Red
    Write-Host "   Please fix errors before deployment." -ForegroundColor Red
}

Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
if ($ErrorCount -eq 0) {
    Write-Host "   1. Run the deployment script: .\Scripts\Deploy-AMALab.ps1" -ForegroundColor White
    Write-Host "   2. Or deploy manually: terraform plan && terraform apply" -ForegroundColor White
} else {
    Write-Host "   1. Fix the errors listed above" -ForegroundColor White
    Write-Host "   2. Re-run this validation script" -ForegroundColor White
    Write-Host "   3. Then proceed with deployment" -ForegroundColor White
}

Write-Host "`n📚 Documentation:" -ForegroundColor Cyan
Write-Host "   • Deployment Guide: .\DEPLOYMENT.md" -ForegroundColor White
Write-Host "   • Project README: .\README.md" -ForegroundColor White
