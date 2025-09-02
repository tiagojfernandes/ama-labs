#!/bin/bash

# AMA Labs Infrastructure Deployment Script
# This script initializes the AMA Training lab environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# -------------------------------
# Functions
# -------------------------------

# Function to prompt for user input with validation
prompt_input() {
  local prompt_text="$1"
  local var_name="$2"
  local default_value="$3"
  
  while true; do
    if [ -n "$default_value" ]; then
      read -p "$(echo -e "${CYAN}$prompt_text [$default_value]: ${NC}")" user_input
      user_input=${user_input:-$default_value}
    else
      read -p "$(echo -e "${CYAN}$prompt_text: ${NC}")" user_input
    fi
    
    if [ -n "$user_input" ]; then
      eval "$var_name='$user_input'"
      break
    else
      echo -e "${RED}This field cannot be empty. Please try again.${NC}"
    fi
  done
}

# Register Azure resource provider if not yet registered
register_provider() {
  local ns=$1
  local status=$(az provider show --namespace "$ns" --query "registrationState" -o tsv 2>/dev/null || echo "NotRegistered")

  if [ "$status" != "Registered" ]; then
    az provider register --namespace "$ns" > /dev/null 2>&1
    until [ "$(az provider show --namespace "$ns" --query "registrationState" -o tsv)" == "Registered" ]; do
      sleep 5
    done
  fi
}

echo "============================================="
echo "   AMA Training Lab Setup"
echo "============================================="
echo ""

# Clone the repo (skip if already cloned)
if [ ! -d "ama-labs" ]; then
  echo -e "${CYAN}Cloning ama-labs repository...${NC}"
  git clone https://github.com/tiagojfernandes/ama-labs.git
fi

# Change to the project directory
cd ama-labs

# Register necessary Azure providers
echo "Please wait while we prepare everything for you..."
for ns in Microsoft.Insights Microsoft.OperationalInsights Microsoft.Monitor Microsoft.SecurityInsights Microsoft.Dashboard; do
  register_provider "$ns"
done
echo "Preparation complete!"
echo ""

# Prompt for username with validation
echo ""
echo -e "${CYAN}Please enter the admin username for all VMs${NC}"
echo -e "${YELLOW}(Recommend using your company alias - e.g., 'johndoe', 'jsmith')${NC}"

while true; do
  read -p "$(echo -e "${CYAN}Admin username: ${NC}")" USERNAME
  
  # Validate username is not empty
  if [ -z "$USERNAME" ]; then
    echo -e "${RED}Username cannot be empty. Please try again.${NC}"
    continue
  fi
  
  # Validate username format (alphanumeric and hyphens/underscores only)
  if [[ ! "$USERNAME" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    echo -e "${RED}Username must start with a letter and contain only letters, numbers, hyphens, and underscores.${NC}"
    continue
  fi
  
  # Validate username length
  if [[ ${#USERNAME} -lt 3 ]]; then
    echo -e "${RED}Username must be at least 3 characters long.${NC}"
    continue
  fi
  
  if [[ ${#USERNAME} -gt 20 ]]; then
    echo -e "${RED}Username must be 20 characters or less.${NC}"
    continue
  fi
  
  # Check for reserved names
  if [[ "$USERNAME" =~ ^(admin|administrator|root|guest|user|test)$ ]]; then
    echo -e "${RED}Username cannot be a reserved name (admin, administrator, root, guest, user, test).${NC}"
    continue
  fi
  
  echo -e "${GREEN}✅ Username '$USERNAME' accepted${NC}"
  break
done

# Prompt for password
echo ""
echo -e "${CYAN}Please enter the password to be used for all VM admin accounts:${NC}"
echo -e "${YELLOW}(Password must be at least 12 characters with uppercase, lowercase, digit, and special character)${NC}"

while true; do
  read -s -p "$(echo -e "${CYAN}Enter admin password: ${NC}")" ADMIN_PASSWORD
  echo ""
  read -s -p "$(echo -e "${CYAN}Confirm admin password: ${NC}")" ADMIN_PASSWORD_CONFIRM
  echo ""
  
  if [ "$ADMIN_PASSWORD" != "$ADMIN_PASSWORD_CONFIRM" ]; then
    echo -e "${RED}Passwords do not match. Please try again.${NC}"
    continue
  fi
  
  # Basic password validation
  if [[ ${#ADMIN_PASSWORD} -lt 12 ]]; then
    echo -e "${RED}Password must be at least 12 characters long.${NC}"
    continue
  fi
  
  if [[ ! "$ADMIN_PASSWORD" =~ [A-Z] ]] || [[ ! "$ADMIN_PASSWORD" =~ [a-z] ]] || [[ ! "$ADMIN_PASSWORD" =~ [0-9] ]] || [[ ! "$ADMIN_PASSWORD" =~ [^A-Za-z0-9] ]]; then
    echo -e "${RED}Password must contain uppercase, lowercase, digit, and special character.${NC}"
    continue
  fi
  
  echo -e "${GREEN}✅ Password accepted${NC}"
  break
done

# Set PASSWORD variable for compatibility with existing code
PASSWORD="$ADMIN_PASSWORD"

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

# Navigate to the environment directory (we're already in ama-labs directory)
cd environment/prod

# Create terraform.tfvars with the collected information
cat > terraform.tfvars << EOF
admin_username = "$USERNAME"
admin_password = "$PASSWORD"
EOF

echo "Created terraform.tfvars with your credentials."
echo ""

# Initialize Terraform
echo -e "${CYAN}Initializing Terraform...${NC}"
terraform init

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Terraform initialization failed.${NC}"
    exit 1
fi

echo -e "${CYAN}Planning Terraform deployment...${NC}"
terraform plan

# Apply the configuration
echo ""
echo -e "${CYAN}Applying Terraform configuration...${NC}"
echo -e "${YELLOW}This may take 10-15 minutes to create all resources.${NC}"
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
    echo -e "${RED}Error: Terraform apply failed.${NC}"
    echo -e "${YELLOW}Common issues and solutions:${NC}"
    echo -e "${YELLOW}- SKU conflicts: Try running 'terraform destroy' then re-run this script${NC}"
    echo -e "${YELLOW}- Quota issues: Check your Azure subscription quotas${NC}"
    echo -e "${YELLOW}- Permission issues: Ensure you have Contributor access${NC}"
    echo -e "${YELLOW}- Region issues: West US 3 might be at capacity${NC}"
    echo ""
    echo -e "${CYAN}For detailed logs, check the Terraform output above.${NC}"
    exit 1
fi
