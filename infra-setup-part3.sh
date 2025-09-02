#!/bin/bash

set -e

echo "🔗 Wiring root module and terragrunt configs..."

#########################################
# ROOT MODULE
#########################################
cat > infra/modules/root/main.tf <<EOF
module "vpc" {
  source     = "../vpc"
  cidr_block = var.vpc_cidr_block
  name       = var.vpc_name
}

module "sg" {
  source                = "../sg"
  name                  = var.sg_name
  description           = var.sg_description
  vpc_id                = module.vpc.vpc_id
  ingress_from_port     = var.sg_ingress_from_port
  ingress_to_port       = var.sg_ingress_to_port
  ingress_protocol      = var.sg_ingress_protocol
  ingress_cidr_blocks   = var.sg_ingress_cidr_blocks
}

module "ebs" {
  source            = "../ebs"
  availability_zone = var.availability_zone
  size              = var.volume_size
  name              = var.volume_name
}

module "ec2" {
  source              = "../ec2"
  ami                 = var.ami
  instance_type       = var.instance_type
  subnet_id           = module.vpc.vpc_id
  security_group_id   = module.sg.security_group_id
  key_name            = var.key_name
  name                = var.ec2_name
  volume_id           = module.ebs.volume_id
  volume_device_name  = var.volume_device_name
}

module "iam" {
  source               = "../iam"
  name                 = var.iam_role_name
  assume_role_service  = "ec2.amazonaws.com"
  policy_name          = var.iam_policy_name
  policy_description   = var.iam_policy_description
  policy_document      = var.iam_policy_document
}

module "s3" {
  source      = "../s3"
  bucket_name = var.bucket_name
}
EOF

cat > infra/modules/root/variables.tf <<EOF
variable "vpc_cidr_block" { type = string }
variable "vpc_name"       { type = string }

variable "sg_name"                { type = string }
variable "sg_description"         { type = string }
variable "sg_ingress_from_port"   { type = number }
variable "sg_ingress_to_port"     { type = number }
variable "sg_ingress_protocol"    { type = string }
variable "sg_ingress_cidr_blocks" { type = list(string) }

variable "availability_zone" { type = string }
variable "volume_size"       { type = number }
variable "volume_name"       { type = string }

variable "ami"                { type = string }
variable "instance_type"      { type = string }
variable "key_name"           { type = string }
variable "ec2_name"           { type = string }
variable "volume_device_name" { type = string }

variable "iam_role_name"        { type = string }
variable "iam_policy_name"      { type = string }
variable "iam_policy_description" { type = string }
variable "iam_policy_document"  { type = any }

variable "bucket_name" { type = string }
EOF

cat > infra/modules/root/outputs.tf <<EOF
output "instance_id"     { value = module.ec2.instance_id }
output "public_ip"       { value = module.ec2.public_ip }
output "vpc_id"          { value = module.vpc.vpc_id }
output "security_group"  { value = module.sg.security_group_id }
output "volume_id"       { value = module.ebs.volume_id }
output "iam_role_arn"    { value = module.iam.role_arn }
output "iam_policy_arn"  { value = module.iam.policy_arn }
output "s3_bucket_id"    { value = module.s3.bucket_id }
EOF

#########################################
# TERRAGRUNT CONFIG: DEV
#########################################
cat > infra/envs/dev/terragrunt.hcl <<EOF
terraform {
  source = "\${get_terragrunt_dir()}/../../modules/root"
}

inputs = {
  vpc_cidr_block         = "10.0.0.0/16"
  vpc_name               = "dev-vpc"

  sg_name                = "dev-sg"
  sg_description         = "Dev SG"
  sg_ingress_from_port   = 22
  sg_ingress_to_port     = 22
  sg_ingress_protocol    = "tcp"
  sg_ingress_cidr_blocks = ["0.0.0.0/0"]

  availability_zone      = "us-east-1a"
  volume_size            = 8
  volume_name            = "dev-ebs"

  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.micro"
  key_name               = "dev-key"
  ec2_name               = "dev-ec2"
  volume_device_name     = "/dev/sdh"

  iam_role_name          = "dev-ec2-role"
  iam_policy_name        = "dev-ec2-policy"
  iam_policy_description = "Allow EC2 describe and S3 access"
  iam_policy_document = {
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ec2:Describe*",
        "s3:*"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  }

  bucket_name = "dev-unique-bucket-001"
}
EOF

#########################################
# TERRAGRUNT CONFIG: STAGING
#########################################
cat > infra/envs/staging/terragrunt.hcl <<EOF
terraform {
  source = "\${get_terragrunt_dir()}/../../modules/root"
}

inputs = {
  vpc_cidr_block         = "10.1.0.0/16"
  vpc_name               = "staging-vpc"

  sg_name                = "staging-sg"
  sg_description         = "Staging SG"
  sg_ingress_from_port   = 22
  sg_ingress_to_port     = 22
  sg_ingress_protocol    = "tcp"
  sg_ingress_cidr_blocks = ["0.0.0.0/0"]

  availability_zone      = "us-east-1b"
  volume_size            = 16
  volume_name            = "staging-ebs"

  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.medium"
  key_name               = "staging-key"
  ec2_name               = "staging-ec2"
  volume_device_name     = "/dev/sdh"

  iam_role_name          = "staging-ec2-role"
  iam_policy_name        = "staging-ec2-policy"
  iam_policy_description = "Allow EC2 describe and S3 access"
  iam_policy_document = {
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ec2:Describe*",
        "s3:*"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  }

  bucket_name = "staging-unique-bucket-002"
}
EOF

echo "✅ Part 3 complete: Root module + Terragrunt configs ready."
echo "💡 Navigate to 'infra/envs/dev' or 'infra/envs/staging' and run:"
echo "   terragrunt init && terragrunt apply"
