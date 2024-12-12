# create kubernetes postgres secret
resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = var.kubernetes_postgres_secret_name
    namespace = var.namespace_name
  }

  type = "Opaque"

  data = {
    "${var.kubernetes_postgres_secret_password_key}" = var.postgres_password
    "postgres-password"                              = var.postgres_user_password
    "repmgr-password"                                = var.postgres_repmgr_password
  }
}

# create kubernetes pgpool secret
resource "kubernetes_secret" "pgpool_secret" {
  metadata {
    name      = "pgpool-secret"
    namespace = var.namespace_name
  }

  type = "Opaque"

  data = {
    "admin-password" = var.postgres_pgpool_admin_password
  }
}

###################
# HELM - POSTGRES #
###################

# deploy postgres helm chart with replicas
resource "helm_release" "postgres_deployment" {
  depends_on = [
    kubernetes_secret.postgres_secret,
    kubernetes_secret.pgpool_secret,
  ]

  name       = var.helm_postgres_deployment_name
  namespace  = var.namespace_name
  repository = "https://charts.bitnami.com/bitnami"

  chart   = var.helm_postgres_chart_name
  version = "11.2.1"

  # override default values
  values = [yamlencode({
    postgresql = {
      replicaCount   = var.postgres_replica_count
      existingSecret = kubernetes_secret.postgres_secret.metadata[0].name
      username       = var.postgres_username
      database       = var.postgres_database
      repmgrUsername = var.postgres_repmgr_username
      repmgrDatabase = var.postgres_repmgr_database
    }
    pgpool = {
      adminUsername  = var.postgres_pgpool_admin_username
      existingSecret = kubernetes_secret.pgpool_secret.metadata[0].name
    }
    persistence = {
      enabled      = true
      storageClass = var.storage_class
      size         = "${var.postgres_storage_size_in_gb}Gi"
      accessModes = [
        "ReadWriteMany",
      ]
    }
  })]
}
