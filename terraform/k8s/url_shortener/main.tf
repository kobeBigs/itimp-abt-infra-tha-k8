# create kubernetes namespace
resource "kubernetes_deployment" "url_shortener" {

  metadata {
    name      = "${local.application_name}-deployment"
    namespace = var.namespace
    labels = {
      app = local.application_name
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = local.application_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.application_name
        }
      }

      spec {
        container {
          name  = "${local.application_name}-container"
          image = "aria3ppp/url-shortener"

          port {
            container_port = 8080
          }

          # envs
          env {
            name  = "SERVER_PORT"
            value = local.service_port
          }
          env {
            name  = "POSTGRES_USER"
            value = var.postgres_username
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = local.kubernetes_postgres_secret_name
                key  = local.kubernetes_postgres_secret_password_key
              }
            }
          }
          env {
            name  = "POSTGRES_HOST"
            value = "${local.helm_postgres_deployment_name}-${local.helm_postgres_chart_name}-pgpool"
          }
          env {
            name = "POSTGRES_PORT"
            value = 5432
          }
          env {
            name  = "POSTGRES_DB"
            value = var.postgres_database
          }

          # healthcheck
          liveness_probe {
            http_get {
              path = local.liveness_readiness_path
              port = local.service_port
            }
            initial_delay_seconds = 20
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = local.liveness_readiness_path
              port = local.service_port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }
        }

      }
    }
  }
}

resource "kubernetes_service" "url_shortener" {
  depends_on = [
    kubernetes_deployment.url_shortener,
  ]

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
      node_port   = var.node_port_url_shortener
      protocol    = "TCP"
      name        = "http"
    }
  }
}

module "postgres_db" {
  source         = "./postgres_db"
  namespace_name = var.namespace
  stage          = var.stage

  storage_class = var.storage_class

  kubernetes_postgres_secret_name         = local.kubernetes_postgres_secret_name
  kubernetes_postgres_secret_password_key = local.kubernetes_postgres_secret_password_key

  postgres_replica_count      = var.postgres_replica_count
  postgres_storage_size_in_gb = var.postgres_storage_size_in_gb

  postgres_database = var.postgres_database
  postgres_password = var.postgres_password

  postgres_username      = var.postgres_username
  postgres_user_password = var.postgres_user_password

  postgres_repmgr_database = var.postgres_repmgr_database
  postgres_repmgr_username = var.postgres_repmgr_username
  postgres_repmgr_password = var.postgres_repmgr_password

  postgres_pgpool_admin_username = var.postgres_pgpool_admin_username
  postgres_pgpool_admin_password = var.postgres_pgpool_admin_password

  helm_postgres_deployment_name = local.helm_postgres_deployment_name
  helm_postgres_chart_name      = local.helm_postgres_chart_name
}
