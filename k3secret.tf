resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "aws_creds" {
  metadata {
    name      = "grafana-aws-creds"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    access_key = aws_iam_access_key.grafana_key.id
    secret_key = aws_iam_access_key.grafana_key.secret
  }

  type = "Opaque"
}