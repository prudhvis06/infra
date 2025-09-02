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
