output "namespace" {
  value = var.namespace
}

output "service_id" {
  value = kubernetes_service.nginx.id
}

output "service_name" {
  value = kubernetes_service.nginx.metadata[0].name
}

output "nginx_server_address" {
  value = "$(minikube ip):${kubernetes_service.nginx.spec[0].port[0].node_port}"
}
