#!/bin/bash

set -e

echo "🔧 Populating Terraform module files..."

####################################
# VPC MODULE
####################################
cat > infra/modules/vpc/main.tf <<EOF
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}
EOF

cat > infra/modules/vpc/variables.tf <<EOF
variable "cidr_block" {
  type = string
}

variable "name" {
  type = string
}
EOF

cat > infra/modules/vpc/outputs.tf <<EOF
output "vpc_id" {
  value = aws_vpc.this.id
}
EOF

####################################
# SECURITY GROUP MODULE
####################################
cat > infra/modules/sg/main.tf <<EOF
resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}
EOF

cat > infra/modules/sg/variables.tf <<EOF
variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_from_port" {
  type = number
}

variable "ingress_to_port" {
  type = number
}

variable "ingress_protocol" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}
EOF

cat > infra/modules/sg/outputs.tf <<EOF
output "security_group_id" {
  value = aws_security_group.this.id
}
EOF

####################################
# EBS MODULE
####################################
cat > infra/modules/ebs/main.tf <<EOF
resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size

  tags = {
    Name = var.name
  }
}
EOF

cat > infra/modules/ebs/variables.tf <<EOF
variable "availability_zone" {
  type = string
}

variable "size" {
  type = number
}

variable "name" {
  type = string
}
EOF

cat > infra/modules/ebs/outputs.tf <<EOF
output "volume_id" {
  value = aws_ebs_volume.this.id
}
EOF

####################################
# EC2 MODULE
####################################
cat > infra/modules/ec2/main.tf <<EOF
resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = var.volume_device_name
    volume_id   = var.volume_id
  }

  tags = {
    Name = var.name
  }
}
EOF

cat > infra/modules/ec2/variables.tf <<EOF
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "name" {
  type = string
}

variable "volume_id" {
  type = string
}

variable "volume_device_name" {
  type = string
}
EOF

cat > infra/modules/ec2/outputs.tf <<EOF
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
EOF

####################################
# IAM MODULE
####################################
cat > infra/modules/iam/main.tf <<EOF
resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = var.assume_role_service
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = var.name
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description
  policy      = jsonencode(var.policy_document)
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
EOF

cat > infra/modules/iam/variables.tf <<EOF
variable "name" {
  type = string
}

variable "assume_role_service" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_description" {
  type = string
}

variable "policy_document" {
  type = any
}
EOF

cat > infra/modules/iam/outputs.tf <<EOF
output "role_arn" {
  value = aws_iam_role.this.arn
}

output "policy_arn" {
  value = aws_iam_policy.this.arn
}
EOF

####################################
# S3 MODULE
####################################
cat > infra/modules/s3/main.tf <<EOF
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
EOF

cat > infra/modules/s3/variables.tf <<EOF
variable "bucket_name" {
  type = string
}
EOF

cat > infra/modules/s3/outputs.tf <<EOF
output "bucket_id" {
  value = aws_s3_bucket.this.id
}
EOF

echo "✅ Part 2 complete: Modules populated."
echo "📦 Next: Run Part 3 to create the root module and Terragrunt configs."
