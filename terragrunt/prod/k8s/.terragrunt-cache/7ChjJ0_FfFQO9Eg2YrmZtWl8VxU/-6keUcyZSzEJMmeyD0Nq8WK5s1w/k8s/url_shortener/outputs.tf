output "service_name" {
  value = kubernetes_service.url_shortener.metadata[0].name
}

output "url-shortener_server_address" {
  value = "$(minikube ip):${kubernetes_service.url_shortener.spec[0].port[0].node_port}"
}
