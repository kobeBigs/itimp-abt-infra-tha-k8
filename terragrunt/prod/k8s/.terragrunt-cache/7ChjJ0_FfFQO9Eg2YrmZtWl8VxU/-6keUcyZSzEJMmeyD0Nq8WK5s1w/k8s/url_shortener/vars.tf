variable "replica_count" {
  type = number
  validation {
    condition     = var.replica_count % 1 == 0 && var.replica_count >= 1
    error_message = "url-shortener replica count is a whole number with minimum value of 1"
  }
}

variable "namespace" {
  type        = string
  description = "Namespace, in which the application is deployed"
  default     = "postgres"
}

variable "stage" {
  type        = string
  description = "Stage of the current environment"
  default     = "dev"
}

variable "storage_class" {
  description = "Name of the storage class"
}

variable "postgres_database" {
  sensitive   = true
  type        = string
  description = "Postgres database name"
}

variable "postgres_password" {
  sensitive   = true
  type        = string
  description = "Postgres password"
}

variable "postgres_username" {
  sensitive   = true
  type        = string
  description = "Postgres username"
}

variable "postgres_user_password" {
  sensitive   = true
  type        = string
  description = "Postgres user password"
}

variable "postgres_repmgr_database" {
  sensitive   = true
  type        = string
  description = "Postgres repmgr database name"
}

variable "postgres_repmgr_username" {
  sensitive   = true
  type        = string
  description = "Postgres repmgr user name"
}

variable "postgres_repmgr_password" {
  sensitive   = true
  type        = string
  description = "Postgres repmgr user password"
}

variable "postgres_pgpool_admin_username" {
  sensitive   = true
  type        = string
  description = "Postgres pgpool admin name"
}

variable "postgres_pgpool_admin_password" {
  sensitive   = true
  type        = string
  description = "Postgres pgpool admin password"
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

variable "node_port_url_shortener" {
  type        = string
  description = "node port for curl"
}