output "instance_id"     { value = module.ec2.instance_id }
output "public_ip"       { value = module.ec2.public_ip }
output "vpc_id"          { value = module.vpc.vpc_id }
output "security_group"  { value = module.sg.security_group_id }
output "volume_id"       { value = module.ebs.volume_id }
output "iam_role_arn"    { value = module.iam.role_arn }
output "iam_policy_arn"  { value = module.iam.policy_arn }
output "s3_bucket_id"    { value = module.s3.bucket_id }
