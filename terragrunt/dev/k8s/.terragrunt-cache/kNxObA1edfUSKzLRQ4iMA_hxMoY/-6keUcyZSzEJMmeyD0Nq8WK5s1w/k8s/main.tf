resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "${var.stage}-namespace"
  }
}

resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "${var.stage}-storage"
  }

  storage_provisioner = "k8s.io/minikube-hostpath"
  volume_binding_mode = "Immediate"
  reclaim_policy      = "Delete"
}

resource "kubernetes_ingress_v1" "ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "nginx-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "${var.stage}-nginx.info"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = module.nginx.service_name
              port {
                number = local.nginx_service_port
              }
            }
          }
        }
      }
    }
    rule {
      host = "${var.stage}-url-shortener.info"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = module.url_shortener.service_name
              port {
                number = local.url_shortener_service_port
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    module.nginx,
    module.url_shortener
  ]
}

module "nginx" {
  source = "./nginx"

  replica_count = var.replica_count

  namespace = kubernetes_namespace.namespace.metadata[0].name

  node_port_nginx = var.node_port_nginx 

  depends_on = [kubernetes_namespace.namespace]
}

module "url_shortener" {
  source = "./url_shortener"
  stage  = var.stage

  replica_count = var.replica_count

  namespace = kubernetes_namespace.namespace.metadata[0].name

  storage_class = kubernetes_storage_class.storage_class.metadata[0].name

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

  node_port_url_shortener = var.node_port_url_shortener

  depends_on = [
    kubernetes_namespace.namespace,
    kubernetes_storage_class.storage_class
  ]
}
