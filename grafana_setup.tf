resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
/*
  # Injecting the AWS Credentials for the CloudWatch Data Source
  set_sensitive {
    name  = "env.GF_AUTH_AWS_ACCESS_KEY"
    value = aws_iam_access_key.grafana_key.id
  }

  set_sensitive {
    name  = "env.GF_AUTH_AWS_SECRET_KEY"
    value = aws_iam_access_key.grafana_key.secret
  }

  set {
    name  = "env.GF_AUTH_AWS_REGION"
    value = "us-east-1" # Change this if your AWS resources are elsewhere
  }
*/

  # Service configuration to make it accessible in WSL
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  # This section automatically creates the CloudWatch connection inside Grafana
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "CloudWatch-AWS"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "cloudwatch"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].jsonData.authType"
    value = "keys"
  }
  set_sensitive {
    name  = "datasources.datasources\\.yaml.datasources[0].secureJsonData.accessKey"
    value = aws_iam_access_key.grafana_key.id
  }

  set_sensitive {
    name  = "datasources.datasources\\.yaml.datasources[0].secureJsonData.secretKey"
    value = aws_iam_access_key.grafana_key.secret
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].jsonData.defaultRegion"
    value = "us-east-1"
  }
}
