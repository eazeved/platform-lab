include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/infra/modules/vpc"
}

inputs = {
  cidr               = "10.10.0.0/16"
  single_nat_gateway = true
}
