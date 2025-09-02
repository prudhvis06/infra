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

