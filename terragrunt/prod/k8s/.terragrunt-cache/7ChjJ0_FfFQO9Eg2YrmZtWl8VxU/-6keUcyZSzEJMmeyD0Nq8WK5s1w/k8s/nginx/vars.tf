variable "replica_count" {
  type = number
  validation {
    condition     = var.replica_count % 1 == 0 && var.replica_count >= 1
    error_message = "Replica count is a whole number with minimum value of 1"
  }
}

variable "namespace" {
  type        = string
  description = "Namespace, in which the application is deployed"
}

variable "node_port_nginx" {
  type        = string
  description = "node port for curl"
}
