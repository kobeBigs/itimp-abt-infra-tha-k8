variable "namespace_name" {
  type = string
}

variable "postgres_username" {
  sensitive = true
  type      = string
}

variable "postgres_password" {
  sensitive = true
  type      = string
}

variable "postgres_user_password" {
  sensitive = true
  type      = string
}

variable "postgres_database" {
  sensitive = true
  type      = string
}

variable "postgres_repmgr_username" {
  sensitive = true
  type      = string
}

variable "postgres_repmgr_password" {
  sensitive = true
  type      = string
}

variable "postgres_repmgr_database" {
  sensitive = true
  type      = string
}

variable "postgres_pgpool_admin_username" {
  sensitive = true
  type      = string
}

variable "postgres_pgpool_admin_password" {
  sensitive = true
  type      = string
}

variable "postgres_replica_count" {
  type = number
  validation {
    condition     = var.postgres_replica_count >= 3 && var.postgres_replica_count % 2 == 1
    error_message = "postgres replica count must be an odd number with minimum value of 3"
  }
}

variable "postgres_storage_size_in_gb" {
  type = number
  validation {
    condition     = var.postgres_storage_size_in_gb >= 0.5
    error_message = "minimum postgres storage size in giga byte is 0.5"
  }
}

variable "kubernetes_postgres_secret_name" {
  sensitive = true
  type      = string
}

variable "kubernetes_postgres_secret_password_key" {
  sensitive = true
  type      = string
}

# variable "kubernetes_postgres_secret_postgres_password_key" {
#   type = string
# }

# variable "kubernetes_postgres_secret_repmgr_password_key" {
#   type = string
# }

# variable "kubernetes_pgpool_secret_admin_password_key" {
#   type = string
# }

variable "helm_postgres_deployment_name" {
  type = string
}

variable "helm_postgres_chart_name" {
  type = string
}

variable "stage" {
  description = "Stage of the current environment"
}

variable "storage_class" {
  description = "Name of the storage class"
  type        = string
  default     = "standard"
}
