terraform {
  source = "${get_terragrunt_dir()}/../../modules/root"
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
