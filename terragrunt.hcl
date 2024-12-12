# Generate an k8s provider block. You can run `minikube ip` to get the local ip address.
# And run `minikube config view` to get the certificates and key
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_version = ">= 0.13.0"
      required_providers {
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.27.0"
        }
        helm = {
          source  = "hashicorp/helm"
          version = "~> 2.9.0"
       }
      }
    }

    provider "kubernetes" {
      config_context = "minikube"
      config_path    = "~/.kube/config" 
    }

    provider "helm" {
      kubernetes {
        config_path = "~/.kube/config"
      }
    }
EOF
}

locals {   
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl", "not-found"))  
  environment = try(local.env_vars.locals.environment, "default")  
}  

remote_state {  
  backend = "local"  

  config = {  
    path = "${get_parent_terragrunt_dir()}/terraform.${local.environment}.tfstate"  
  }  

  generate = {  
    path      = "backend.tf"  
    if_exists = "overwrite"  
  }  
}