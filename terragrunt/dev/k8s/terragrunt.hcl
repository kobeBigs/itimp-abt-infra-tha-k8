locals {
  #stage            = local.environment_vars.locals.environment
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  stage            = local.environment_vars.locals.environment
}

terraform {
  #source = "../../terraform//k8s"
  source = "${get_parent_terragrunt_dir("root")}/terraform//k8s/"
}

inputs = {
  stage = local.stage
  
  replica_count = 2

  postgres_replica_count      = 3
  postgres_storage_size_in_gb = 0.5

  postgres_database = "db"
  postgres_password = "dev"

  postgres_username = "postgres"
  postgres_user_password = "dev"

  postgres_repmgr_database = "repmgr"
  postgres_repmgr_username = "repmgr"
  postgres_repmgr_password = "dev"

  postgres_pgpool_admin_username = "admin"
  postgres_pgpool_admin_password = "dev"

  node_port_nginx         = 30201
  node_port_url_shortener = 30301
}

include "root" {
  path = find_in_parent_folders()
}