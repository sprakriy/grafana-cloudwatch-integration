resource "kubernetes_namespace" "arc_systems" {
  metadata {
    name = "arc-systems"
  }
}

# 1. The Controller (The Brain)
resource "helm_release" "gha_controller" {
  name       = "arc"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts" # ADD THIS
  chart      = "gha-runner-scale-set-controller"                        # SHORTEN THIS
  namespace  = kubernetes_namespace.arc_systems.metadata[0].name
}

# 2. The Runner Scale Set (The "Vanishing" part)
resource "helm_release" "gha_runner" {
  name       = "arc-runner-set"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts" # ADD THIS
  chart      = "gha-runner-scale-set"                                   # SHORTEN THIS
  namespace  = kubernetes_namespace.arc_systems.metadata[0].name

  set {
    name  = "githubConfigUrl"
    value = "https://github.com/sprakriy/grafana-cloudwatch-integration"
  }

  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = var.github_pat
  }

  set {
    name  = "minReplicas"
    value = "0"
  }

  depends_on = [helm_release.gha_controller]
}