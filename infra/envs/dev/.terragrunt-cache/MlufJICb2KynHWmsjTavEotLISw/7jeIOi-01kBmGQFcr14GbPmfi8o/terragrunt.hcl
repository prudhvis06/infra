terraform {
source = "${path_relative_from_include()}/../../modules/root//"
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

