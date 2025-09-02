#!/bin/bash

# AMA Labs Infrastructure Deployment Script
# This script initializes the AMA Training lab environment

echo "============================================="
echo "   AMA Training Lab Setup"
echo "============================================="
echo ""

# Get the current user from Azure CLI session
CURRENT_USER=$(az account show --query user.name --output tsv 2>/dev/null)
if [ -z "$CURRENT_USER" ]; then
    echo "Warning: Unable to detect Azure user. Please ensure you are logged into Azure CLI."
    read -p "Enter your username (youralias): " USERNAME
else
    # Extract username from email (everything before @)
    USERNAME=$(echo "$CURRENT_USER" | cut -d'@' -f1)
    echo "Detected Azure user: $CURRENT_USER"
    echo "Using username: $USERNAME"
fi

# Prompt for password
echo ""
echo "Please enter the password to be used for all VM admin accounts:"
echo "(Password will be hidden for security)"
read -s -p "Password: " PASSWORD
echo ""

# Validate password is not empty
if [ -z "$PASSWORD" ]; then
    echo "Error: Password cannot be empty."
    exit 1
fi

# Confirm password
read -s -p "Confirm password: " CONFIRM_PASSWORD
echo ""

if [ "$PASSWORD" != "$CONFIRM_PASSWORD" ]; then
    echo "Error: Passwords do not match."
    exit 1
fi

echo ""
echo "Configuration Summary:"
echo "- Username: $USERNAME"
echo "- Password: [HIDDEN]"
echo "- Resource Group: AMATraining"
echo "- Location: West US 3"
echo "- Virtual Machines to be created:"
echo "  * LinAMAPortalDep (Ubuntu 22.04 LTS)"
echo "  * LinAMAPSDeploy (Ubuntu 22.04 LTS)"
echo "  * LinAMACLIDeploy (Ubuntu 22.04 LTS)"
echo "  * LinAMAPolicyDep (Ubuntu 22.04 LTS)"
echo "  * WinAMAPortalDep (Windows Server 2022)"
echo "  * WinAMAPSDeploy (Windows Server 2022)"
echo "  * WinAMACLIDeploy (Windows Server 2022)"
echo "  * WinAMAPolicyDep (Windows Server 2022)"
echo ""

read -p "Do you want to proceed with the deployment? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 0
fi

echo ""
echo "Starting Terraform deployment..."
echo "============================================="

# Navigate to the environment directory
cd "$(dirname "$0")/environment/prod"

# Create terraform.tfvars with the collected information
cat > terraform.tfvars << EOF
admin_username = "$USERNAME"
admin_password = "$PASSWORD"
EOF

echo "Created terraform.tfvars with your credentials."
echo ""

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

if [ $? -ne 0 ]; then
    echo "Error: Terraform initialization failed."
    exit 1
fi

# Plan the deployment
echo ""
echo "Creating deployment plan..."
terraform plan

if [ $? -ne 0 ]; then
    echo "Error: Terraform planning failed."
    exit 1
fi

# Apply the configuration
echo ""
read -p "Apply the Terraform configuration? (y/N): " APPLY_CONFIRM
if [[ "$APPLY_CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Applying Terraform configuration..."
    terraform apply -auto-approve
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "============================================="
        echo "   Deployment completed successfully!"
        echo "============================================="
        echo ""
        echo "Your AMA Training lab environment is now ready."
        echo "You can access your VMs using the following credentials:"
        echo "- Username: $USERNAME"
        echo "- Password: [The password you provided]"
        echo ""
        echo "Check the Azure Portal to see your deployed resources."
    else
        echo "Error: Terraform apply failed."
        exit 1
    fi
else
    echo "Deployment cancelled."
fi
