#!/bin/bash

set -e

echo "🔧 Creating directory structure..."

# Create modules
mkdir -p infra/modules/{vpc,sg,ec2,ebs,iam,s3,root}

# Create environments (dev and staging)
mkdir -p infra/envs/{dev,staging}

# Create base Terraform files for each module
for module in vpc sg ec2 ebs iam s3 root; do
  touch infra/modules/$module/main.tf
  touch infra/modules/$module/variables.tf
  touch infra/modules/$module/outputs.tf
done

# Create Terragrunt files (only in envs)
touch infra/envs/dev/terragrunt.hcl
touch infra/envs/staging/terragrunt.hcl

# Create .gitignore
cat > infra/.gitignore <<EOF
# Terraform
*.tfstate
.tfstate.
.terraform/
.terraform.lock.hcl
*.backup
*.log

# System
.DS_Store
EOF

# Create README
echo "# Infrastructure Setup" > infra/README.md

echo "✅ Part 1 complete: Structure and empty files created."
echo "🧩 Next: Run Part 2 to define resources and wiring."
