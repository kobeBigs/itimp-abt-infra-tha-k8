resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "${local.application_name}-deployment"
    namespace = var.namespace
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "${local.application_name}-container"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "${local.application_name}-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = local.application_name
    }
    type = "NodePort"
    port {
      port        = local.service_port
      target_port = local.service_port
      node_port   = var.node_port_nginx
      protocol    = "TCP"
    }
  }
}
