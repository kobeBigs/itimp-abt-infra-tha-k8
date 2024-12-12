locals {
  application_name = "url-shortener"

  helm_postgres_deployment_name = "postgres-release"
  helm_postgres_chart_name      = "postgresql-ha"

  kubernetes_postgres_secret_name         = "postgres-secret"
  kubernetes_postgres_secret_password_key = "password"

  service_port = 8080
}
