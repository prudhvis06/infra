#!/bin/bash

set -e

echo "Updating system packages..."
sudo yum update -y


# -----------------------------------
# Install Terraform
# -----------------------------------
echo "Adding HashiCorp repo for Terraform..."
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

echo "Installing Terraform..."
sudo yum install -y terraform

# -----------------------------------
# Install Terragrunt
# -----------------------------------
TERRAGRUNT_VERSION=$(curl --silent "https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')

echo "Installing Terragrunt version $TERRAGRUNT_VERSION..."
curl -L -o terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/

# -----------------------------------
# Verify Installations
# -----------------------------------
echo "Verifying installations..."

echo "Terraform version:"
terraform -version

echo "Terragrunt version:"
terragrunt -version

echo "Git version:"
git --version

echo "Tree version:"
tree --version

echo "✅ All tools installed successfully."

