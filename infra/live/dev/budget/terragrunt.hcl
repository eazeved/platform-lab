include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/infra/modules/budget"
}

inputs = {
  limit_usd = 20
  email     = "eazevedo@bsd.com.br"
}
