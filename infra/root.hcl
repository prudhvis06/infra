# infra/root.hcl - Terragrunt root config for local testing

remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

locals {
  common_tags = {
    Project = "LocalTest"
    Owner   = "DevTeam"
  }
}

